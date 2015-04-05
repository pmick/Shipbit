//
//  SBPlatformsTableViewController.m
//  Shipbit
//
//  Created by MattMick on 2/22/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBPlatformsTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SBPlatformsTableViewController ()

@property UIBarButtonItem *leftButton;

@end

@implementation SBPlatformsTableViewController

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    // TODO implement shared logger to log memory warnings and deallocs
    [super didReceiveMemoryWarning];
}

#pragma mark - View Lifecycle

- (id)init {
    self = [super init];
    if(self) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView setSeparatorColor:[UIColor colorWithHexValue:@"e5e0dd"]];
    
    _platforms = [[NSArray alloc] initWithObjects: NSLocalizedString(@"PC", nil),
                  NSLocalizedString(@"Xbox 360", nil), NSLocalizedString(@"PlayStation 3", nil),
                  NSLocalizedString(@"Xbox One", nil), NSLocalizedString(@"PlayStation 4", nil),
                  NSLocalizedString(@"PSP", nil), NSLocalizedString(@"PlayStation Vita", nil),
                  NSLocalizedString(@"Wii", nil), NSLocalizedString(@"Wii U", nil),
                  NSLocalizedString(@"DS", nil), NSLocalizedString(@"3DS", nil), nil];

    // Selections are based off of userdefaults if they exist
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selected"]) {
        _selected = [[NSUserDefaults standardUserDefaults] objectForKey:@"selected"];
    } else {
        _selected = [[NSMutableArray alloc] initWithArray:_platforms];
    }
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(donePressed)];
    
    [self.navigationItem setRightBarButtonItem:doneButton];

    _leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Uncheck All"
                                                   style:UIBarButtonItemStyleBordered
                                                  target:self
                                                  action:@selector(selectAllPressed:)];
    [self.navigationItem setLeftBarButtonItem:_leftButton];
    [self updateButtonText];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_platforms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if ([_selected containsObject:[_platforms objectAtIndex:indexPath.row]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            UIImageView *accessoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
            [accessoryImage sizeToFit];
            [cell setAccessoryView:accessoryImage];
        }
        
        UIView *background = [[UIView alloc] initWithFrame:CGRectZero];
        background.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = background;
        
        UIView *bgColorView = [[UIView alloc] initWithFrame:CGRectZero];
        [bgColorView setBackgroundColor:[UIColor colorWithHexValue:@"e5e0dd"]];
        [cell setSelectedBackgroundView:bgColorView];
    }
    cell.textLabel.textColor = [UIColor colorWithHexValue:@"3e434d"];
    cell.textLabel.highlightedTextColor = [UIColor colorWithHexValue:@"3e434d"];
    cell.textLabel.text = [_platforms objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType) {
        int numberOfSelectedPlatforms = [_selected count];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
        int objectToRemove = 0;
        for (int i = 0; i < numberOfSelectedPlatforms; i++) {
            if ([cell.textLabel.text isEqualToString:[_selected objectAtIndex:i]]) {
                objectToRemove = i;
                break;
            }
        }
        [_selected removeObjectAtIndex:objectToRemove];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        UIImageView *accessoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
        [accessoryImage sizeToFit];
        [cell setAccessoryView:accessoryImage];
        [_selected addObject:cell.textLabel.text];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self updateButtonText];
}

#pragma mark - Custom Methods

- (void)updateButtonText
{
    if ([_selected count] < [_platforms count]) {
        _leftButton.title = @"Check All";
    } else {
        _leftButton.title = @"Uncheck All";
    }
}

#pragma mark - Action Methods

- (void)donePressed {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:_selected forKey:@"selected"];
    
    NSNotification *note = [NSNotification notificationWithName:@"PlatformsUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    
    DDLogInfo(@"Selected %@", _selected);
    
    // Dismiss platforms view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectAllPressed:(id)sender
{
    DDLogInfo(@"Select all pressed");
    if ([_selected count] < [_platforms count]) {
        DDLogInfo(@"selected is less than platforms");
        // check all
        for (int i = 0; i < (int)[_platforms count]; i++) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            UIImageView *accessoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
            [accessoryImage sizeToFit];
            [cell setAccessoryView:accessoryImage];
        }
        [_selected removeAllObjects];
        [_selected addObjectsFromArray:_platforms];
    } else {
        DDLogInfo(@"selected is not less than platforms");
        // uncheck all
        for (int i = 0; i < (int)[_platforms count]; i++) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = nil;
        }
        [_selected removeAllObjects];
    }
    [self updateButtonText];
}

@end
