//
//  UIImage+Extras.m
//  Shipbit
//
//  Created by Patrick Mick on 5/13/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "UIImage+Extras.h"

@implementation UIImage (Extras)

#pragma mark - Scale and crop image

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        //scaleFactor = widthFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5f;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5f;
            }
        }
        //thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
    }
    
    
    UIGraphicsBeginImageContextWithOptions(targetSize, YES, 0.0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        DDLogError(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)circleImage {
    // start with an image
    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    // set the implicit graphics context ("canvas") to a bitmap context for images
    UIGraphicsBeginImageContextWithOptions(imageRect.size,NO,0.0);
    // create a bezier path defining rounded corners
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:self.size.height/2];
    // use this path for clipping in the implicit context
    [path addClip];
    // draw the image into the implicit context
    [self drawInRect:imageRect];
    // save the clipped image from the implicit context into an image
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    // cleanup
    UIGraphicsEndImageContext();
    
    return maskedImage;
}

@end
