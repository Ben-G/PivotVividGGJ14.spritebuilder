//
//  GroundBlock.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GroundBlock.h"

@implementation GroundBlock

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"ground";
}

@end
