//
//  SBSummaryView.m
//  Shipbit
//
//  Created by Patrick Mick on 5/22/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBSummaryView.h"

@implementation SBSummaryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _noSummaryImage = [[UIImageView alloc] initWithFrame:CGRectMake(23, 12, 100, 100)];
        [_noSummaryImage setImage:[UIImage imageNamed:@"no_summary"]];
        [_noSummaryImage sizeToFit];
        [_noSummaryImage setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_noSummaryImage];
        
        _summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 12, 274, 249)];
        [_summaryLabel setBackgroundColor:[UIColor clearColor]];
        [_summaryLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [_summaryLabel setTextColor:[UIColor colorWithHexValue:@"514D4A"]];
        [_summaryLabel setNumberOfLines:0];
        [_summaryLabel sizeToFit];
        [self addSubview:_summaryLabel];
    }
    return self;
}

- (void)resizeSubviews {
    [_summaryLabel setFrame:CGRectMake(23, 12, 274, 249)];
    [_summaryLabel sizeToFit];
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
