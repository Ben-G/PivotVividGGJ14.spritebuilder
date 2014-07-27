//
//  Level.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 26/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : CCNode

@property (nonatomic, assign) CGFloat levelSpeed;
@property (nonatomic, assign) int initialMasks;
@property (nonatomic, assign) CGPoint startPosition;
@property (nonatomic, strong) NSArray *instructions;

@end
