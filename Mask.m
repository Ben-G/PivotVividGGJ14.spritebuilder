//
//  Mask.m
//  PivotVividGGJ14
//
//  Created by Guest on 1/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Mask.h"
#import "Mood.h"

@implementation Mask

- (void)didLoadFromCCB {
    self.previousPosition = self.position;
}

- (void)setMood:(Mood *)mood {
    _mood = mood;
    self.color = mood.moodColor;
}

@end