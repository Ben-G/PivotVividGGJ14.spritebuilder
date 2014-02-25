//
//  Gameplay.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Level.h"

@interface Gameplay : CCNode <CCPhysicsCollisionDelegate>

@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, strong) Level *level;

- (void)didLoadFromCCB;
- (void)restartLevel;
- (void)stopMusic;

@end
