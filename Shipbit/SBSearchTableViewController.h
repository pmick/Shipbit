//
//  SBSearchTableViewController.h
//  Shipbit
//
//  Created by MattMick on 2/22/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBGameDetailViewController.h"

@interface SBSearchTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) SBGameDetailViewController *gdvc;

@end
