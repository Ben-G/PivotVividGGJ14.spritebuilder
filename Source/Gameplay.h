//
//  Gameplay.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Level.h"

typedef NS_ENUM(NSInteger, DeathType) {
    DeathTypeOffScreen,
    DeathTypeEnemy,
    DeathEvilSmoke
};

@class Hero;

@interface Gameplay : CCNode <CCPhysicsCollisionDelegate>

@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, strong) Level *level;
@property (nonatomic, strong) Hero *hero;
// array of masks the player has; masks are required for mood changes
@property (nonatomic, strong) NSMutableArray *masks;
@property (nonatomic, strong) CCPhysicsNode *contentNode;

- (void)didLoadFromCCB;
- (void)restartLevel;
- (void)stopMusic;
- (void)findBlocks:(CCNode *)node;
- (void)removeAllBlocks;
- (void)jump;
- (void)switchMood;
- (void)endGame:(DeathType)deathType;
- (void)winGame;
- (void)addMaskAtPosition:(CGPoint)pos;

@end
