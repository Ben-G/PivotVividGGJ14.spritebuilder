//
//  SadEnemy.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 26/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SadEnemy.h"

@implementation SadEnemy

- (id)init {
    return [super initWithPlist:@"sadmask_default.plist"];
}

- (void)didLoadFromCCB {
  [self addAnimationwithDelayBetweenFrames:1/30.f name:@"sadmask"];
  [self setFrame:@"sadmask0001.png"];
  [self runAnimation:@"sadmask"];
  self.moodToKill = @"calm";
}

@end