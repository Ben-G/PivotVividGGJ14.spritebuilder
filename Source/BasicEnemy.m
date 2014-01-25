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
    
//    CCActionMoveBy *moveLeft = [CCActionMoveBy actionWithDuration:2.f position:ccp(-200.f, 0.f)];
//    CCActionMoveBy *moveRight = [CCActionMoveBy actionWithDuration:2.f position:ccp(200.f, 0.f)];
    
//    CCActionSequence *moveSequence = [CCActionSequence actions:moveLeft, moveRight, nil];
//    CCActionRepeatForever *repeat = [CCActionRepeatForever actionWithAction:moveSequence];
//
//    [self runAction:repeat];
}

@end
