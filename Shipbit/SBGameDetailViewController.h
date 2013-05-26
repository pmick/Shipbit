//
//  SBGameDetail2ViewController.h
//  Shipbit
//
//  Created by Patrick Mick on 5/19/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGameDetailHeaderView.h"
#import "SBSummaryView.h"
#import "SBInfoView.h"
#import "SBRatingView.h"

@interface SBGameDetailViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) SBGameDetailHeaderView *headerView;
@property (nonatomic, strong) SBSummaryView *summaryView;
@property (nonatomic, strong) SBInfoView *infoView;
@property (nonatomic, strong) SBRatingView *ratingView;
@property (nonatomic, strong) UIScrollView *verticalScrollView;
@property (nonatomic, strong) Game *game;

- (void)prepareForReuse;
- (void)populateWithDataFromGame:(Game *)game;

@end
