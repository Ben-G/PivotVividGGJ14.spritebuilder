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
    self = [super initWithPlist:@"hero_default.plist"];
    
    if (self) {
        [self addAnimationwithDelayBetweenFrames:1/30.f name:@"happy"];
        [self addAnimationwithDelayBetweenFrames:1/30.f name:@"angry"];
        [self addAnimationwithDelayBetweenFrames:1/30.f name:@"calm"];
        [self addAnimationwithDelayBetweenFrames:1/30.f name:@"fear"];
        [self addAnimationwithDelayBetweenFrames:1/30.f name:@"kaput"];
        [self setFrame:@"happy0001.png"];
    }
    
    return self;
}

- (void)didLoadFromCCB {
    self.previousPosition = self.position;
}

- (void)applyMood:(Mood*)mood {
    [self setFrame:[NSString stringWithFormat:@"%@0001.png", mood.moodPrefix]];
    [self runAnimation:mood.moodPrefix];
}

- (void)runDeathAnimation {
    [self runAnimationOnce:@"kaput"];
}

@end
