//
//  SBGameDetail2ViewController.m
//  Shipbit
//
//  Created by Patrick Mick on 5/19/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBGameDetailViewController.h"
#import "SDSegmentedControl.h"
#import "SBCoreDataController.h"
#import "SBSyncEngine.h"
#import "NSDate+Utilities.h"

@interface SBGameDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SDSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end

@implementation SBGameDetailViewController {
    BOOL _pressed;

}

- (id)init {
    self = [super init];
    if (self) {
        [self setTitle:NSLocalizedString(@"Details", nil)];
        
        _headerView = [[SBGameDetailHeaderView alloc] init];
        [self.view addSubview:_headerView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateFormat:@"MMM dd, yyyy"];
    
    [self.view setBackgroundColor:[UIColor colorWithHexValue:@"C4BEBA"]];
    
    [_headerView.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.watchlistButton addTarget:self action:@selector(watchlistButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupNavigationBar];
    [self setupSegmentedController];
    [self setupScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    _headerView.game = _game;
    
    if (_game.hasLiked) {
        [_headerView.likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
    } else {
        [_headerView.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }
    
    if (_game.isFavorite) {
        [_headerView.watchlistButton setImage:[UIImage imageNamed:@"watched"] forState:UIControlStateNormal];
    } else {
        [_headerView.watchlistButton setImage:[UIImage imageNamed:@"watch"] forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [_segmentedControl setSelectedSegmentIndex:0];
    [_scrollView setContentOffset:CGPointZero animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

- (void)setupNavigationBar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,40,45);
    [button setImage:[UIImage imageNamed:@"backButton"]
            forState:UIControlStateNormal];
    
    [button addTarget:self
               action:@selector(popView:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
}

- (void)setupSegmentedController {
    _segmentedControl = [[SDSegmentedControl alloc] initWithItems:@[ @"Summary", @"Info", @"Ratings" ]];
    [_segmentedControl setFrame:CGRectMake(0, 200, 320, 44)];
    [_segmentedControl setBackgroundColor:[UIColor colorWithHexValue:@"DCD6D2"]];
    _segmentedControl.arrowHeightFactor *= -1.0;
    [_segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
}

- (void)setupScrollView {
    UIColor *sbLightGrayColor = [UIColor colorWithHexValue:@"C4BEBA"];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 255, 320, 249)];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, 200);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [_scrollView setBackgroundColor:sbLightGrayColor];

    _verticalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 249)];
    _verticalScrollView.contentSize = CGSizeMake(320, 400);
    [_verticalScrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView addSubview:_verticalScrollView];
    
    float screenHeight = [[UIScreen mainScreen] applicationFrame].size.height;
    if (screenHeight < 548.0f) {
        DDLogInfo(@"DO SPECIAL STUFF");
        [_verticalScrollView setFrame:CGRectMake(0, 0, 320, 149)];
    }
    
    _summaryView = [[SBSummaryView alloc] initWithFrame:CGRectMake(0, 0, 320, 249)];
    [_summaryView setBackgroundColor:sbLightGrayColor];
    [_verticalScrollView addSubview:_summaryView];
    
    _infoView = [[SBInfoView alloc] initWithFrame:CGRectMake(320, 0, 320, 249)];
    [_infoView setBackgroundColor:sbLightGrayColor];
    [_scrollView addSubview:_infoView];
    
    _ratingView = [[SBRatingView alloc] initWithFrame:CGRectMake(320*2, 0, 320, 249)];
    [_ratingView setBackgroundColor:sbLightGrayColor];
    [_scrollView addSubview:_ratingView];
    
    [self.view addSubview:_scrollView];
}

#pragma mark - Scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_scrollView.contentOffset.x < 160) {
        [_segmentedControl setSelectedSegmentIndex:0];
    } else if (_scrollView.contentOffset.x >= 160 && _scrollView.contentOffset.x < 480) {
        [_segmentedControl setSelectedSegmentIndex:1];
    } else {
        [_segmentedControl setSelectedSegmentIndex:2];
    }
}

- (void)segmentChanged:(id)sender {
    // Setting delegate to nil until the animation completes so that the
    // view did scroll function is not called.
    _scrollView.delegate = nil;
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * ((SDSegmentedControl *)sender).selectedSegmentIndex;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.2f animations:^{
        [_scrollView scrollRectToVisible:frame animated:NO];
    } completion:^(BOOL finished) {
        _scrollView.delegate = self;
    }];
}

#pragma mark - Custom Methods
- (void)prepareForReuse {
    // Header
    self.headerView.titleLabel.text = nil;
    self.headerView.releaseDateLabel.text = nil;
    self.headerView.platformsLabel.text = nil;
    
    // Summary
    self.summaryView.summaryLabel.text = nil;
    
    // Info
    self.infoView.titleLabel.text = nil;
    self.infoView.releaseDateLabel.text = nil;
    self.infoView.genreLabel.text = nil;
    self.infoView.developerLabel.text = nil;
    self.infoView.publisherLabel.text = nil;
    self.infoView.esrbLabel.text = nil;
    self.infoView.platformsLabel.text = nil;
    
    // Ratings
    self.ratingView.likeLabel.text = nil;
    self.ratingView.metacriticRatingLabel.text = nil;
    self.ratingView.metacriticPath = nil;
    
    [_verticalScrollView setContentOffset:CGPointZero animated:NO];
    
    
}

- (void)populateWithDataFromGame:(Game *)game {
    [self setGame:game];
    self.headerView.titleLabel.text = game.title;
    self.headerView.releaseDateLabel.text = [_dateFormatter stringFromDate:game.releaseDate];
    self.headerView.platformsLabel.text = [game platformsString];
    
    self.summaryView.summaryLabel.text = game.summary;
    if (game.summary.length > 0) {
        self.summaryView.noSummaryImage.hidden = YES;
    } else {
        self.summaryView.noSummaryImage.hidden = NO;
    }
    
    self.infoView.titleLabel.text = game.title;
    self.infoView.releaseDateLabel.text = [_dateFormatter stringFromDate:game.releaseDate];
    
    if (game.genre) {
        self.infoView.genreLabel.text = game.genre;
        [self.infoView.genreLabel setTextColor:[UIColor colorWithHexValue:@"514d4a"]];
    } else {
        self.infoView.genreLabel.text = @"Not available";
        [self.infoView.genreLabel setTextColor:[UIColor colorWithHexValue:@"a59e99"]];
    }
    
    if (game.developer) {
        self.infoView.developerLabel.text = game.developer;
        [self.infoView.developerLabel setTextColor:[UIColor colorWithHexValue:@"514d4a"]];
    } else {
        self.infoView.developerLabel.text = @"Not available";
        [self.infoView.developerLabel setTextColor:[UIColor colorWithHexValue:@"a59e99"]];
    }
    
    if (game.publisher) {
        self.infoView.publisherLabel.text = game.publisher;
        [self.infoView.publisherLabel setTextColor:[UIColor colorWithHexValue:@"514d4a"]];
    } else {
        self.infoView.publisherLabel.text = @"Not available";
        [self.infoView.publisherLabel setTextColor:[UIColor colorWithHexValue:@"a59e99"]];
    }
    
    if (game.esrb) {
        self.infoView.esrbLabel.text = game.esrb;
        [self.infoView.esrbLabel setTextColor:[UIColor colorWithHexValue:@"514d4a"]];
    } else {
        self.infoView.esrbLabel.text = @"Not available";
        [self.infoView.esrbLabel setTextColor:[UIColor colorWithHexValue:@"a59e99"]];
    }
    
    
    self.infoView.platformsLabel.text = game.platformsString;
    
    if ([game.criticScore isEqualToNumber:@-1] || [game.criticScore isEqualToNumber:@0]) {
        self.ratingView.metacriticRatingLabel.text = @"Available when game is released.";
        // Light color text
        [self.ratingView.metacriticRatingLabel setTextColor:[UIColor colorWithHexValue:@"a59e99"]];
    } else {
        self.ratingView.metacriticRatingLabel.text = [NSString stringWithFormat:@"%@", game.criticScore];
        [self.ratingView.metacriticRatingLabel setTextColor:[UIColor colorWithHexValue:@"514d4a"]];
    }
    
    if ([game.likes isEqualToNumber:@0]) {
        self.ratingView.likeLabel.text = @"No likes yet.";
        // Light color text
        [self.ratingView.likeLabel setTextColor:[UIColor colorWithHexValue:@"a59e99"]];
    } else {
        self.ratingView.likeLabel.text = [NSString stringWithFormat:@"%@", game.likes];
        [self.ratingView.likeLabel setTextColor:[UIColor colorWithHexValue:@"514d4a"]];
    }
    
    self.ratingView.metacriticPath = game.link;
    
    //    [_gdvc.imageView setImageWithURL:[NSURL URLWithString:game.art]
    //                    placeholderImage:[UIImage imageNamed:nil]];
    //    [_gdvc.tableView reloadData];
    //    [self.navigationController pushViewController:self.gdvc animated:YES];
    
    [self.headerView resizeSubviews];
    [self.summaryView resizeSubviews];
    
    [self.verticalScrollView setContentSize:CGSizeMake(320.0f, self.summaryView.summaryLabel.frame.size.height+30.0f)];
}

- (void)popView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateLikeCount {
    DDLogInfo(@"Like count will update.");
    if (_game.hasLiked) {
        _game.likes = @(_game.likes.integerValue - 1);
        _game.hasLiked = NO;
        [_headerView.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    } else {
        _game.likes = @(_game.likes.integerValue + 1);
        _game.hasLiked = @YES;
        [_headerView.likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
    }
    
    [self populateWithDataFromGame:_game];
}

- (void)likeButtonPressed:(id)sender {
    if (!_pressed) {
        _pressed = YES;
        if (_game.hasLiked) {
            [[SBSyncEngine sharedEngine] decrementLikesByOneForObjectWithId:_game.objectId completionBlock:^(bool success) {
                if (success) {
                    [self updateLikeCount];
                } else {
                    DDLogInfo(@"Could not dislike");
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Network Problem"
                                                                      message:@"You need an internet connection to be able to unlike a game."
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                }
                _pressed = NO;
            }];
            
        } else {
            // Increment likes on server
            [[SBSyncEngine sharedEngine] incrementLikesByOneForObjectWithId:_game.objectId completionBlock:^(bool success) {
                if (success) {
                    [self updateLikeCount];
                } else {
                    DDLogInfo(@"Could not like");
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Network Problem"
                                                                      message:@"You need an internet connection to be able to like a game."
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                    [message show];
                }
                _pressed = NO;
            }];
        }
    }
}

- (void)removeLocalNotificationForGame:(Game *)game
{
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
}

- (void)addLocalNotificationForGame:(Game *)game
{
    if ([game.releaseDate isInFuture]) {
        UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init];
        notifyAlarm.fireDate = [game.releaseDate dateByAddingTimeInterval:-(3600*9)];
        notifyAlarm.timeZone = [NSTimeZone systemTimeZone];
        notifyAlarm.repeatInterval = 0;
        notifyAlarm.alertBody = [NSString stringWithFormat:@"%@ is released tomorrow!", game.title];
        NSDictionary *userInfo = @{@"uid": [NSString stringWithFormat:@"%@", game.objectId]};
        notifyAlarm.userInfo = userInfo;
        [[UIApplication sharedApplication] scheduleLocalNotification:notifyAlarm];
        
        DDLogInfo(@"Created a local notification for %@ at %@", game.title, [game.releaseDate dateByAddingTimeInterval:-(3600*9)]);
    }
}

- (void)watchlistButtonPressed:(id)sender {
    if (_game.isFavorite) {
        // Set isFavorite to NO
        _game.isFavorite = NO;
        [_headerView.watchlistButton setImage:[UIImage imageNamed:@"watch"] forState:UIControlStateNormal];
        
        // Remove local notification
        [self removeLocalNotificationForGame:_game];
        
    } else {
        DDLogVerbose(@"Adding favorite for game with id: %@", _game.objectId);
        
        // Update local coredata store
        _game.isFavorite = @YES;
        [_headerView.watchlistButton setImage:[UIImage imageNamed:@"watched"] forState:UIControlStateNormal];
        
        // Create a local notification
        [self addLocalNotificationForGame:_game];
        
    }
    
    [[SBCoreDataController sharedInstance] saveMasterContext];
    
}


@end
