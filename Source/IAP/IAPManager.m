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


@implementation IAPManager {
    id _purchaseTarget;
    SEL _purchaseSelector;
    
    id _restoreTarget;
    SEL _restoreSelector;
}

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
    
#ifdef DEBUG
    [MGWU removeObjectForKey:IAP_PREMIUM];
#endif
    
    // returns the same object each time
    return _sharedObject;
}

- (BOOL)hasPurchasedPremium {
    NSNumber *isPremiumPurchased = [MGWU objectForKey:IAP_PREMIUM];
    return [isPremiumPurchased boolValue];
}

- (void)purchasePremiumWithTarget:(id)target callback:(SEL)callback {
    [MGWU logEvent:@"Start_Purchase" withParams:@{@"product_id":IAP_PREMIUM_ID}];
    
    _purchaseTarget = target;
    _purchaseSelector = callback;
    
#if DEBUG
    [MGWU testBuyProduct:IAP_PREMIUM_ID withCallback:@selector(purchasedPremium:) onTarget:self];
#elif
    [MGWU buyProduct:IAP_PREMIUM_ID withCallback:@selector(purchasedPremium:) onTarget:self];
#endif
}

- (void)restorePremiumWithTarget:(id)target callback:(SEL)callback {
    [MGWU logEvent:@"Start_Restore"];

    _restoreTarget = target;
    _restoreSelector = callback;
    
#if DEBUG
    [MGWU testRestoreProducts:@[IAP_PREMIUM_ID] withCallback:@selector(restoredPremium:) onTarget:self];
#elif
    [MGWU restoreProductsWithCallback:@selector(restoredPremium:) onTarget:self];
#endif
}

- (void)purchasedPremium:(NSString *)articleID {
    if ([articleID isEqualToString:IAP_PREMIUM_ID]) {
        [MGWU logEvent:@"Completed_Purchase" withParams:@{@"product_id":IAP_PREMIUM_ID}];
        [MGWU setObject:@(YES) forKey:IAP_PREMIUM];
        [_purchaseTarget performSelector:_purchaseSelector withObject:@(YES)];
    } else {
        [MGWU logEvent:@"Cancelled_Purchase" withParams:@{@"product_id":IAP_PREMIUM_ID}];
        [_purchaseTarget performSelector:_purchaseSelector withObject:@(NO)];
    }
}

- (void)restoredPremium:(NSArray *)articleIDs {
    if ([articleIDs count] > 0) {
        for (NSString *article in articleIDs) {
            if ([article isEqualToString:IAP_PREMIUM_ID]) {
                [MGWU setObject:@(YES) forKey:IAP_PREMIUM];
            }
        }
        
        [MGWU logEvent:@"Completed_Restore" withParams:@{@"product_id":IAP_PREMIUM_ID}];
        
        [_restoreTarget performSelector:_restoreSelector withObject:@(YES)];
    } else {
        [_restoreTarget performSelector:_restoreSelector withObject:@(NO)];
    }
}

@end
