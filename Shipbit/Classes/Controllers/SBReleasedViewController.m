//
//  SBReleasedViewController.m
//  Shipbit
//
//  Created by Patrick Mick on 5/5/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SBReleasedViewController.h"
#import "SBCoreDataController.h"
#import "SBSyncEngine.h"
#import "SBGameDetailViewController.h"
#import "SBGameCell+ConfigureForGame.h"
#import "FetchedDataSource.h"

#define YEAR_MULTIPLIER 1000
#define CELL_HEIGHT 110

NSString * const kSBSelectedKey = @"selected";

@interface SBReleasedViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) SBGameDetailViewController *gdvc;
@property (nonatomic, strong) NSArray *selected;
@property (nonatomic, strong) FetchedDataSource *dataSource;

@end

@implementation SBReleasedViewController

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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = CELL_HEIGHT;
    
    [self.tableView setSeparatorColor:[UIColor colorWithHexValue:@"e5e0dd"]];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateFormat:@"MMM dd"];
    
    // Load selected from userdefaults if they exist
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kSBSelectedKey]) {
        _selected = [[NSUserDefaults standardUserDefaults] objectForKey:kSBSelectedKey];
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithHexValue:@"B1ABA7"];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setFrame:CGRectMake(0.0, 0.0, 45.0, 40.0)];
    [button1 addTarget:self action:@selector(platformsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button1 setTitle:NSLocalizedString(@"Platforms", nil) forState:UIControlStateNormal];
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:button1];
    [self.navigationItem setRightBarButtonItem:button];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(platformsUpdated:) name:@"PlatformsUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncCompleted:) name:@"SBSyncEngineSyncCompleted" object:nil];
    
    [self setupDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:YES];
}

#pragma mark - Table View Data Source

- (void)setupDataSource
{
    _dataSource = [[FetchedDataSource alloc] initWithFetchRequest:[self fetchRequest]
                                               sectionNameKeyPath:@"sectionIdentifier"
                                                   cellIdentifier:@"GameCell"
                                               configureCellBlock:^(id cell, id item) {
                                                   [cell configureForGame:item];
                                               }];
    [_dataSource setParent:self];
    
    self.tableView.dataSource = _dataSource;
}

- (NSFetchRequest *)fetchRequest
{
    // Create and configure a fetch request with the Game entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:[[SBCoreDataController sharedInstance] masterManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *sectionDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sectionIdentifier" ascending:NO];
    NSSortDescriptor *releaseDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"releaseDate" ascending:NO];
    NSSortDescriptor *alphabeticDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: sectionDescriptor, releaseDateDescriptor, alphabeticDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -3;
    NSDate *threeMonthsAgo = [calendar dateByAddingComponents:components toDate:now options:0];
    
    NSDateComponents *calComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:[NSDate date]]; // gets the year, month, and day for today's date
    NSDate *today = [calendar dateFromComponents:calComponents]; // makes a new NSDate keeping only the year, month, and day
    
    NSPredicate *predicate;
    
    if ([_selected count] > 0) {
        predicate = [NSPredicate predicateWithFormat:@"((releaseDate >= %@) AND (releaseDate < %@)) AND (ANY platforms.title IN %@)", threeMonthsAgo, today, _selected];
    } else if (!_selected) {
        predicate = [NSPredicate predicateWithFormat:@"(releaseDate >= %@) AND (releaseDate < %@)", threeMonthsAgo, today];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"title BEGINSWITH %@", @"zzzzzzz"];
        
    }
    
    [fetchRequest setPredicate:predicate];
    
    return fetchRequest;
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

#pragma mark - Table View Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    [headerView setBackgroundColor:[UIColor colorWithHexValue:@"B1ABA7" alpha:0.93f]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    headerLabel.shadowColor = [UIColor colorWithHexValue:@"000000" alpha:0.5f];
    headerLabel.frame = CGRectMake(11,-11, 320.0, 44.0);
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.shadowColor = [UIColor clearColor];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_dataSource.fetchedResultsController sections] objectAtIndex:section];
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

    [_gdvc prepareForReuse];
    [_gdvc.headerView.imageView setImage:((SBGameCell *)[self.tableView cellForRowAtIndexPath:indexPath]).thumbnailView.image];
    [_gdvc populateWithDataFromGame:[_dataSource itemAtIndexPath:indexPath]];
    
    [self.navigationController pushViewController:self.gdvc animated:YES];
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
    _selected = [[NSUserDefaults standardUserDefaults] objectForKey:kSBSelectedKey];
    [_dataSource resetFetchedResultsControllerForUpdatedRequest:[self fetchRequest]];
    [UIView transitionWithView: self.tableView
                      duration: 1.05f
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^(void) {
                        [self.tableView reloadData];
                    }
                    completion: ^(BOOL isFinished) {
                    }];
}

- (void)syncCompleted:(NSNotification *)note {
    [self.refreshControl endRefreshing];
    [_dataSource resetFetchedResultsControllerForUpdatedRequest:[self fetchRequest]];
    [self.tableView reloadData];
}

@end
