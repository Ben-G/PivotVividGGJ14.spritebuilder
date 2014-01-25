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
    CCNode *_contentNode;
}

- (void)didLoadFromCCB {
    _level = [CCBReader load:@"Level1"];
    
    _hero.physicsBody.allowsRotation = FALSE;
    
    [_physicsNode addChild:_level];
    
    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:2.f position:ccp(100, 0)];
    CCActionRepeatForever *repeatMovement = [CCActionRepeatForever actionWithAction:moveBy];
    [_hero runAction:repeatMovement];
    
    CCActionFollow *followHero = [CCActionFollow actionWithTarget:_hero worldBoundary:_level.boundingBox];
    [_contentNode runAction:followHero];
    
    self.userInteractionEnabled = TRUE;
}

- (void)update:(CCTime)delta {
    _hero.physicsBody.angularVelocity = 0.f;
    _hero.rotation = 0.f;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//    CGPoint position = [touch locationInNode:_level];
    [self jump];
}

- (void)jump {
    [_hero.physicsBody applyForce:ccp(0, 50000)];
}

@end
