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

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 280.0f
#define CELL_CONTENT_MARGIN 24.0f
#define CELL_CONTENT_HEIGHT_MAXIMUM 20000.0f

@interface SBGameDetailViewController ()

@property (nonatomic, strong) SBRatingCell *ratingCell;
@property (nonatomic, strong) SBSummaryCell *summaryCell;
@property (nonatomic, strong) SBInfoCell *infoCell;

@end

@implementation SBGameDetailViewController

@synthesize ratingCell = _ratingCell;
@synthesize summaryCell = _summaryCell;
@synthesize infoCell = _infoCell;

@synthesize game = _game;
@synthesize imageView = _imageView;
@synthesize titleLabel = _titleLabel;
@synthesize releaseDateLabel = _releaseDateLabel;

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark View Lifecycle

- (id)init {
    self = [super init];
    if (self) {
        self.title = @"Info";
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 215.0)];
        [headerView setBackgroundColor:[UIColor lightGrayColor]];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 98.0, 136.0)];
        [_imageView setContentMode:UIViewContentModeCenter];
        [_imageView setBackgroundColor:[UIColor darkGrayColor]];
        [headerView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 10.0, 200.0, 46.0)];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
        [_titleLabel setNumberOfLines:2];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:_titleLabel];
        
        _releaseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 60.0, 200.0, 16.0)];
        [_releaseDateLabel setFont:[UIFont systemFontOfSize:14]];
        [_releaseDateLabel setTextAlignment:NSTextAlignmentLeft];
        [_releaseDateLabel setBackgroundColor:[UIColor clearColor]];
        [headerView addSubview:_releaseDateLabel];
        
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [likeButton setFrame:CGRectMake(10.0, 160.0, 145.0, 45.0)];
        [likeButton setTitle:@"Like" forState:UIControlStateNormal];
        [likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:likeButton];
        
        UIButton *favoriteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [favoriteButton setFrame:CGRectMake(165.0, 160.0, 145.0, 45.0)];
        [favoriteButton setTitle:@"Add to Favorites" forState:UIControlStateNormal];
        [favoriteButton addTarget:self action:@selector(favoriteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:favoriteButton];
        
        [self.tableView setTableHeaderView:headerView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
    // scrollRectToVisible necessary for changing games. Previously if you scrolled to the bottom of the table for 1 game, and then looked at another game, the view was reused, and the tableview would be scrolled down.
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark -
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
            
            if (_game.criticScore > 0) {
                _ratingCell.metacriticRatingLabel.text = [NSString stringWithFormat:@"%@", _game.criticScore];
            } else {
                _ratingCell.metacriticRatingLabel.text = @"Not yet rated.";
            }
            
            cell = _ratingCell;
            break;
        case 1:
            if (_summaryCell == nil) {
                _summaryCell = [[SBSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SummaryCell"];
            }
            _summaryCell.summaryLabel.text = _game.summary;
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH, 20000.0f);
            CGSize size = [_game.summary sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
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
            _infoCell.esrbLabel.text = _game.esrb;
            //_infoCell.platformsLabel.text = _game.platforms;
            cell = _infoCell;
            break;
        default:
            break;
    }
        
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

#pragma mark -
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO implement selection functionality for metacritic links and other web links
}

#pragma mark -
#pragma mark Action Methods

- (IBAction)likeButtonPressed:(id)sender {
    NSLog(@"Like Button Pressed!");
}

- (IBAction)favoriteButtonPressed:(id)sender {
    NSLog(@"Favorite Button Pressed!");
    NSNotification *note = [NSNotification notificationWithName:@"FavoritesUpdated" object:self.game];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    
}

@end
