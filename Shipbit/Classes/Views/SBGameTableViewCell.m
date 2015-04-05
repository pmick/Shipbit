//
//  SBGameTableViewCell.m
//  Shipbit
//
//  Created by Patrick Mick on 4/5/15.
//  Copyright (c) 2015 PatrickMick. All rights reserved.
//

#import "SBGameTableViewCell.h"

@implementation SBGameTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.thumbnailImageView.image = nil;
    self.titleLabel.text = nil;
    self.dateLabel.text = nil;
    self.platformsLabel.text = nil;
}

@end
