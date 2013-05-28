//
//  UIImage+Extras.h
//  Shipbit
//
//  Created by Patrick Mick on 5/13/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extras)

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)circleImage;

@end
