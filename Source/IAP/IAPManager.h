//
//  IAPManager.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 09/08/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)hasPurchasedPremium;
- (void)purchasePremiumWithTarget:(id)target callback:(SEL)callback;
- (void)restorePremiumWithTarget:(id)target callback:(SEL)callback;

@end
