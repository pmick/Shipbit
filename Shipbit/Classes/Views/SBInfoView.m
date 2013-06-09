//
//  SBInfoView.m
//  Shipbit
//
//  Created by Patrick Mick on 5/22/13.
//  Copyright (c) 2013 PatrickMick. All rights reserved.
//

#import "SBInfoView.h"

@implementation SBInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *sbDarkGrayColor = [UIColor colorWithHexValue:@"514D4A"];
        
        UILabel *titleLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 12.0, 85.0, 16.0)];
        titleLeftLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        titleLeftLabel.backgroundColor = [UIColor clearColor];
        titleLeftLabel.textAlignment = NSTextAlignmentRight;
        titleLeftLabel.textColor = sbDarkGrayColor;
        titleLeftLabel.text = NSLocalizedString(@"Title", nil);
        [self addSubview:titleLeftLabel];
        
        UILabel *releaseDateLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 32.0, 85.0, 16.0)];
        releaseDateLeftLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        releaseDateLeftLabel.backgroundColor = [UIColor clearColor];
        releaseDateLeftLabel.textAlignment = NSTextAlignmentRight;
        releaseDateLeftLabel.textColor = sbDarkGrayColor;
        releaseDateLeftLabel.text = NSLocalizedString(@"Release Date", nil);
        [self addSubview:releaseDateLeftLabel];
        
        UILabel *genreLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 52.0, 85.0, 16.0)];
        genreLeftLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        genreLeftLabel.backgroundColor = [UIColor clearColor];
        genreLeftLabel.textAlignment = NSTextAlignmentRight;
        genreLeftLabel.textColor = sbDarkGrayColor;
        genreLeftLabel.text = NSLocalizedString(@"Genre", nil);
        [self addSubview:genreLeftLabel];
        
        UILabel *developerLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 72.0, 85.0, 16.0)];
        developerLeftLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        developerLeftLabel.backgroundColor = [UIColor clearColor];
        developerLeftLabel.textAlignment = NSTextAlignmentRight;
        developerLeftLabel.textColor = sbDarkGrayColor;
        developerLeftLabel.text = NSLocalizedString(@"Developer", nil);
        [self addSubview:developerLeftLabel];
        
        UILabel *publisherLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 92.0, 85.0, 16.0)];
        publisherLeftLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        publisherLeftLabel.backgroundColor = [UIColor clearColor];
        publisherLeftLabel.textAlignment = NSTextAlignmentRight;
        publisherLeftLabel.textColor = sbDarkGrayColor;
        publisherLeftLabel.text = NSLocalizedString(@"Publisher", nil);
        [self addSubview:publisherLeftLabel];
        
        UILabel *esrbLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 112.0, 85.0, 16.0)];
        esrbLeftLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        esrbLeftLabel.backgroundColor = [UIColor clearColor];
        esrbLeftLabel.textAlignment = NSTextAlignmentRight;
        esrbLeftLabel.textColor = sbDarkGrayColor;
        esrbLeftLabel.text = NSLocalizedString(@"ESRB", nil);
        [self addSubview:esrbLeftLabel];
        
        UILabel *platformsLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 132.0, 85.0, 16.0)];
        platformsLeftLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        platformsLeftLabel.backgroundColor = [UIColor clearColor];
        platformsLeftLabel.textAlignment = NSTextAlignmentRight;
        platformsLeftLabel.textColor = sbDarkGrayColor;
        platformsLeftLabel.text = NSLocalizedString(@"Platforms", nil);
        [self addSubview:platformsLeftLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(112.0, 12.0, 190.0, 16.0)];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = sbDarkGrayColor;
        _titleLabel.text = @"text text text";
        [self addSubview:_titleLabel];
        
        _releaseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(112.0, 32.0, 190.0, 16.0)];
        _releaseDateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _releaseDateLabel.backgroundColor = [UIColor clearColor];
        _releaseDateLabel.textAlignment = NSTextAlignmentLeft;
        _releaseDateLabel.textColor = sbDarkGrayColor;
        _releaseDateLabel.text = @"text text text";
        [self addSubview:_releaseDateLabel];
        
        _genreLabel = [[UILabel alloc] initWithFrame:CGRectMake(112.0, 52.0, 190.0, 16.0)];
        _genreLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _genreLabel.backgroundColor = [UIColor clearColor];
        _genreLabel.textAlignment = NSTextAlignmentLeft;
        _genreLabel.textColor = sbDarkGrayColor;
        _genreLabel.text = @"text text text";
        [self addSubview:_genreLabel];
        
        _developerLabel = [[UILabel alloc] initWithFrame:CGRectMake(112.0, 72.0, 190.0, 16.0)];
        _developerLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _developerLabel.backgroundColor = [UIColor clearColor];
        _developerLabel.textAlignment = NSTextAlignmentLeft;
        _developerLabel.textColor = sbDarkGrayColor;
        _developerLabel.text = @"text text text";
        [self addSubview:_developerLabel];
        
        _publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(112.0, 92.0, 190.0, 16.0)];
        _publisherLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _publisherLabel.backgroundColor = [UIColor clearColor];
        _publisherLabel.textAlignment = NSTextAlignmentLeft;
        _publisherLabel.textColor = sbDarkGrayColor;
        _publisherLabel.text = @"text text text";
        [self addSubview:_publisherLabel];
        
        _esrbLabel = [[UILabel alloc] initWithFrame:CGRectMake(112.0, 112.0, 190.0, 16.0)];
        _esrbLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _esrbLabel.backgroundColor = [UIColor clearColor];
        _esrbLabel.textAlignment = NSTextAlignmentLeft;
        _esrbLabel.textColor = sbDarkGrayColor;
        _esrbLabel.text = @"text text text";
        [self addSubview:_esrbLabel];
        
        _platformsLabel = [[UILabel alloc] initWithFrame:CGRectMake(112.0, 132.0, 190.0, 16.0)];
        _platformsLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        _platformsLabel.backgroundColor = [UIColor clearColor];
        _platformsLabel.textAlignment = NSTextAlignmentLeft;
        _platformsLabel.textColor = sbDarkGrayColor;
        _platformsLabel.text = @"text text text";
        [self addSubview:_platformsLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
