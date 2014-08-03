//
//  LevelTile.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 21/07/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelTile.h"

@implementation LevelTile {
    CCSprite *_lock;
}

- (void)onEnter {
    [super onEnter];
    
    self.userInteractionEnabled = YES;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (!self.locked) {
        self.levelSelectionBlock();
    }
}

- (void)setLocked:(BOOL)locked {
    _locked = locked;
    _lock.visible = locked;
}

@end
