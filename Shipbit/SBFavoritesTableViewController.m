//
//  SBFavoritesTableViewController.m
//  Shipbit
//
//  Created by Patrick Mick on 1/26/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

#import "SBFavoritesTableViewController.h"
#import "SBGameDetailViewController.h"
#import "SBGameCell.h"
#import "Game.h"

#define CELL_HEIGHT 100

@interface SBFavoritesTableViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) SBGameDetailViewController *gdvc;

@end

@implementation SBFavoritesTableViewController

@synthesize dateFormatter = _dateFormatter;
@synthesize gdvc = _gdvc;

@synthesize favorites = _favorites;

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    // TODO implement shared logger to log memory warnings and deallocs
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark View Lifecycle

- (id)init {
    self = [super init];
    if(self) {
        self.title = NSLocalizedString(@"Favorites", @"");
        self.tableView.rowHeight = CELL_HEIGHT;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favoriteAdded:) name:@"FavoritesUpdated" object:nil];
    _favorites = [[NSMutableArray alloc] init];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_favorites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FavoriteCell";
    SBGameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SBGameCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Game *game = [_favorites objectAtIndex:indexPath.row];
    cell.titleLabel.text = game.title;
    cell.releaseDateLabel.text = [self.dateFormatter stringFromDate:game.releaseDate];
    cell.platformsLabel.text = [[NSKeyedUnarchiver unarchiveObjectWithData:game.platforms] componentsJoinedByString:@", "];
    [cell.thumbnailView setImageWithURL:[NSURL URLWithString:game.art]
                       placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

#pragma mark -
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!_gdvc)
    {
        _gdvc = [[SBGameDetailViewController alloc] init];
    }
    Game *game = [_favorites objectAtIndex:indexPath.row];

    [_gdvc setGame:game];
    _gdvc.titleLabel.text = game.title;
    _gdvc.releaseDateLabel.text = [_dateFormatter stringFromDate:game.releaseDate];
    [_gdvc.imageView setImageWithURL:[NSURL URLWithString:game.art]
                    placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    [_gdvc.tableView reloadData];
    [self.navigationController pushViewController:self.gdvc animated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_favorites removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

#pragma mark -
#pragma mark Action Methods

- (void)favoriteAdded:(NSNotification *)note {
    BOOL exists = NO;
    for (Game *game in _favorites) {
        if (game.objectId == [[note object] objectId]) {
            exists = YES;
        }
    }
    if (!exists) {
        [_favorites addObject:[note object]];
    }
    [self.tableView reloadData];
}

@end
