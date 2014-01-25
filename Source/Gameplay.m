//
//  Gameplay.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    CCNode *_level;
    CCNode *_hero;
}

- (void)didLoadFromCCB {
    _level = [CCBReader load:@"Level1"];
    
    [_physicsNode addChild:_level];
    
    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:2.f position:ccp(100, 0)];
    CCActionRepeatForever *repeatMovement = [CCActionRepeatForever actionWithAction:moveBy];
    [_hero runAction:repeatMovement];
    
    CCActionFollow *followHero = [CCActionFollow actionWithTarget:_hero worldBoundary:_level.boundingBox];
    [self runAction:followHero];
}

@end
