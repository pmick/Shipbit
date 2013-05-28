//
//  SBGameDetail2ViewController.m
//  Shipbit
//
//  Created by Patrick Mick on 5/19/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBGameDetailViewController.h"
#import "SDSegmentedControl.h"

@interface SBGameDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SDSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end

@implementation SBGameDetailViewController

- (id)init {
    self = [super init];
    if (self) {
        [self setTitle:NSLocalizedString(@"Info", nil)];
        
        _headerView = [[SBGameDetailHeaderView alloc] init];
        [self.view addSubview:_headerView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateFormat:@"MMM dd"];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(196.0f/255.0f)
                                                  green:(190.0f/255.0f)
                                                   blue:(186.0f/255.0f)
                                                  alpha:1]];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,40,45);
    [button setImage:[UIImage imageNamed:@"backButton"]
            forState:UIControlStateNormal];
    
    [button addTarget:self.navigationController
               action:@selector(popViewControllerAnimated:)
     forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
}

- (void)setupSegmentedController {
    _segmentedControl = [[SDSegmentedControl alloc] initWithItems:@[ @"Summary", @"Info", @"Ratings" ]];
    [_segmentedControl setFrame:CGRectMake(0, 200, 320, 44)];
    [_segmentedControl setBackgroundColor:[UIColor colorWithRed:(220.0f/255.0f)
                                                         green:(214.0f/255.0f)
                                                          blue:(210.0f/255.0f)
                                                         alpha:1]];
    _segmentedControl.arrowHeightFactor *= -1.0;
    [_segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
}

- (void)setupScrollView {
    UIColor *sbLightGrayColor = [UIColor colorWithRed:(196.0f/255.0f)
                                                green:(190.0f/255.0f)
                                                 blue:(186.0f/255.0f)
                                                alpha:1];
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
    self.infoView.genreLabel.text = game.genre;
    self.infoView.developerLabel.text = game.developer;
    self.infoView.publisherLabel.text = game.publisher;
    self.infoView.esrbLabel.text = game.esrb;
    self.infoView.platformsLabel.text = game.platformsString;
    
    self.ratingView.metacriticRatingLabel.text = [NSString stringWithFormat:@"%@", game.criticScore];
    self.ratingView.likeLabel.text = [NSString stringWithFormat:@"%@", game.likes];
    
    //    [_gdvc.imageView setImageWithURL:[NSURL URLWithString:game.art]
    //                    placeholderImage:[UIImage imageNamed:nil]];
    //    [_gdvc.tableView reloadData];
    //    [self.navigationController pushViewController:self.gdvc animated:YES];
    
    [self.headerView resizeSubviews];
    [self.summaryView resizeSubviews];
    
    [self.verticalScrollView setContentSize:CGSizeMake(320.0f, self.summaryView.summaryLabel.frame.size.height+30.0f)];
}

@end
