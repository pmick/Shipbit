//
//  SBLeftSideNavViewController.m
//  Shipbit
//
//  Created by Patrick Mick on 4/28/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBLeftSideNavViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "UIColor+Extras.h"
#import "SBLeftNavCell.h"

@interface SBLeftSideNavViewController ()

@end

@implementation SBLeftSideNavViewController

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DDLogWarn(@"Did receive memory warning");
}

#pragma mark - View Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _views = @[ NSLocalizedString(@"Upcoming", nil),
                NSLocalizedString(@"Shipped", nil),
                NSLocalizedString(@"Browse", nil),
                NSLocalizedString(@"Watchlist", nil) ];
    
    self.tableView.scrollEnabled = NO;
    
    [self.tableView setSeparatorColor:[UIColor colorWithHexValue:@"cdc9c7"]];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setFrame:CGRectMake(25.0, 20.0, 220.0, 44.0)];
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setBackgroundColor:[UIColor clearColor]];
    [shareButton setImage:[UIImage imageNamed:@"tellFriends"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"tellFriendsPressed"] forState:UIControlStateSelected];
    [shareButton setImage:[UIImage imageNamed:@"tellFriendsPressed"] forState:UIControlStateHighlighted];
    [shareButton sizeToFit];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 331, 114, 20)];
    [versionLabel setTextAlignment:NSTextAlignmentRight];
    [versionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11]];
    [versionLabel setTextColor:[UIColor colorWithHexValue:@"cdc9c7"]];
    [versionLabel setText:@"Version 1.00"];
    [versionLabel setBackgroundColor:[UIColor clearColor]];
    
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(137, 331, 114, 20)];
    [authorLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [authorLabel setTextColor:[UIColor colorWithHexValue:@"cdc9c7"]];
    [authorLabel setText:@"by Mick Dev"];
    [authorLabel setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *footerImage = [[UIImageView alloc] initWithFrame:CGRectMake(94, 284, 133, 62)];
    [footerImage setImage:[UIImage imageNamed:@"leftNavLogoImage"]];
    [footerImage sizeToFit];
    
    
    float screenHeight = [[UIScreen mainScreen] applicationFrame].size.height;
    if (screenHeight < 548.0f) {
        DDLogInfo(@"DO SPECIAL STUFF");
        [footerImage setFrame:CGRectMake(94, 194, 133, 62)];
        [footerImage sizeToFit];
        [versionLabel setFrame:CGRectMake(20, 241, 114, 20)];
        [authorLabel setFrame:CGRectMake(137, 241, 114, 20)];

    }
    
    _footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 372)];
    _footer.backgroundColor = [UIColor colorWithHexValue:@"e5e0dd"];
    [_footer addSubview:footerImage];
    [_footer addSubview:versionLabel];
    [_footer addSubview:authorLabel];
    [_footer addSubview:shareButton];

    self.tableView.tableFooterView = _footer;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_views count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SBLeftNavCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SBLeftNavCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UIView *background = [[UIView alloc] initWithFrame:CGRectZero];
        background.backgroundColor = [UIColor colorWithHexValue:@"e5e0dd"];
        cell.backgroundView = background;
        
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[UIColor colorWithHexValue:@"cdc9c7"]];
        [cell setSelectedBackgroundView:bgColorView];
    }
    
    cell.textLabel.textColor = [UIColor colorWithHexValue:@"3e434d"];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.titleLabel.text = [_views objectAtIndex:indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            cell.iconImageView.image = [UIImage imageNamed:@"leftNavUpcomingImage"];
            [cell.iconImageView sizeToFit];
            [cell.iconImageView setFrame:CGRectMake(26 - (cell.iconImageView.frame.size.width)/2,
                                                    20 - (cell.iconImageView.frame.size.height/2),
                                                    cell.iconImageView.frame.size.width,
                                                    cell.iconImageView.frame.size.height)];
            break;
        case 1:
            cell.iconImageView.image = [UIImage imageNamed:@"leftNavShippedImage"];
            [cell.iconImageView sizeToFit];
            [cell.iconImageView setFrame:CGRectMake(26 - (cell.iconImageView.frame.size.width/2),
                                                    21 - (cell.iconImageView.frame.size.height/2),
                                                    cell.iconImageView.frame.size.width,
                                                    cell.iconImageView.frame.size.height)];
            break;
        case 2:
            cell.iconImageView.image = [UIImage imageNamed:@"leftNavSearchImage"];
            [cell.iconImageView sizeToFit];
            [cell.iconImageView setFrame:CGRectMake(26 - (cell.iconImageView.frame.size.width/2),
                                                    21 - (cell.iconImageView.frame.size.height/2),
                                                    cell.iconImageView.frame.size.width,
                                                    cell.iconImageView.frame.size.height)];
            break;
        case 3:
            cell.iconImageView.image = [UIImage imageNamed:@"leftNavWatchlistImage"];
            [cell.iconImageView sizeToFit];
            [cell.iconImageView setFrame:CGRectMake(26 - (cell.iconImageView.frame.size.width/2),
                                                    21 - (cell.iconImageView.frame.size.height/2),
                                                    cell.iconImageView.frame.size.width,
                                                    cell.iconImageView.frame.size.height)];
            break;
        default:
            break;
    }
    
    [cell.imageView sizeToFit];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Resolves arc warning regarding controller being unpredictably null 
    JASidePanelController *sidePanel = self.sidePanelController;
    switch (indexPath.row) {
        case 0:
            [sidePanel setCenterPanel:_utvc];
            break;
        case 1:
            [sidePanel setCenterPanel:_rtvc];
            break;
        case 2:
            [sidePanel setCenterPanel:_stvc];
            break;
        case 3:
            [sidePanel setCenterPanel:_ftvc];
            break;
        default:
            break;
    }
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                  animated:YES];
}

#pragma mark - Custom Methods

- (void)shareButtonPressed:(id)sender {
    DDLogVerbose(@"Share Button Pressed");
    
    NSString *message = @"Check out Shipbit! It's an app that shows you upcoming game releases.";
    NSString *path = @"https://itunes.apple.com/us/app/shipbit/id658728056?ls=1&mt=8";
    NSArray *items = @[ message, path ];
    
    // Display the view controller
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:items
                                            applicationActivities:nil];
    [self presentViewController:activityVC
                       animated:YES
                     completion:nil];

}

@end
