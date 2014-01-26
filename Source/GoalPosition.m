//
//  GoalPosition.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 26/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GoalPosition.h"

@implementation GoalPosition

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"goal";
}

@end
