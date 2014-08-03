//
//  LightSource.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 03/08/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LightSource.h"

@implementation LightSource

-(float)lightRadius
{
	return 350.f;
}

-(GLKVector4)lightColor
{
//    return self.mood.moodColor.glkVector4;
    return (GLKVector4){{0.8f, 0.8f, 0.8f, 1.0f}};
}

@end
