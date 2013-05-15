//
//  SBSearchTableViewController.h
//  Shipbit
//
//  Created by MattMick on 2/22/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SBGameDetailViewController.h"

@interface SBSearchTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, SDWebImageManagerDelegate>

@property (nonatomic, strong) SBGameDetailViewController *gdvc;

@end
