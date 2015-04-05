//
//  FetchedDataSource.m
//  Shipbit
//
//  Created by Patrick Mick on 6/9/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "FetchedDataSource.h"
#import "SBCoreDataController.h"

@interface FetchedDataSource ()

@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@property (nonatomic, copy) NSString *sectionNameKeyPath;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;


@end

@implementation FetchedDataSource

#pragma mark - Lifecycle

- (id)init
{
    return nil;
}

- (id)initWithFetchRequest:(NSFetchRequest *)aFetchRequest
        sectionNameKeyPath:(NSString *)aSectionNameKeyPath
            cellIdentifier:(NSString *)aCellIdentifier
        configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        _fetchRequest = aFetchRequest;
        _sectionNameKeyPath = aSectionNameKeyPath;
        _cellIdentifier = aCellIdentifier;
        _configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_fetchedResultsController objectAtIndexPath:indexPath];
}

- (void)resetFetchedResultsControllerForUpdatedRequest:(NSFetchRequest *)aFetchRequest
{
    _fetchRequest = aFetchRequest;
    self.fetchedResultsController = nil;
}

#pragma mark - Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];

    id item = [_fetchedResultsController objectAtIndexPath:indexPath];
    _configureCellBlock(cell, item);
    return cell;
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // Create and initialize the fetch results controller.
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                             initWithFetchRequest:_fetchRequest
                                                             managedObjectContext:[[SBCoreDataController sharedInstance] masterManagedObjectContext]
                                                             sectionNameKeyPath:_sectionNameKeyPath
                                                             cacheName:nil];
    self.fetchedResultsController = aFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        DDLogError(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - Fetched Results Controller Delegates

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    if (controller == _fetchedResultsController) {
        [((UITableViewController *)_parent).tableView beginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (controller == _fetchedResultsController) {
        UITableView *tableView = ((UITableViewController *)_parent).tableView;
        
        switch(type) {
                
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                _configureCellBlock([tableView cellForRowAtIndexPath:indexPath], [_fetchedResultsController objectAtIndexPath:indexPath]);
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    if (controller == _fetchedResultsController) {
        switch(type) {
                
            case NSFetchedResultsChangeInsert:
                [((UITableViewController *)_parent).tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [((UITableViewController *)_parent).tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            default:
                break;
        }
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    if (controller == _fetchedResultsController) {
        [((UITableViewController *)_parent).tableView endUpdates];
    }
}

@end
