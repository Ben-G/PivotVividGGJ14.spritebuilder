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

// callback should take 1 parameter of type NSNumber to indicate success of purchase
- (void)purchasePremiumWithTarget:(id)target callback:(SEL)callback;

// callback should take 1 parameter of type NSNumber to indicate success of restore
- (void)restorePremiumWithTarget:(id)target callback:(SEL)callback;

@end
