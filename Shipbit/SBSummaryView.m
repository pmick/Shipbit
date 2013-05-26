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
        _summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 12, 274, 249)];
        [_summaryLabel setBackgroundColor:[UIColor clearColor]];
        [_summaryLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [_summaryLabel setTextColor:[UIColor colorWithRed:(81.0f/255.0f) green:(77.0f/255.0f) blue:(74.0f/255.0f) alpha:1]];
        [_summaryLabel setNumberOfLines:0];
        [_summaryLabel setText:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis vehicula, ipsum tincidunt lobortis malesuada, augue nisl aliquet urna, vel tempus diam purus non enim. Quisque in dictum orci. Fusce ac feugiat libero. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque laoreet mattis quam sed faucibus. "];
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
