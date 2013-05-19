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
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 3.0, 180.0, 40.0)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithRed:(81.0/255.0) green:(77.0/255.0) blue:(74.0/255.0) alpha:1];
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];

        
        _releaseDateImage = [[UIImageView alloc] initWithFrame:CGRectMake(108.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 3, 20, 20)];
        _releaseDateImage.image = [UIImage imageNamed:@"calenderIcon"];
        [self.contentView addSubview:_releaseDateImage];
        
        _releaseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(131.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 3, 220.0, 20.0)];
        _releaseDateLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _releaseDateLabel.textAlignment = NSTextAlignmentLeft;
        _releaseDateLabel.textColor = [UIColor colorWithRed:(141.0/255.0) green:(136.0/255.0) blue:(133.0/255.0) alpha:1];
        [self.contentView addSubview:_releaseDateLabel];
        
        _platformsLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 88.0, 190.0, 16.0)];
        _platformsLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _platformsLabel.textAlignment = NSTextAlignmentLeft;
        _platformsLabel.textColor = [UIColor colorWithRed:(141.0/255.0) green:(136.0/255.0) blue:(133.0/255.0) alpha:1];
        [self.contentView addSubview:_platformsLabel];
        
        _thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0, 7.0, 96.0, 96.0)];
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

#pragma mark - Custom Methods

- (void)resizeSubviews {
    [_titleLabel setFrame:CGRectMake(110.0, 3.0, 180.0, 40.0)];
    [_titleLabel sizeToFit];
    [_releaseDateImage setFrame:CGRectMake(109.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 3, 20, 20)];
    [_releaseDateLabel setFrame:CGRectMake(131.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 3, 100.0, 20.0)];
}

@end
