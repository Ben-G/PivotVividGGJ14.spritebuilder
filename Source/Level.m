//
//  Level.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 26/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Level.h"

static const int INITIAL_MASKS = 5;
static const float BASE_SPEED = 200.f;

@implementation Level

- (id)init {
    self = [super init];
    
    if (self) {
        // initialize with defaults - SpriteBuilder properties of level may override these settings
        self.initialMasks = INITIAL_MASKS;
        self.levelSpeed = BASE_SPEED;
    }
    
    return self;
}

@end
