//
//  KamcordRecorder+Metal.h
//  Kamcord
//
//  Created by Sam Green on 10/15/14.
//  Copyright (c) 2014 Kamcord. All rights reserved.
//

#import "KamcordRecorder.h"
#ifdef __arm64__
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>
#endif

@interface KamcordRecorder ()
+ (void)configureLayer:(CAMetalLayer *)layer fromDevice:(id<MTLDevice>)device;
+ (void)setCurrentDrawable:(id<CAMetalDrawable>)drawable;
+ (void)addMetalCommands:(id<MTLCommandBuffer>)commandBuffer;
@end