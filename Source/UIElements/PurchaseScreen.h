//
//  PurchaseScreen.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 10/08/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface PurchaseScreen : CCNode

@property (nonatomic, copy) void (^purchaseCompleteBlock)();

@end
