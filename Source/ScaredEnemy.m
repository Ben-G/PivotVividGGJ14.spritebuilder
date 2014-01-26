//
//  ScaredEnemy.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 26/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ScaredEnemy.h"

@implementation ScaredEnemy

- (id)init {
    self = [super initWithPlist:@"scaredmask_default.plist"];
    
    if (self) {
        [self addAnimationwithDelayBetweenFrames:1/30.f name:@"scaredmask"];
        [self setFrame:@"scaredmask0001.png"];
        [self runAnimation:@"scaredmask"];
        self.moodToKill = @"fear";
    }
    
    return self;
}

@end
