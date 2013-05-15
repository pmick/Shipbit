//
//  SBSummaryCell.m
//  Shipbit
//
//  Created by Patrick Mick on 1/21/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBSummaryCell.h"

@implementation SBSummaryCell

@synthesize summaryLabel = _summaryLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 10.0, 210.0, 16.0)];
        cellTitleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        cellTitleLabel.textAlignment = NSTextAlignmentLeft;
        cellTitleLabel.textColor = [UIColor blackColor];
        cellTitleLabel.text = NSLocalizedString(@"Summary", nil);
        [self.contentView addSubview:cellTitleLabel];
        
        _summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 30.0, 280.0, 14.0)];
        _summaryLabel.font = [UIFont systemFontOfSize:14.0];
        _summaryLabel.textAlignment = NSTextAlignmentLeft;
        _summaryLabel.textColor = [UIColor blackColor];
        _summaryLabel.numberOfLines = 0;
        [self.contentView addSubview:_summaryLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
