//
//  IAPManager.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 09/08/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "IAPManager.h"

// key for MGWU secure User Defaults to check if purchase happened
static NSString * const IAP_PREMIUM = @"PurchasedPremium";
// IAP ID
static NSString * const IAP_PREMIUM_ID = @"com.benjaminencz.magicmasks.premium";


@implementation IAPManager

+ (instancetype)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (BOOL)hasPurchasedPremium {
    NSNumber *isPremiumPurchased = [MGWU objectForKey:IAP_PREMIUM];
    return [isPremiumPurchased boolValue];
}

- (void)purchasePremiumWithTarget:(id)target callback:(SEL)callback {
#if DEBUG
    [MGWU testBuyProduct:IAP_PREMIUM_ID withCallback:@selector(purchasedPremium) onTarget:self];
#elif
    [MGWU buyProduct:IAP_PREMIUM_ID withCallback:@selector(purchasedPremium) onTarget:self];
#endif
}

- (void)restorePremiumWithTarget:(id)target callback:(SEL)callback {
#if DEBUG
    [MGWU testRestoreProducts:@[IAP_PREMIUM_ID] withCallback:@selector(restoredPremium) onTarget:self];
#elif
    [MGWU restoreProductsWithCallback:@selector(restoredPremium) onTarget:self];
#endif
}

@end
