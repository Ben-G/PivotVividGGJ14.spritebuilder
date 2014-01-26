//
//  Enemy.m
//  PivotVividGGJ14
//
//  Created by Guest on 1/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy

- (id)init {
    self = [super initWithPlist:@"angrymask_default.plist"];
    
    if (self) {
        [self addAnimationwithDelayBetweenFrames:1/30.f name:@"angrymask"];
        [self setFrame:@"angrymask0001.png"];
        [self runAnimation:@"angrymask"];
    }
    
    return self;
}

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"enemy";
}

@end
