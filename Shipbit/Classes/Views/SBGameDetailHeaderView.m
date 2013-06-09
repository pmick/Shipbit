//
//  SBGameDetailHeaderView.m
//  Shipbit
//
//  Created by Patrick Mick on 5/19/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBGameDetailHeaderView.h"

@implementation SBGameDetailHeaderView {
    BOOL _pressed;
}

#pragma mark - View Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 320, 200)];
        [self setupSubviews];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)setupSubviews {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 88, 88)]; // 131, 175
    [_imageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 10, 230, 60)];
    //[_titleLabel setBackgroundColor:[UIColor greenColor]];
    [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]];
    [_titleLabel setTextColor:[UIColor colorWithHexValue:@"3e434d"]];
    [_titleLabel setNumberOfLines:3];
    [self addSubview:_titleLabel];
    
    _releaseDateImageView = [[UIImageView alloc] init];
    [_releaseDateImageView setImage:[UIImage imageNamed:@"calendarIcon"]];
    [_releaseDateImageView sizeToFit];
    [self addSubview:_releaseDateImageView];
    
    _releaseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(172.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 3, 139.0, 20.0)];
    //[_releaseDateLabel setBackgroundColor:[UIColor greenColor]];
    [_releaseDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [_releaseDateLabel setTextColor:[UIColor colorWithHexValue:@"8D8885"]];
    [self addSubview:_releaseDateLabel];
    
    _platformsLabel = [[UILabel alloc] initWithFrame:CGRectMake(112, 116, 160, 40)];
    //[_platformsLabel setBackgroundColor:[UIColor greenColor]];
    [_platformsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11]];
    [_platformsLabel setTextColor:[UIColor colorWithHexValue:@"8D8885"]];
    [_platformsLabel setNumberOfLines:2];
    [self addSubview:_platformsLabel];
    
    _likeButton = [[UIButton alloc] initWithFrame:CGRectMake(112, 158, 58, 29)];
    [_likeButton setShowsTouchWhenHighlighted:YES];
    [_likeButton setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [_likeButton sizeToFit];
    [self addSubview:_likeButton];
    
    _watchlistButton = [[UIButton alloc] initWithFrame:CGRectMake(214, 158, 89, 29)];
    [_watchlistButton setShowsTouchWhenHighlighted:YES];
    [_watchlistButton setBackgroundImage:[UIImage imageNamed:@"watch"] forState:UIControlStateNormal];
    [_watchlistButton sizeToFit];
    [self addSubview:_watchlistButton];
    
    UIImageView *borderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0, 7.0, 96.0, 96.0)];
    borderImageView.image = [UIImage imageNamed:@"circle_border_light"];
    borderImageView.highlightedImage = [UIImage imageNamed:@"highlight_circle"];
    [self addSubview:borderImageView];
}

- (void)resizeSubviews {
    [_titleLabel setFrame:CGRectMake(112, 10, 200, 60)];
    [_titleLabel sizeToFit];
    
    [_releaseDateImageView setFrame:CGRectMake(112.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 4, 20, 20)];
    [_releaseDateImageView sizeToFit];
    [_releaseDateLabel setFrame:CGRectMake(129.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 1, 139.0, 20.0)];
}

@end
