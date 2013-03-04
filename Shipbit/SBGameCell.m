//
//  SBGameCell.m
//  Shipbit
//
//  Created by Patrick Mick on 1/20/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBGameCell.h"

@implementation SBGameCell

@synthesize titleLabel = _titleLabel;
@synthesize releaseDateLabel = _releaseDateLabel;
@synthesize platformsLabel = _platformsLabel;
@synthesize thumbnailView = _thumbnailView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 5.0, 220.0, 25.0)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];
        
        _releaseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 30.0, 220.0, 18.0)];
        _releaseDateLabel.font = [UIFont systemFontOfSize:12.0];
        _releaseDateLabel.textAlignment = NSTextAlignmentLeft;
        _releaseDateLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_releaseDateLabel];
        
        _platformsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 70.0, 220.0, 25.0)];
        _platformsLabel.font = [UIFont systemFontOfSize:12.0];
        _platformsLabel.textAlignment = NSTextAlignmentLeft;
        _platformsLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_platformsLabel];
        
        _thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 80.0, 100.0)];
        _thumbnailView.backgroundColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_thumbnailView];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse {
    // Cells are being reused for efficiency, clear all current data
    // in case of new game missing data.
    _thumbnailView.image = nil;
    _titleLabel.text = @"";
    _releaseDateLabel.text = @"";
    _platformsLabel.text = @"";
    
}

@end
