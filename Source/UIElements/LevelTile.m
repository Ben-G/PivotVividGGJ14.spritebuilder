//
//  LevelTile.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 21/07/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelTile.h"

@implementation LevelTile

- (void)onEnter {
    [super onEnter];
    
    self.userInteractionEnabled = YES;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    self.levelSelectionBlock();
}

@end
