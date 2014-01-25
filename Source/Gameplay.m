//
//  Gameplay.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "CCActionFollowGGJ.h"
#import "GroundBlock.h"
#import "Mood.h"
#import "BasicEnemy.h"

@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    CCNode *_level;
    CCNode *_hero;
    CCNode *_contentNode;
    
    BOOL _onGround;
    
    int _currentMoodIndex;
    
    NSMutableArray *_blocks;
    NSArray *_moods;
    
    CGPoint _touchStartPosition;
}

#pragma mark - Init

- (void)didLoadFromCCB {
    _currentMoodIndex = 0;
    _level = [CCBReader load:@"Level1"];
    
    _hero.physicsBody.allowsRotation = FALSE;
    _hero.physicsBody.collisionType = @"hero";
    
    [_physicsNode addChild:_level];
    _physicsNode.collisionDelegate = self;
//    _physicsNode.debugDraw = TRUE;
    
    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:2.f position:ccp(200, 0)];
    CCActionRepeatForever *repeatMovement = [CCActionRepeatForever actionWithAction:moveBy];
    [_hero runAction:repeatMovement];
    
    CCActionFollowGGJ *followHero = [CCActionFollowGGJ actionWithTarget:_hero worldBoundary:_level.boundingBox];
    [_contentNode runAction:followHero];
    
    self.userInteractionEnabled = TRUE;
    
    _blocks = [NSMutableArray array];
    
    for (CCNode *child in _level.children) {
        if ([child isKindOfClass:[GroundBlock class]]) {
            [_blocks addObject:child];
        }
    }
    
    Mood *happy = [[Mood alloc] init];
    happy.moodPrefix = @"happy";
    
    Mood *angry = [[Mood alloc] init];
    angry.moodPrefix = @"angry";
    
    Mood *calm = [[Mood alloc] init];
    calm.moodPrefix = @"calm";
    
    _moods = @[happy, angry, calm];
    [self switchMood];
}

#pragma mark - Update

- (void)update:(CCTime)delta {
    _hero.physicsBody.angularVelocity = 0.f;
    _hero.rotation = 0.f;
    if ((_hero.boundingBox.origin.y + _hero.boundingBox.size.height) < 0) {
        [self endGame];
    }
}

- (void)endGame {
    CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    _touchStartPosition = [touch locationInNode:self];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint currentPos = [touch locationInNode:self];
    CGFloat distance = ccpDistance(currentPos, _touchStartPosition);
    if (distance > 20.f /*&& (slope < 1 || slope > -1) && _onGround*/) {
        [self switchMood];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(jump) object:nil];

    }
    else {
        [self jump];
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {

}

- (void)switchMood {
    _currentMoodIndex += 1;
    
    if (_currentMoodIndex >= [_moods count]) {
        _currentMoodIndex = 0;
    }
    
    Mood *newMood = _moods[_currentMoodIndex];
    
    for (GroundBlock *block in _blocks) {
        [block applyMood:newMood];
    }
}

- (void)jump {
    if (_onGround) {
        _onGround = FALSE;
        [_hero.physicsBody applyForce:ccp(0, 50000)];
    }
}

- (void)dash {
    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:.5f position:ccp(25, 0)];
    [_hero runAction:moveBy];
}

#pragma mark - Collision Handling

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero ground:(CCNode *)ground {
    CCLOG(@"x:%f y:%f", pair.totalImpulse.x, pair.totalImpulse.y);

    if (pair.totalImpulse.y > fabs(pair.totalImpulse.x)) {
        _onGround = TRUE;
    }
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero enemy:(CCNode *)enemy {
    
    BasicEnemy *basicEnemy = (BasicEnemy*)enemy;
    
    NSString *moodPrefix = [_moods[_currentMoodIndex] moodPrefix];
    
    if ([basicEnemy.moodToKill isEqualToString:moodPrefix]) {
        [basicEnemy removeFromParentAndCleanup:TRUE];
    } else {
        [self endGame];
    }
}

-(void)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero ground:(CCNode *)ground {
    _onGround = FALSE;
}

@end
