//
//  SBPlatformsTableViewController.m
//  Shipbit
//
//  Created by MattMick on 2/22/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBPlatformsTableViewController.h"

@interface SBPlatformsTableViewController ()

@end

@implementation SBPlatformsTableViewController

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    // TODO implement shared logger to log memory warnings and deallocs
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark View Lifecycle

- (id)init {
    self = [super init];
    if(self) {
        self.title = NSLocalizedString(@"Platforms", @"");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    _platforms = [[NSArray alloc] initWithObjects: @"PC", @"Xbox 360", @"PlayStation 3", @"PSP", @"PS Vita", @"Wii", @"Wii U", @"DS", @"3DS", nil];

    // Selections are based off of userdefaults if they exist
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selected"]) {
        _selected = [[NSUserDefaults standardUserDefaults] objectForKey:@"selected"];
    } else {
        _selected = [[NSMutableArray alloc] initWithArray:_platforms];
    }
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(donePressed)];
    self.navigationItem.rightBarButtonItem = doneButton;
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

        }
    }
    
    cell.textLabel.text = [_platforms objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType) {
        int numberOfSelectedPlatforms = [_selected count];
        // Prevent less than 1 selection
        if (numberOfSelectedPlatforms > 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            int objectToRemove = 0;
            for (int i = 0; i < numberOfSelectedPlatforms; i++) {
                if ([cell.textLabel.text isEqualToString:[_selected objectAtIndex:i]]) {
                    objectToRemove = i;
                    break;
                }
            }
            [_selected removeObjectAtIndex:objectToRemove];
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_selected addObject:cell.textLabel.text];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Action Methods

- (void)donePressed {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:_selected forKey:@"selected"];
    
    NSNotification *note = [NSNotification notificationWithName:@"PlatformsUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    
    // Dismiss platforms view
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
