//
//  SBInfoView.h
//  Shipbit
//
//  Created by Patrick Mick on 5/22/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBInfoView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *releaseDateLabel;
@property (nonatomic, strong) UILabel *genreLabel;
@property (nonatomic, strong) UILabel *developerLabel;
@property (nonatomic, strong) UILabel *publisherLabel;
@property (nonatomic, strong) UILabel *esrbLabel;
@property (nonatomic, strong) UILabel *platformsLabel;

@end
