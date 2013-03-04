//
//  SBGameTableViewController.h
//  Shipbit
//
//  Created by Patrick Mick on 1/20/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBGameTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSArray *games;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *upcomingFetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *releasedFetchedResultsController;

@end
