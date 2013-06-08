//
//  SBReleasedViewController.h
//  Shipbit
//
//  Created by Patrick Mick on 5/5/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SBPlatformsTableViewController.h"

@interface SBReleasedViewController : UITableViewController <NSFetchedResultsControllerDelegate, SDWebImageManagerDelegate>

@property (nonatomic, strong) SBPlatformsTableViewController *ptvc;

@end
