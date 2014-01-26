//
//  AngryEnemy.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 26/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "AngryEnemy.h"

@implementation AngryEnemy

- (id)init {
    self = [super initWithPlist:@"angrymask_default.plist"];
    
    if (self) {
        [self addAnimationwithDelayBetweenFrames:1/30.f name:@"angrymask"];
        [self setFrame:@"angrymask0001.png"];
        [self runAnimation:@"angrymask"];
        self.moodToKill = @"angry";
    }
    
    return self;
}

@end
