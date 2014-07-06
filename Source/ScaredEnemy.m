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
    return [super initWithPlist:@"scaredmask_default.plist"];
}

- (void)didLoadFromCCB {
  [self addAnimationwithDelayBetweenFrames:1/30.f name:@"scaredmask"];
  [self setFrame:@"scaredmask0001.png"];
  [self runAnimation:@"scaredmask"];
  self.moodToKill = @"fear";
}

@end
