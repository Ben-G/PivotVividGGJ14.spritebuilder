//
//  Hero.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Hero.h"

@implementation Hero

- (id)init {
    self = [super initWithPlist:@"happy_default.plist"];
    
    if (self) {
        [self addAnimationwithDelayBetweenFrames:1/30.f name:@"happy"];
        [self runAnimation:@"happy"];
    }
    
    return self;
}

- (void)didLoadFromCCB {
    self.previousPosition = self.position;
}

@end
