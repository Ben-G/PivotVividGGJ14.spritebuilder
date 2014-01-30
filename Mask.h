//
//  Mask.h
//  PivotVividGGJ14
//
//  Created by Guest on 1/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
@class Mood;

@interface Mask : CCSprite

@property (nonatomic, assign) Mood *mood;
@property (nonatomic, assign) CGPoint previousPosition;

@end
