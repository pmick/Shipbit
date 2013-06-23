//
//  UILabel+TitleView.m
//  Shipbit
//
//  Created by Patrick Mick on 6/21/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "UILabel+TitleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UILabel (TitleView)

+ (UILabel *)setStyledTitleWithString:(NSString *)title
{
    UILabel* label = [[UILabel alloc] init] ;
    label.text = title;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    label.shadowColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.layer.shadowColor = [UIColor blackColor].CGColor;
    label.layer.shadowOpacity = .5;
    label.layer.shadowOffset = CGSizeMake(0, 1);
    label.layer.shadowRadius = .8;
    [label sizeToFit];
    
    return label;
}

@end
