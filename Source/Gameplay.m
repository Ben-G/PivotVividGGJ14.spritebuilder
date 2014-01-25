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

@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    CCNode *_level;
    CCNode *_hero;
    CCNode *_contentNode;
    
    BOOL _onGround;
    BOOL _dontJump;
    BOOL _moodChangePossible;
    
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
    
    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:2.f position:ccp(100, 0)];
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
}

#pragma mark - Update

- (void)update:(CCTime)delta {
    _hero.physicsBody.angularVelocity = 0.f;
    _hero.rotation = 0.f;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    _touchStartPosition = [touch locationInNode:self];
    [self performSelector:@selector(jump) withObject:nil afterDelay:0.1f];
    _moodChangePossible = TRUE;
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if (!_moodChangePossible) {
        return;
    }
    
    CGPoint currentPos = [touch locationInNode:self];
    CGFloat distance = ccpDistance(currentPos, _touchStartPosition);
    
    if (fabs(distance) > 20.f) {
        _dontJump = TRUE;
        [self switchMood];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(jump) object:nil];
        _moodChangePossible = FALSE;
    }
}

- (void)switchMood {
    _currentMoodIndex += 1;
    
    if (_currentMoodIndex >= [_moods count]) {
        _currentMoodIndex = 0;
    }
    
    Mood *newMood = _moods[_currentMoodIndex];
    
    NSString *spriteFrameName = [NSString stringWithFormat:@"art/%@_block.png", newMood.moodPrefix];
    CCSpriteFrame* spriteFrame = [CCSpriteFrame frameWithImageNamed:spriteFrameName];

    for (GroundBlock *block in _blocks) {
        [block setSpriteFrame:spriteFrame];
    }
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
