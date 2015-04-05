//
//  SBGameTableViewCell+ConfigureForGame.h
//  Shipbit
//
//  Created by Patrick Mick on 4/5/15.
//  Copyright (c) 2015 PatrickMick. All rights reserved.
//

#import "SBGameTableViewCell.h"

@class Game;

@interface SBGameTableViewCell (ConfigureForGame)

- (void)configureForGame:(Game *)game;

@end
