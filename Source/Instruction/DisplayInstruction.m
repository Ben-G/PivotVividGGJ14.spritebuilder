//
//  DisplayInstruction.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 27/07/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "DisplayInstruction.h"

@implementation DisplayInstruction

- (void)completeInstruction {
    [self.animationManager runAnimationsForSequenceNamed:@"Complete"];
    [self.animationManager setCompletedAnimationCallbackBlock:^(id sender) {
        [self removeFromParent];
    }];
}

@end
