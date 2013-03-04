//
//  SBInfoCell.m
//  Shipbit
//
//  Created by Patrick Mick on 1/21/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBInfoCell.h"

@implementation SBInfoCell

@synthesize genreLabel = _genreLabel;
@synthesize developerLabel = _developerLabel;
@synthesize publisherLabel = _publisherLabel;
@synthesize esrbLabel = _esrbLabel;
@synthesize platformsLabel = _platformsLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    // Mimicking appstore app detail view
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 10.0, 210.0, 16.0)];
        cellTitleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cellTitleLabel.textAlignment = NSTextAlignmentLeft;
        cellTitleLabel.textColor = [UIColor blackColor];
        cellTitleLabel.text = @"Information";
        [self.contentView addSubview:cellTitleLabel];
        
        UILabel *genreLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 30.0, 70.0, 16.0)];
        genreLeftLabel.font = [UIFont systemFontOfSize:14.0];
        genreLeftLabel.textAlignment = NSTextAlignmentRight;
        genreLeftLabel.textColor = [UIColor darkGrayColor];
        genreLeftLabel.text = @"Genre";
        [self.contentView addSubview:genreLeftLabel];
        
        UILabel *developerLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 50.0, 70.0, 16.0)];
        developerLeftLabel.font = [UIFont systemFontOfSize:14.0];
        developerLeftLabel.textAlignment = NSTextAlignmentRight;
        developerLeftLabel.textColor = [UIColor darkGrayColor];
        developerLeftLabel.text = @"Developer";
        [self.contentView addSubview:developerLeftLabel];
        
        UILabel *publisherLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 70.0, 70.0, 16.0)];
        publisherLeftLabel.font = [UIFont systemFontOfSize:14.0];
        publisherLeftLabel.textAlignment = NSTextAlignmentRight;
        publisherLeftLabel.textColor = [UIColor darkGrayColor];
        publisherLeftLabel.text = @"Publisher";
        [self.contentView addSubview:publisherLeftLabel];
        
        UILabel *esrbLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 90.0, 70.0, 16.0)];
        esrbLeftLabel.font = [UIFont systemFontOfSize:14.0];
        esrbLeftLabel.textAlignment = NSTextAlignmentRight;
        esrbLeftLabel.textColor = [UIColor darkGrayColor];
        esrbLeftLabel.text = @"ESRB";
        [self.contentView addSubview:esrbLeftLabel];
        
        UILabel *platformsLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 110.0, 70.0, 16.0)];
        platformsLeftLabel.font = [UIFont systemFontOfSize:14.0];
        platformsLeftLabel.textAlignment = NSTextAlignmentRight;
        platformsLeftLabel.textColor = [UIColor darkGrayColor];
        platformsLeftLabel.text = @"Platforms";
        [self.contentView addSubview:platformsLeftLabel];
        
        _genreLabel = [[UILabel alloc] initWithFrame:CGRectMake(95.0, 30.0, 230.0, 16.0)];
        _genreLabel.font = [UIFont systemFontOfSize:14.0];
        _genreLabel.textAlignment = NSTextAlignmentLeft;
        _genreLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_genreLabel];
        
        _developerLabel = [[UILabel alloc] initWithFrame:CGRectMake(95.0, 50.0, 230.0, 16.0)];
        _developerLabel.font = [UIFont systemFontOfSize:14.0];
        _developerLabel.textAlignment = NSTextAlignmentLeft;
        _developerLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_developerLabel];
        
        _publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(95.0, 70.0, 230.0, 16.0)];
        _publisherLabel.font = [UIFont systemFontOfSize:14.0];
        _publisherLabel.textAlignment = NSTextAlignmentLeft;
        _publisherLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_publisherLabel];
        
        _esrbLabel = [[UILabel alloc] initWithFrame:CGRectMake(95.0, 90.0, 230.0, 16.0)];
        _esrbLabel.font = [UIFont systemFontOfSize:14.0];
        _esrbLabel.textAlignment = NSTextAlignmentLeft;
        _esrbLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_esrbLabel];
        
        _platformsLabel = [[UILabel alloc] initWithFrame:CGRectMake(95.0, 110.0, 230.0, 16.0)];
        _platformsLabel.font = [UIFont systemFontOfSize:14.0];
        _platformsLabel.textAlignment = NSTextAlignmentLeft;
        _platformsLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_platformsLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
