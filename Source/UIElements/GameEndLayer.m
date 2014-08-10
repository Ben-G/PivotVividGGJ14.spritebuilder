//
//  GameEndLayer.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 02/08/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameEndLayer.h"
#import "UIDeviceHardware.h"

@implementation GameEndLayer {
    CCNodeColor *_progressBar;
    CCLabelTTF *_hintLabel;
    
    CCButton *_watchReplayButton;
    CCButton *_nextLevelButton;
}

- (void)onEnter {
    if ([UIDeviceHardware iPhone4OrOlder]) {
        [_watchReplayButton removeFromParent];
        // center nextLevel Button, because replay button doesn't exist
        _nextLevelButton.position = ccp(0.5f, _nextLevelButton.position.y);
    }
    
    [super onEnter];
}

- (void)onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];
    
    CCActionFadeIn *fadeIn = [CCActionFadeIn actionWithDuration:1.f];
    [_progressBar runAction:fadeIn];
}

- (void)displayCompletionRate:(CGFloat)completionRate {
    _progressBar.scaleX = completionRate;
}

- (void)displayHint:(NSString *)hint {
    _hintLabel.string = hint;
}

@end
