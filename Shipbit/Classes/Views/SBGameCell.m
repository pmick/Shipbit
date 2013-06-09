//
//  SBGameCell.m
//  Shipbit
//
//  Created by Patrick Mick on 1/20/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBGameCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SBGameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *background = [[UIView alloc] initWithFrame:CGRectZero];
        background.backgroundColor = [UIColor whiteColor];
        self.backgroundView = background;
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.BackgroundColor = [UIColor colorWithHexValue:@"3e434d"];
        self.selectedBackgroundView = bgColorView;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 3.0, 180.0, 40.0)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithHexValue:@"3e434d"];
        _titleLabel.highlightedTextColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:_titleLabel];
        
        _releaseDateImage = [[UIImageView alloc] initWithFrame:CGRectMake(110.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 4, 20, 20)];
        _releaseDateImage.image = [UIImage imageNamed:@"calendarIcon"];
        _releaseDateImage.highlightedImage = [UIImage imageNamed:@"calendarIcon_highlight"];
        _releaseDateImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_releaseDateImage];
        
        _releaseDateLabel = [[UILabel alloc] init];
        _releaseDateLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _releaseDateLabel.textAlignment = NSTextAlignmentLeft;
        _releaseDateLabel.textColor = [UIColor colorWithHexValue:@"8d8885"];
        _releaseDateLabel.highlightedTextColor = [UIColor whiteColor];
        _releaseDateLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_releaseDateLabel];
        
        _urgentLabel = [[UILabel alloc] init];
        _urgentLabel.font = [UIFont systemFontOfSize:13.0];
        _urgentLabel.textAlignment = NSTextAlignmentLeft;
        _urgentLabel.textColor = [UIColor colorWithHexValue:@"8d8885"];
        _urgentLabel.highlightedTextColor = [UIColor whiteColor];
        _urgentLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_urgentLabel];
        
        _platformsLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 88.0, 190.0, 16.0)];
        _platformsLabel.font = [UIFont boldSystemFontOfSize:11.0];
        _platformsLabel.textAlignment = NSTextAlignmentLeft;
        _platformsLabel.textColor = [UIColor colorWithHexValue:@"8d8885"];
        _platformsLabel.highlightedTextColor = [UIColor whiteColor];
        _platformsLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_platformsLabel];

        _thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(11.0, 11.0, 88.0, 88.0)];
        _thumbnailView.backgroundColor = [UIColor darkGrayColor];
        _thumbnailView.layer.cornerRadius = 88/2;
        [self.contentView addSubview:_thumbnailView];
        
        _borderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0, 7.0, 96.0, 96.0)];
        _borderImageView.image = [UIImage imageNamed:@"circle_border_light"];
        _borderImageView.highlightedImage = [UIImage imageNamed:@"highlight_circle"];
        [self.contentView addSubview:_borderImageView];
        
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disclosureArrow"]
                                               highlightedImage:[UIImage imageNamed:@"disclosureArrow_highlight"]];
    }
    return self;
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
    [_releaseDateImage setFrame:CGRectMake(111.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 4, 12, 14)];
    [_releaseDateLabel setFrame:CGRectMake(127.0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 1, 100.0, 20.0)];
    [_urgentLabel setFrame:CGRectMake(_releaseDateLabel.frame.origin.x + 52, _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 1, 100.0, 20.0)];
}

@end
