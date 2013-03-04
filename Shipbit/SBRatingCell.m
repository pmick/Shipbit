//
//  SBRatingCell.m
//  Shipbit
//
//  Created by Patrick Mick on 1/21/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBRatingCell.h"

@implementation SBRatingCell

@synthesize metacriticRatingLabel = _metacriticRatingLabel;
@synthesize likeLabel = _likeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 10.0, 210.0, 16.0)];
        cellTitleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cellTitleLabel.textAlignment = NSTextAlignmentLeft;
        cellTitleLabel.textColor = [UIColor blackColor];
        cellTitleLabel.text = @"Ratings";
        [self.contentView addSubview:cellTitleLabel];
        
        UILabel *likesLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 30.0, 70.0, 16.0)];
        likesLeftLabel.font = [UIFont systemFontOfSize:14.0];
        likesLeftLabel.textAlignment = NSTextAlignmentRight;
        likesLeftLabel.textColor = [UIColor darkGrayColor];
        likesLeftLabel.text = @"Likes";
        [self.contentView addSubview:likesLeftLabel];
        
        UILabel *metacriticLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 50.0, 70.0, 16.0)];
        metacriticLeftLabel.font = [UIFont systemFontOfSize:14.0];
        metacriticLeftLabel.textAlignment = NSTextAlignmentRight;
        metacriticLeftLabel.textColor = [UIColor darkGrayColor];
        metacriticLeftLabel.text = @"Metacritic";
        [self.contentView addSubview:metacriticLeftLabel];
        
        _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 30.0, 230.0, 16.0)];
        _likeLabel.font = [UIFont systemFontOfSize:14.0];
        _likeLabel.textAlignment = NSTextAlignmentLeft;
        _likeLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_likeLabel];
        
        _metacriticRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 50.0, 230.0, 16.0)];
        _metacriticRatingLabel.font = [UIFont systemFontOfSize:14.0];
        _metacriticRatingLabel.textAlignment = NSTextAlignmentLeft;
        _metacriticRatingLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_metacriticRatingLabel];
    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
