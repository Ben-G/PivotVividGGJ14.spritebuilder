//
//  Gameplay.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "CCActionFollowGGJ.h"

@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    CCNode *_level;
    CCNode *_hero;
    CCNode *_contentNode;
    
    BOOL _onGround;
}

#pragma mark - Init

- (void)didLoadFromCCB {
    _level = [CCBReader load:@"Level1"];
    
    _hero.physicsBody.allowsRotation = FALSE;
    _hero.physicsBody.collisionType = @"hero";
    
    [_physicsNode addChild:_level];
    _physicsNode.collisionDelegate = self;
    
    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:2.f position:ccp(100, 0)];
    CCActionRepeatForever *repeatMovement = [CCActionRepeatForever actionWithAction:moveBy];
    [_hero runAction:repeatMovement];
    
    CCActionFollowGGJ *followHero = [CCActionFollowGGJ actionWithTarget:_hero worldBoundary:_level.boundingBox];
    [_contentNode runAction:followHero];
    
    self.userInteractionEnabled = TRUE;
}

#pragma mark - Update

- (void)update:(CCTime)delta {
    _hero.physicsBody.angularVelocity = 0.f;
    _hero.rotation = 0.f;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//    CGPoint position = [touch locationInNode:_level];
    [self jump];
}

- (void)jump {
    if (_onGround) {
        _onGround = FALSE;
        [_hero.physicsBody applyForce:ccp(0, 50000)];
    }
}

#pragma mark - Collision Handling

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero ground:(CCNode *)ground {
    if (pair.totalImpulse.y > fabs(pair.totalImpulse.x)) {
        _onGround = TRUE;
    }
}

-(void)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero ground:(CCNode *)ground {
    _onGround = FALSE;
}

@end
