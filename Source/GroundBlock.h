//
//  GroundBlock.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@class Mood;

@interface GroundBlock : CCSprite

- (void)applyMood:(Mood*)mood;

@property (nonatomic, strong) NSString *onlyVisibleInMood;

@end
