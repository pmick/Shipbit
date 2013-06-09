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
        UILabel* label = [[UILabel alloc] init] ;
        label.text = NSLocalizedString(@"Platforms", @"");
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        label.shadowColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.layer.shadowColor = [UIColor blackColor].CGColor;
        label.layer.shadowOpacity = .5;
        label.layer.shadowOffset = CGSizeMake(0, 1);
        label.layer.shadowRadius = .8;
        
        [label sizeToFit];
        self.navigationItem.titleView = label;
        
        self.title = NSLocalizedString(@"Platforms", @"");
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
        // Prevent less than 1 selection
        if (numberOfSelectedPlatforms > 1) {
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
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        UIImageView *accessoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark"]];
        [accessoryImage sizeToFit];
        [cell setAccessoryView:accessoryImage];
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
