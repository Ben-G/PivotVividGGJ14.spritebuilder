//
//  GroundBlock.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GroundBlock.h"
#import "Mood.h"

@implementation GroundBlock

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"ground";
}

- (void)applyMood:(Mood*)newMood {
    if (self.onlyVisibleInMood) {
        if ([newMood.moodPrefix isEqualToString:self.onlyVisibleInMood]) {
            self.physicsBody.collisionMask = nil;
            self.visible = TRUE;
        } else {
            self.physicsBody.collisionMask = @[];
            self.visible = FALSE;
        }
    }
    
    NSString *spriteFrameName = [NSString stringWithFormat:@"art/%@_block.png", newMood.moodPrefix];
    CCSpriteFrame* spriteFrame = [CCSpriteFrame frameWithImageNamed:spriteFrameName];
    
    [self setSpriteFrame:spriteFrame];
}

@end
