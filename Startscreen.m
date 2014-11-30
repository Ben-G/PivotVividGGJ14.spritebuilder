//
//  Startscreen.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 26/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Startscreen.h"
#import "UIUtils.h"

@implementation Startscreen {
    CCLabelTTF *_label;
    CCNode *_backgroundImage;
    BOOL _loading;
}

- (void)startNow {
    if (!_loading) {
        _loading = YES;
        CCNode *loadingScreen = [CCBReader load:@"UI/LoadingScreen"];
        [self addChild:loadingScreen];
        [self performSelector:@selector(start) withObject:nil afterDelay:0.1f];
    }
}

- (void)start {
    presentGameplaySceneWithCurrentLevel();
}

- (void)levelSelect {
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:0.3f];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:transition];
}

@end
