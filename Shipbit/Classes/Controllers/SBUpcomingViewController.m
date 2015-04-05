//
//  SBUpcomingViewController.m
//  Shipbit
//
//  Created by Patrick Mick on 5/6/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SBUpcomingViewController.h"
#import "SBGameDetailViewController.h"
#import "SBCoreDataController.h"
#import "SBSyncEngine.h"
#import "SBGameCell+ConfigureForGame.h"
#import "SBGameTableViewCell.h"
#import "SBGameTableViewCell+ConfigureForGame.h"
#import "SBConstants.h"

#define YEAR_MULTIPLIER 1000

NSString * const kSBUpcomingSelectedKey = @"selected";

@interface SBUpcomingViewController ()

@property (nonatomic, strong) SBGameDetailViewController *gdvc;
@property (nonatomic, strong) NSArray *selected;
@property (nonatomic, strong) FetchedDataSource *dataSource;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;

@end

@implementation SBUpcomingViewController

#pragma mark - Memory Management

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = kSBGameTableViewCellHeight;
    
    [self.tableView setSeparatorColor:[UIColor colorWithHexValue:@"e5e0dd"]];
    
    // Load selected in from userdefaults if it was saved
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kSBUpcomingSelectedKey]) {
        _selected = [[NSUserDefaults standardUserDefaults] objectForKey:kSBUpcomingSelectedKey];
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    UIBarButtonItem *platformsItem;
    platformsItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Platforms", nil)
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(platformsButtonPressed:)];
    
    [self.navigationItem setRightBarButtonItem:platformsItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(platformsUpdated:) name:@"PlatformsUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncCompleted:) name:@"SBSyncEngineSyncCompleted" object:nil];
        
    self.tableView.delegate = self;
    [self setupDataSource];
}

- (void)setupDataSource
{
    UINib *nib = [UINib nibWithNibName:@"SBGameTableViewCell" bundle:[NSBundle bundleForClass:[self class]]];
    [self.tableView registerNib:nib forCellReuseIdentifier:kSBGameTableViewCellReuseIdentifier];
    
    _dataSource = [[FetchedDataSource alloc]
                   initWithFetchRequest:[self fetchRequest]
                   sectionNameKeyPath:@"sectionIdentifier"
                   cellIdentifier:kSBGameTableViewCellReuseIdentifier
                   configureCellBlock:^(SBGameTableViewCell *cell, Game *item) {
                       [cell configureForGame:item];
                   }];
    [_dataSource setParent:self];
    
    self.tableView.dataSource = _dataSource;
}

#pragma mark - Fetch

- (NSFetchRequest *)fetchRequest
{
    // Create and configure a fetch request with the Game entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:[[SBCoreDataController sharedInstance] masterManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    // Create the sort descriptors array.
    NSSortDescriptor *sectionDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sectionIdentifier" ascending:YES];
    NSSortDescriptor *releaseDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"releaseDate" ascending:YES];
    NSSortDescriptor *alphabeticDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: sectionDescriptor, releaseDateDescriptor, alphabeticDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:20];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = 2;
    NSDate *twoYearsFromNow = [calendar dateByAddingComponents:components toDate:now options:0];
    
    NSDateComponents *calComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay)
                                                  fromDate:[NSDate date]]; // gets the year, month, and day for today's date
    NSDate *today = [calendar dateFromComponents:calComponents]; // makes a new NSDate keeping only the year, month, and day
    
    NSPredicate *predicate;
    
    if ([_selected count] > 0) {
        predicate = [NSPredicate predicateWithFormat:@"((releaseDate >= %@) AND (releaseDate <= %@)) AND (ANY platforms.title IN %@)", today, twoYearsFromNow, _selected];
    } else if (!_selected) {
        predicate = [NSPredicate predicateWithFormat:@"(releaseDate >= %@) AND (releaseDate <= %@)", today, twoYearsFromNow];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"title BEGINSWITH %@", @"zzzzzzz"];
    }
    
    [fetchRequest setPredicate:predicate];
    
    return fetchRequest;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!_gdvc)
    {
        _gdvc = [[SBGameDetailViewController alloc] init];
    }
    
    [_gdvc prepareForReuse];
    [_gdvc.headerView.imageView setImage:((SBGameCell *)[self.tableView cellForRowAtIndexPath:indexPath]).thumbnailView.image];
    [_gdvc populateWithDataFromGame:[_dataSource itemAtIndexPath:indexPath]];
    
    [self.navigationController pushViewController:_gdvc animated:YES];
}

#pragma mark - Action Methods

- (void)refresh:(id)sender {
    [[SBSyncEngine sharedEngine] startSync];
    [self.tableView reloadData];
}

- (void)platformsButtonPressed:(id)sender {
    if (_ptvc) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_ptvc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - Notification Methods

- (void)platformsUpdated:(NSNotification *)note {
    _selected = [[NSUserDefaults standardUserDefaults] objectForKey:kSBUpcomingSelectedKey];
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


