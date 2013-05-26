//
//  SBRatingView.m
//  Shipbit
//
//  Created by Patrick Mick on 5/22/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBRatingView.h"

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
        
        _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 12.0, 230.0, 16.0)];
        _likeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _likeLabel.textAlignment = NSTextAlignmentLeft;
        _likeLabel.textColor = sbDarkGrayColor;
        _likeLabel.backgroundColor = [UIColor clearColor];
        _likeLabel.text = @"text text text";
        [self addSubview:_likeLabel];
        
        _metacriticRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 32.0, 230.0, 16.0)];
        _metacriticRatingLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _metacriticRatingLabel.textAlignment = NSTextAlignmentLeft;
        _metacriticRatingLabel.textColor = sbDarkGrayColor;
        _metacriticRatingLabel.text = @"text text text";
        _metacriticRatingLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_metacriticRatingLabel];
    }
    return self;
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
