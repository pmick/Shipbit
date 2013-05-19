//
//  SBFavoritesTableViewController.m
//  Shipbit
//
//  Created by Patrick Mick on 1/26/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "SBFavoritesTableViewController.h"
#import "SBGameDetailViewController.h"
#import "SBGameCell.h"
#import "SBCoreDataController.h"
#import "Game.h"
#import "Platform.h"
#import "UIImage+Extras.h"

#define CELL_HEIGHT 110

@interface SBFavoritesTableViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) SBGameDetailViewController *gdvc;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


@end

@implementation SBFavoritesTableViewController

@synthesize dateFormatter = _dateFormatter;
@synthesize gdvc = _gdvc;

#pragma mark - Memory Management

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    // TODO implement shared logger to log memory warnings and deallocs
    [super didReceiveMemoryWarning];
}

#pragma mark - View Lifecycle

- (id)init {
    self = [super init];
    if(self) {
        self.title = NSLocalizedString(@"Watch List", nil);
        self.tableView.rowHeight = CELL_HEIGHT;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
}

- (void)viewWillDisappear:(BOOL)animated {
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(SBGameCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Game *game = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = game.title;
    cell.releaseDateLabel.text = [self.dateFormatter stringFromDate:game.releaseDate];
    cell.platformsLabel.text = game.platformsString;
    //[cell.thumbnailView setImageWithURL:[NSURL URLWithString:game.art]
    //                   placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    
    [manager downloadWithURL:[NSURL URLWithString:game.art]
                     options:0
                    progress:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                       cell.thumbnailView.image = [image imageByScalingAndCroppingForSize:cell.thumbnailView.frame.size];
                   }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FavoriteCell";
    SBGameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SBGameCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!_gdvc)
    {
        _gdvc = [[SBGameDetailViewController alloc] init];
    }
    Game *game = [_fetchedResultsController objectAtIndexPath:indexPath];

    [_gdvc setGame:game];
    _gdvc.titleLabel.text = game.title;
    _gdvc.releaseDateLabel.text = [_dateFormatter stringFromDate:game.releaseDate];
    [_gdvc.imageView setImageWithURL:[NSURL URLWithString:game.art]
                    placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    [_gdvc.tableView reloadData];
    [self.navigationController pushViewController:self.gdvc animated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Game *game = [_fetchedResultsController objectAtIndexPath:indexPath];
        game.isFavorite = NO;
        
        // Remove local notification if it exists
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<(int)[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
            if ([uid isEqualToString:game.objectId])
            {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                DDLogInfo(@"Deleting notification for event: %@", oneEvent.alertBody);
                break;
            }
        }

        NSError *error;
        if (![[[SBCoreDataController sharedInstance] masterManagedObjectContext] save:&error]) {
            // Handle the error.
            DDLogError(@"Saving changes failed: %@", error);
            
        }        
    }
}

#pragma mark - Fetched Results Controller Configuration

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Create and configure a fetch request with the Game entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:[[SBCoreDataController sharedInstance] masterManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *releaseDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"releaseDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: releaseDateDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -3;
    NSDate *threeMonthsAgo = [calendar dateByAddingComponents:components toDate:now options:0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavorite == %@", @YES];
    
    // TODO: update predicate
    
    [fetchRequest setPredicate:predicate];
    
    // Create and initialize the fetch results controller.
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[SBCoreDataController sharedInstance] masterManagedObjectContext] sectionNameKeyPath:@"sectionIdentifier" cacheName:@"GameCache"];
    aFetchedResultsController.delegate = self;
    _fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    [NSFetchedResultsController deleteCacheWithName:@"GameCache"];
    if (![_fetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        DDLogError(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - Fetched Results Controller Delegates

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    if (controller == _fetchedResultsController) {
        [self.tableView beginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if (controller == _fetchedResultsController) {
        UITableView *tableView = self.tableView;
        
        switch(type) {
                
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self configureCell:(SBGameCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    if (controller == _fetchedResultsController) {
        switch(type) {
                
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    if (controller == _fetchedResultsController) {
        [self.tableView endUpdates];
    }
}

#pragma mark - Action Methods

@end
