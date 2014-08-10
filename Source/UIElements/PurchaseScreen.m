//
//  PurchaseScreen.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 10/08/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PurchaseScreen.h"
#import "IAPManager.h"

@implementation PurchaseScreen

- (void)onEnter {
    [super onEnter];
    
    [MGWU logEvent:@"PurchaseScreen_Show"];
}

- (void)noPurchase1 {
    [MGWU logEvent:@"PurchaseScreen_Purchase1_NO"];

    [self.animationManager runAnimationsForSequenceNamed:@"ShowDetails"];
}

- (void)noPurchase2 {
    [MGWU logEvent:@"PurchaseScreen_Purchase2_NO"];
    
    CCScene *startScreen = [CCBReader loadAsScene:@"Startscreen"];
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:1.f];
    [[CCDirector sharedDirector] replaceScene:startScreen withTransition:transition];
}

- (void)purchase {
    [MGWU logEvent:@"PurchaseScreen_Purchase_YES"];
    [[IAPManager sharedInstance] purchasePremiumWithTarget:self callback:@selector(purchaseCallback:)];
}

- (void)purchaseAnimationComplete {
    self.purchaseCompleteBlock();
}

#pragma mark - IAP Callback

- (void)purchaseCallback:(NSNumber *)purchaseCallback {
    if ([purchaseCallback boolValue] == YES) {
        [self.animationManager runAnimationsForSequenceNamed:@"ShowSuccess"];
    }
}

@end
