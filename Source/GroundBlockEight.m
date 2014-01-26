//
//  GroundBlockEight.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 25/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GroundBlockEight.h"
#import "Mood.h"

@implementation GroundBlockEight

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"ground";
}

- (void)applyMood:(Mood*)newMood {
    
    NSString *spriteFrameName = [NSString stringWithFormat:@"art/%@_blocklong.png", newMood.moodPrefix];
    
    if (self.onlyVisibleInMood) {
        if ([newMood.moodPrefix isEqualToString:self.onlyVisibleInMood]) {
            self.physicsBody.collisionMask = nil;
            self.opacity = 1.f;
        } else {
            self.physicsBody.collisionMask = @[];
            self.opacity = 0.4f;
            spriteFrameName = [NSString stringWithFormat:@"art/%@_blocklong.png", _onlyVisibleInMood];
        }
    }
    
    CCSpriteFrame* spriteFrame = [CCSpriteFrame frameWithImageNamed:spriteFrameName];
    
    [self setSpriteFrame:spriteFrame];
}

@end
