//
//  FinalWinScene.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 30/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "FinalWinScene.h"

@implementation FinalWinScene {
    BOOL _animationCompleted;
}

- (void)animationComplete {
    if (!_animationCompleted) {
        _animationCompleted = YES;
        CCScene *startScene = [CCBReader loadAsScene:@"Startscreen"];
        CCTransition *fadeIn = [CCTransition transitionFadeWithDuration:1.5f];
        [[CCDirector sharedDirector] replaceScene:startScene withTransition:fadeIn];
    }
}

@end
