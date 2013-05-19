//
//  SBGameDetailViewController.m
//  Shipbit
//
//  Created by Patrick Mick on 1/20/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBGameDetailViewController.h"
#import "SBRatingCell.h"
#import "SBSummaryCell.h"
#import "SBInfoCell.h"
#import "SBCoreDataController.h"
#import "SBSyncEngine.h"
#import <SystemConfiguration/SystemConfiguration.h>

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 280.0f
#define CELL_CONTENT_MARGIN 24.0f
#define CELL_CONTENT_HEIGHT_MAXIMUM 20000.0f

@interface SBGameDetailViewController ()

@property (nonatomic, strong) SBRatingCell *ratingCell;
@property (nonatomic, strong) SBSummaryCell *summaryCell;
@property (nonatomic, strong) SBInfoCell *infoCell;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *favoriteButton;
@property (nonatomic, strong) UIView *headerView;

@end

@implementation SBGameDetailViewController

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Lifecycle

- (id)init {
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Info", nil);
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 215.0)];
        [_headerView setBackgroundColor:[UIColor lightGrayColor]];
        
        [self.tableView setTableHeaderView:_headerView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 98.0, 136.0)];
    [_imageView setContentMode:UIViewContentModeCenter];
    [_imageView setBackgroundColor:[UIColor darkGrayColor]];
    [_headerView addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 10.0, 200.0, 46.0)];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [_titleLabel setNumberOfLines:2];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_headerView addSubview:_titleLabel];
    
    _releaseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 60.0, 200.0, 16.0)];
    [_releaseDateLabel setFont:[UIFont systemFontOfSize:14]];
    [_releaseDateLabel setTextAlignment:NSTextAlignmentLeft];
    [_releaseDateLabel setBackgroundColor:[UIColor clearColor]];
    [_headerView addSubview:_releaseDateLabel];
    
    _platformsLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 100.0, 200.0, 50.0)];
    [_platformsLabel setNumberOfLines:0];
    [_platformsLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_platformsLabel setFont:[UIFont systemFontOfSize:14]];
    [_platformsLabel setTextAlignment:NSTextAlignmentLeft];
    [_platformsLabel setBackgroundColor:[UIColor clearColor]];
    [_headerView addSubview:_platformsLabel];
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_likeButton setFrame:CGRectMake(10.0, 160.0, 145.0, 45.0)];
    [_likeButton setTitle:NSLocalizedString(@"Like", nil) forState:UIControlStateNormal];
    [_likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_likeButton];
    
    _favoriteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_favoriteButton setFrame:CGRectMake(165.0, 160.0, 145.0, 45.0)];

    [_favoriteButton addTarget:self action:@selector(favoriteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_favoriteButton];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
    // scrollRectToVisible necessary for changing games. Previously if you scrolled to the bottom of the table for 1 game, and then looked at another game, the view was reused, and the tableview would be scrolled down.
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_game.hasLiked) {
        [_likeButton setEnabled:NO];
    } else {
        [_likeButton setEnabled:YES];
    }
    
    NSString *favoriteButtonText = _game.isFavorite ? NSLocalizedString(@"Unwatch", nil) : NSLocalizedString(@"Add to Watchlist", nil);
    [_favoriteButton setTitle:favoriteButtonText forState:UIControlStateNormal];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            if (_ratingCell == nil) {
                _ratingCell = [[SBRatingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RatingCell"];
            }
            
            if (_game.likes) {
                _ratingCell.likeLabel.text = [NSString stringWithFormat:@"%@", _game.likes];
            } else {
                _ratingCell.likeLabel.text = [NSString stringWithFormat:@"%d", 0];
            }
            
            if ([_game.criticScore integerValue] > 0) {
                _ratingCell.metacriticRatingLabel.text = [NSString stringWithFormat:@"%@", _game.criticScore];
            } else {
                _ratingCell.metacriticRatingLabel.text = NSLocalizedString(@"Not yet rated.", nil);
            }
            
            cell = _ratingCell;
            break;
        case 1:
            if (_summaryCell == nil) {
                _summaryCell = [[SBSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SummaryCell"];
            }
            
            if (_game.summary) {
                _summaryCell.summaryLabel.text = _game.summary;
            } else {
                _summaryCell.summaryLabel.text = NSLocalizedString(@"No summary just yet...", nil);
            }
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 20000.0f);
            CGSize size = [_summaryCell.summaryLabel.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            CGRect newFrame = _summaryCell.summaryLabel.frame;
            newFrame.size.height = size.height;
            _summaryCell.summaryLabel.frame = newFrame;
            cell = _summaryCell;
            break;
        case 2:
            if (_infoCell == nil) {
                _infoCell = [[SBInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InfoCell"];
            }
            _infoCell.genreLabel.text = _game.genre;
            _infoCell.publisherLabel.text = _game.publisher;
            _infoCell.developerLabel.text = _game.developer;
            _infoCell.esrbLabel.text = _game.esrb ? _game.esrb : NSLocalizedString(@"RP", nil);
            _infoCell.platformsLabel.text = _game.platformsString;
            cell = _infoCell;
            break;
        default:
            break;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
    switch (indexPath.row) {
        case 0:
            return 88;
            break;
        case 1: {
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, CELL_CONTENT_HEIGHT_MAXIMUM);
            CGSize size = [_game.summary sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat height = MAX(size.height, 30.0f);
            return height + (CELL_CONTENT_MARGIN * 2);
            break;
        }
        case 2:
            return 138;
            break;
        default:
            return 55;
            break;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO implement selection functionality for metacritic links and other web links
}

#pragma mark - Action Methods

- (IBAction)likeButtonPressed:(id)sender {
    // TODO: keep from liking when you are not connected
    
    // Increment likes on server
    [[SBSyncEngine sharedEngine] incrementLikesByOneForObjectWithId:_game.objectId];
    
    // Increment likes locally
    _game.likes = @(_game.likes.integerValue + 1);
    
    // Update label to reflect increment on likes
    [self.tableView reloadData];
    
    // Set game as liked
    _game.hasLiked = @YES;
    
    // Update coredata
    NSError *error;
    if (![[[SBCoreDataController sharedInstance] masterManagedObjectContext] save:&error]) {
        // Handle the error.
        DDLogError(@"Saving changes failed: %@", error);
    }
    
    [_likeButton setEnabled:NO];
}

- (IBAction)favoriteButtonPressed:(id)sender {
    if (_game.isFavorite) {
        // Set isFavorite to NO
        _game.isFavorite = NO;
        
        // Remove local notification
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<(int)[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
            if ([uid isEqualToString:_game.objectId])
            {
                //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
                DDLogInfo(@"Deleting notification for event: %@", oneEvent.alertBody);
                break;
            }
        }
        
    } else {
        // Update local coredata store
        _game.isFavorite = @YES;
        
        // Create a local notification
        UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init];
        if (notifyAlarm) {
            notifyAlarm.fireDate = [_game.releaseDate dateByAddingTimeInterval:-3600*9];
            notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
            notifyAlarm.repeatInterval = 0;
            notifyAlarm.alertBody = [NSString stringWithFormat:@"%@ is released tomorrow!", _game.title];
            NSDictionary *userInfo = @{@"uid": [NSString stringWithFormat:@"%@", _game.objectId]};
            notifyAlarm.userInfo = userInfo;
            [[UIApplication sharedApplication] scheduleLocalNotification:notifyAlarm];
        }
        
        DDLogInfo(@"Created a local notification for %@ at %@", _game.title, [_game.releaseDate dateByAddingTimeInterval:-3600*9]);
        
    }
    
    // Save data store
    NSError *error;
    if (![[[SBCoreDataController sharedInstance] masterManagedObjectContext] save:&error]) {
        // Handle the error.
        DDLogError(@"Saving changes failed: %@", error);
    }
    
    NSString *favoriteButtonText = _game.isFavorite ? NSLocalizedString(@"Unwatch", nil) : NSLocalizedString(@"Add to Watchlist", nil);
    // Update button appearance
    [self.favoriteButton setTitle:favoriteButtonText forState:UIControlStateNormal];
    
}

#pragma mark - Testing internet connection


@end
