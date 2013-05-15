//
//  SBLeftSideNavViewController.m
//  Shipbit
//
//  Created by Patrick Mick on 4/28/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBLeftSideNavViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface SBLeftSideNavViewController ()

@end

@implementation SBLeftSideNavViewController

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DDLogWarn(@"Did receive memory warning");
}

#pragma mark - View Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _views = [[NSArray alloc] init];
    _views = [NSArray arrayWithObjects:NSLocalizedString(@"Upcoming", nil),
              NSLocalizedString(@"Released", nil), NSLocalizedString(@"Search", nil), NSLocalizedString(@"Watch List", nil), nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_views count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_views objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self.sidePanelController setCenterPanel:_utvc];
            break;
        case 1:
            [self.sidePanelController setCenterPanel:_rtvc];
            break;
        case 2:
            [self.sidePanelController setCenterPanel:_stvc];
            break;
        case 3:
            [self.sidePanelController setCenterPanel:_ftvc];
            break;
        default:
            break;
    }
}

@end
