//
//  SBGameTableViewCell.h
//  Shipbit
//
//  Created by Patrick Mick on 4/5/15.
//  Copyright (c) 2015 PatrickMick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBGameTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *platformsLabel;

@end
