//
//  SBRatingView.m
//  Shipbit
//
//  Created by Patrick Mick on 5/22/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBRatingView.h"
#import "UIColor+Extras.h"

@implementation SBRatingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *sbDarkGrayColor = [UIColor colorWithRed:(81.0f/255.0f)
                                                   green:(77.0f/255.0f)
                                                    blue:(74.0f/255.0f)
                                                   alpha:1];
        
        UILabel *likesLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 12.0, 70.0, 16.0)];
        likesLeftLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        likesLeftLabel.textAlignment = NSTextAlignmentRight;
        likesLeftLabel.textColor = sbDarkGrayColor;
        likesLeftLabel.backgroundColor = [UIColor clearColor];
        likesLeftLabel.text = NSLocalizedString(@"Likes", nil);
        [self addSubview:likesLeftLabel];
        
        UILabel *metacriticLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 32.0, 70.0, 16.0)];
        metacriticLeftLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        metacriticLeftLabel.textAlignment = NSTextAlignmentRight;
        metacriticLeftLabel.textColor = sbDarkGrayColor;
        metacriticLeftLabel.backgroundColor = [UIColor clearColor];
        metacriticLeftLabel.text = NSLocalizedString(@"Metacritic", nil);
        [self addSubview:metacriticLeftLabel];
        
        UIImageView *likesImage = [[UIImageView alloc] initWithFrame:CGRectMake(89, 12, 30, 30)];
        [likesImage setImage:[UIImage imageNamed:@"likesImage"]];
        [likesImage sizeToFit];
        [self addSubview:likesImage];
        
        UIImageView *metacriticImage = [[UIImageView alloc] initWithFrame:CGRectMake(89, 32, 30, 30)];
        [metacriticImage setImage:[UIImage imageNamed:@"metacriticImage"]];
        [metacriticImage sizeToFit];
        [self addSubview:metacriticImage];
        
        _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(113.0, 12.0, 230.0, 16.0)];
        _likeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _likeLabel.textAlignment = NSTextAlignmentLeft;
        _likeLabel.textColor = sbDarkGrayColor;
        _likeLabel.backgroundColor = [UIColor clearColor];
        _likeLabel.text = @"text text text";
        [self addSubview:_likeLabel];
        
        _metacriticRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(113.0, 32.0, 230.0, 16.0)];
        _metacriticRatingLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _metacriticRatingLabel.textAlignment = NSTextAlignmentLeft;
        _metacriticRatingLabel.textColor = sbDarkGrayColor;
        _metacriticRatingLabel.text = @"Available when game is released.";
        _metacriticRatingLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_metacriticRatingLabel];
        
        UILabel *sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, 320, 22)];
        [sourceLabel setBackgroundColor:[UIColor clearColor]];
        [sourceLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0]];
        [sourceLabel setTextColor:[UIColor colorWithHexValue:@"514d4a"]];
        [sourceLabel setText:@"Metacritic score from metacritic.com"];
        [sourceLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:sourceLabel];
        
        _ratingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ratingButton setFrame:CGRectMake(59.0, 105.0, 320.0, 44.0)];
        [_ratingButton addTarget:self action:@selector(ratingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_ratingButton setBackgroundColor:[UIColor clearColor]];
        [_ratingButton setImage:[UIImage imageNamed:@"readReviewsButton"] forState:UIControlStateNormal];
        [_ratingButton setImage:[UIImage imageNamed:@"readReviewsButtonPressed"] forState:UIControlStateSelected];
        [_ratingButton setImage:[UIImage imageNamed:@"readReviewsButtonPressed"] forState:UIControlStateHighlighted];
        [_ratingButton sizeToFit];
        //NSLog(@"FRAME:%@" [_ratingButton ])
        [self addSubview:_ratingButton];

    }
    return self;
}

- (void)ratingButtonPressed:(id)sender
{
    // open link
    NSURL *url = [NSURL URLWithString:_metacriticPath];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        DDLogError(@"Failed to open url: %@", [url description]);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
