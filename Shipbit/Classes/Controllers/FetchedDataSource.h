//
//  FetchedDataSource.h
//  Shipbit
//
//  Created by Patrick Mick on 6/9/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface FetchedDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) id parent;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (id)init;
- (id)initWithFetchRequest:(NSFetchRequest *)aFetchRequest
        sectionNameKeyPath:(NSString *)aSectionNameKeyPath
            cellIdentifier:(NSString *)aCellIdentifier
        configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (void)resetFetchedResultsControllerForUpdatedRequest:(NSFetchRequest *)aFetchRequest;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
