//
//  SBGameTableViewController.m
//  Shipbit
//
//  Created by Patrick Mick on 1/20/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "SBGameTableViewController.h"
#import "SBCoreDataController.h"
#import "SBGameCell.h"
#import "Game.h"
#import "SBGameDetailViewController.h"
#import "SBPlatformsTableViewController.h"
#import "SBSyncEngine.h"

#define UPCOMING_VIEW_CONTROLLER 1
#define YEAR_MULTIPLIER 1000
#define CELL_HEIGHT 100

@interface SBGameTableViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) SBGameDetailViewController *gdvc;
@property (nonatomic, strong) SBPlatformsTableViewController *ptvc;

@end

@implementation SBGameTableViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize dateFormatter = _dateFormatter;
@synthesize gdvc = _gdvc;
@synthesize ptvc = _ptvc;

@synthesize entityName = _entityName;
@synthesize games = _games;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize upcomingFetchedResultsController = _upcomingFetchedResultsController;
@synthesize releasedFetchedResultsController = _releasedFetchedResultsController;

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    // TODO implement shared logger to log memory warnings and deallocs
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark View Lifecycle

- (id)init {
    self = [super init];
    if(self) {
        self.title = NSLocalizedString(@"Games", @"");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _managedObjectContext = [[SBCoreDataController sharedInstance] masterManagedObjectContext];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSArray *segmentTextContent = [NSArray arrayWithObjects:@"Released", @"Upcoming", nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	segmentedControl.selectedSegmentIndex = UPCOMING_VIEW_CONTROLLER;
	segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = segmentedControl;
    
    UIBarButtonItem *platformsButton = [[UIBarButtonItem alloc] initWithTitle:@"Platforms" style:UIBarButtonItemStylePlain target:self action:@selector(platformsButtonPressed)];
    [self.navigationItem setLeftBarButtonItem:platformsButton];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    _fetchedResultsController = self.upcomingFetchedResultsController;
    
}

#pragma mark -
#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    /*
     Section information derives from an event's sectionIdentifier, which is a string representing the number (year * 1000) + month.
     To display the section title, convert the year and month components to a string representation.
     */
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
	
	return titleString;
}

- (void)configureCell:(SBGameCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Game *game = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = game.title;
    cell.releaseDateLabel.text = [self.dateFormatter stringFromDate:game.releaseDate];
    cell.platformsLabel.text = [[NSKeyedUnarchiver unarchiveObjectWithData:game.platforms] componentsJoinedByString:@", "];
    [cell.thumbnailView setImageWithURL:[NSURL URLWithString:game.art]
                       placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

#pragma mark -
#pragma mark - Table View Delegate

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

#pragma mark -
#pragma mark Fetched Results Controller Configuration

/*
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)upcomingFetchedResultsController {
    if (_upcomingFetchedResultsController != nil) {
        return _upcomingFetchedResultsController;
        
    }
    
    // Create and configure a fetch request with the Game entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entityName inManagedObjectContext:_managedObjectContext];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(releaseDate >= %@) AND (releaseDate <= %@)", now, twoYearsFromNow];
    [fetchRequest setPredicate:predicate];
    
    // Create and initialize the fetch results controller.
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:@"sectionIdentifier" cacheName:@"GameCache"];
    aFetchedResultsController.delegate = self;
    _upcomingFetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    [NSFetchedResultsController deleteCacheWithName:@"GameCache"];
    if (![_upcomingFetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _upcomingFetchedResultsController;
}

/*
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)releasedFetchedResultsController {
    if (_releasedFetchedResultsController != nil) {
        return _releasedFetchedResultsController;
        
    }
    
    // Create and configure a fetch request with the Game entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entityName inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *sectionDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sectionIdentifier" ascending:NO];
    NSSortDescriptor *releaseDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"releaseDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: sectionDescriptor, releaseDateDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -3;
    NSDate *threeMonthsAgo = [calendar dateByAddingComponents:components toDate:now options:0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(releaseDate >= %@) AND (releaseDate <= %@)", threeMonthsAgo, now];
    
    [fetchRequest setPredicate:predicate];
    
    // Create and initialize the fetch results controller.
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:@"sectionIdentifier" cacheName:@"GameCache"];
    aFetchedResultsController.delegate = self;
    _releasedFetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    [NSFetchedResultsController deleteCacheWithName:@"GameCache"];
    if (![_releasedFetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _releasedFetchedResultsController;
}

#pragma mark -
#pragma mark Fetched Results Controller Delegates

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

#pragma mark -
#pragma mark Action Methods

- (IBAction)segmentAction:(id)sender {
	// The segmented control was clicked, handle it here
    // Using a single fetched results controller between both segments
    // Changing what controller represents on segment change
	switch([(UISegmentedControl *)sender selectedSegmentIndex]){
        case 0: {
            _fetchedResultsController = self.releasedFetchedResultsController;
            [self.tableView reloadData];
            break;
        }
        case 1: {
            _fetchedResultsController = self.upcomingFetchedResultsController;
            [self.tableView reloadData];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)platformsButtonPressed {
    if (!_ptvc) {
        _ptvc = [[SBPlatformsTableViewController alloc] init];
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_ptvc];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)refresh:(id)sender {
    [[SBSyncEngine sharedEngine] startSync];
    [(UIRefreshControl *)sender endRefreshing];
}

@end
