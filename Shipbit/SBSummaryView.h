//
//  SBSummaryView.h
//  Shipbit
//
//  Created by Patrick Mick on 5/22/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBSummaryView : UIView

@property (nonatomic, strong) UILabel *summaryLabel;
@property (nonatomic, strong) UIImageView *noSummaryImage;

- (void)resizeSubviews;

@end
