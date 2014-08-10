//
//  PurchaseScreen.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 10/08/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PurchaseScreen.h"

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
}

- (void)purchase {
    [MGWU logEvent:@"PurchaseScreen_Purchase_YES"];
}

@end
