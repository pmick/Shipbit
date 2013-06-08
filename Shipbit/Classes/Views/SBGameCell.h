//
//  SBGameCell.h
//  Shipbit
//
//  Created by Patrick Mick on 1/20/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBGameCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *releaseDateLabel;
@property (nonatomic, strong) UILabel *urgentLabel;
@property (nonatomic, strong) UILabel *platformsLabel;
@property (nonatomic, strong) UIImageView *releaseDateImage;
@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, strong) UIImageView *borderImageView;

- (void)resizeSubviews;

@end
