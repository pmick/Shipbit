//
//  SBRatingView.h
//  Shipbit
//
//  Created by Patrick Mick on 5/22/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBRatingView : UIView

@property (nonatomic, strong) UILabel *metacriticRatingLabel;
@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UIButton *ratingButton;
@property (nonatomic, strong) NSString *metacriticPath;

@end
