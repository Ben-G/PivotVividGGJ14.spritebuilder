//
//  Hero.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "CCAnimatedSprite.h"
#import "Mood.h"

@interface Hero : CCAnimatedSprite

- (void)applyMood:(Mood*)mood;

@property (nonatomic, assign) CGPoint previousPosition;
@property (nonatomic, assign) float speed;

@end
