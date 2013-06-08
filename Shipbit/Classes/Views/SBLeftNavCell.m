//
//  SBLeftNavCell.m
//  Shipbit
//
//  Created by Patrick Mick on 5/25/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBLeftNavCell.h"
#import "UIColor+Extras.h"

@implementation SBLeftNavCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 11, 200, 20)];
        [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor colorWithHexValue:@"3e434d"]];
        [self addSubview:_titleLabel];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 30, 30)];
        [_iconImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_iconImageView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
