//
//  LightSource.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 03/08/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "LightingLayer.h"
#import "Mood.h"

@interface LightSource : CCNode <Light>

@property (nonatomic, strong) Mood *mood;

@end
