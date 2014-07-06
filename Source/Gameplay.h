//
//  Gameplay.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Level.h"

@class Hero;

@interface Gameplay : CCNode <CCPhysicsCollisionDelegate>

@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, strong) Level *level;
@property (nonatomic, strong) Hero *hero;

@property (nonatomic, strong) CCPhysicsNode *contentNode;

- (void)didLoadFromCCB;
- (void)restartLevel;
- (void)stopMusic;
- (void)findBlocks:(CCNode *)node;
- (void)removeAllBlocks;
- (void)jump;
- (void)switchMood;
- (void)endGame;
- (void)winGame;

@end
