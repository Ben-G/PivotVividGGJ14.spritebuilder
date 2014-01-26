//
//  BasicEnemy.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 25/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "BasicEnemy.h"

@implementation BasicEnemy

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"enemy";
    
    CCActionMoveBy *moveDown = [CCActionMoveBy actionWithDuration:2.f position:ccp(0.f, -200.f)];
    CCActionMoveBy *moveUp = [CCActionMoveBy actionWithDuration:2.f position:ccp(0.f, 200.f)];
    
    CCActionSequence *moveSequence = [CCActionSequence actions:moveUp, moveDown, nil];
    CCActionRepeatForever *repeat = [CCActionRepeatForever actionWithAction:moveSequence];

    [self runAction:repeat];
}

@end
