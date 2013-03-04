//
//  SBInfoCell.h
//  Shipbit
//
//  Created by Patrick Mick on 1/21/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *genreLabel;
@property (nonatomic, strong) UILabel *developerLabel;
@property (nonatomic, strong) UILabel *publisherLabel;
@property (nonatomic, strong) UILabel *esrbLabel;
@property (nonatomic, strong) UILabel *platformsLabel;

@end
