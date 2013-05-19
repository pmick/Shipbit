//
//  SBUpcomingViewController.m
//  Shipbit
//
//  Created by Patrick Mick on 5/6/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import "SBUpcomingViewController.h"
#import "Game.h"
#import "Platform.h"
#import "SBGameCell.h"
#import "SBGameDetailViewController.h"
#import "SBCoreDataController.h"
#import "SBSyncEngine.h"
#import "UIImage+Extras.h"

#define YEAR_MULTIPLIER 1000
#define CELL_HEIGHT 110

NSString * const kSBUpcomingSelectedKey = @"selected";

@interface SBUpcomingViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) SBGameDetailViewController *gdvc;
@property (nonatomic, strong) NSArray *selected;

@end

@implementation SBUpcomingViewController

#pragma mark - Memory Management

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View Lifecycle

- (id)init {
    self = [super init];
    if(self) {
        
        UILabel* label = [[UILabel alloc] init] ;
        label.text = NSLocalizedString(@"Upcoming", @"");
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        label.shadowColor = [UIColor clearColor];
        //label.shadowOffset = CGSizeMake(0, -1);
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        
        label.layer.shadowColor = [UIColor blackColor].CGColor;
        label.layer.shadowOpacity = .5;
        label.layer.shadowOffset = CGSizeMake(0, 1);
        label.layer.shadowRadius = .8;
        
        [label sizeToFit];
        self.navigationItem.titleView = label;
        
        self.title = NSLocalizedString(@"Upcoming", @"");
        self.tableView.rowHeight = CELL_HEIGHT;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    //[self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setDateFormat:@"MMM dd"];
    
    // Load selected in from userdefaults if it was saved
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kSBUpcomingSelectedKey]) {
        _selected = [[NSUserDefaults standardUserDefaults] objectForKey:kSBUpcomingSelectedKey];
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:(177.0/255.0) green:(171.0/255.0) blue:(167.0/255.0) alpha:0.97];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(10.0, 2.0, 45.0, 40.0)];
    [button1 addTarget:self action:@selector(platformsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button1 setImage:[UIImage imageNamed:@"navBarRightButton"] forState:UIControlStateNormal];
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:button1];
    [self.navigationItem setRightBarButtonItem:button];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(platformsUpdated:) name:@"PlatformsUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncCompleted:) name:@"SBSyncEngineSyncCompleted" object:nil];

}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(SBGameCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Game *game = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = game.title;
    cell.releaseDateLabel.text = [self.dateFormatter stringFromDate:game.releaseDate];
    cell.platformsLabel.text = game.platformsString;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    manager.delegate = self;
    
    [manager downloadWithURL:[NSURL URLWithString:game.art]
                     options:0
                    progress:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                       cell.thumbnailView.image = [image imageByScalingAndCroppingForSize:cell.thumbnailView.frame.size];
    }];

    [cell resizeSubviews];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SBGameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SBGameCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Table View Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    [headerView setBackgroundColor:[UIColor colorWithRed:(177.0/255.0) green:(171.0/255.0) blue:(167.0/255.0) alpha:0.97]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    headerLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    headerLabel.frame = CGRectMake(11,-12, 320.0, 44.0);
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.shadowColor = [UIColor clearColor];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    static NSArray *monthSymbols = nil;
    
    if (!monthSymbols) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setCalendar:[NSCalendar currentCalendar]];
        monthSymbols = [formatter monthSymbols];
    }
    
    NSInteger numericSection = [[sectionInfo name] integerValue];
    
	NSInteger year = numericSection / YEAR_MULTIPLIER;
	NSInteger month = numericSection - (year * YEAR_MULTIPLIER);
    
	NSString *titleString = [NSString stringWithFormat:@"%@ %d", [monthSymbols objectAtIndex:month-1], year];
        
    headerLabel.text = titleString;
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    _gdvc.platformsLabel.text = [game platformsString];
    
    [_gdvc.imageView setImageWithURL:[NSURL URLWithString:game.art]
                    placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    [_gdvc.tableView reloadData];
    [self.navigationController pushViewController:self.gdvc animated:YES];
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
    NSSortDescriptor *sectionDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sectionIdentifier" ascending:YES];
    NSSortDescriptor *releaseDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"releaseDate" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: sectionDescriptor, releaseDateDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = 2;
    NSDate *twoYearsFromNow = [calendar dateByAddingComponents:components toDate:now options:0];
    
    NSPredicate *predicate;
    
    if ([_selected count] > 0) {
        predicate = [NSPredicate predicateWithFormat:@"((releaseDate >= %@) AND (releaseDate <= %@)) AND (ANY platforms.title IN %@)", now, twoYearsFromNow, _selected];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"(releaseDate >= %@) AND (releaseDate <= %@)", now, twoYearsFromNow];
    }
    
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

#pragma mark - Custom Methods

- (void)refresh:(id)sender {
    [[SBSyncEngine sharedEngine] startSync];
}

- (void)platformsButtonPressed {
    if (_ptvc) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_ptvc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)platformsUpdated:(NSNotification *)note {
    _selected = [[NSUserDefaults standardUserDefaults] objectForKey:kSBUpcomingSelectedKey];
    self.fetchedResultsController = nil;
    [self.tableView reloadData]; //fetched results controller will be lazily recreated
}

- (void)syncCompleted:(NSNotification *)note {
    [self.refreshControl endRefreshing];
}

@end
