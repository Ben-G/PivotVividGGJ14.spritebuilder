//
//  GroundBlock64.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 25/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@class Mood;

@interface GroundBlock64 : CCSprite

- (void)applyMood:(Mood*)mood;

@property (nonatomic, strong) NSString *onlyVisibleInMood;

@end
