//
//  UIDeviceHardware.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 10/08/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIDeviceHardware : NSObject

+ (NSString *) platform;
+ (NSString *) platformString;
+ (BOOL)iPhone4OrOlder;

@end
