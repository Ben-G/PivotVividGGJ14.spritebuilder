//
//  GameEndLayer.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 02/08/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameEndLayer.h"
#import "UIDeviceHardware.h"
#import "GameState.h"

@implementation GameEndLayer {
    CCNodeColor *_progressBar;
    CCLabelTTF *_hintLabel;
    
    CCButton *_watchReplayButton;
    CCButton *_nextLevelButton;
    CCLabelTTF *_levelWinText;
}

- (void)onEnter {
    if ([UIDeviceHardware iPhone4OrOlder]) {
        [_watchReplayButton removeFromParent];
        // center nextLevel Button, because replay button doesn't exist
        _nextLevelButton.position = ccp(0.5f, _nextLevelButton.position.y);
    }

    NSUInteger levelCount = [[GameState sharedInstance] levelCount];
    int currentLevel = [[GameState sharedInstance] currentLevelIndex];
    
    NSString *winText = nil;
    
    if (currentLevel < 0.5 * levelCount) {
        winText = @"Still a long way to go!";
    } else {
        winText = @"You are better,\nbut not good enough";
    }
    
    if (currentLevel + 1 == levelCount-1) {
        winText = @"You will face the last\nand hardest challenge!";
    } else if (currentLevel + 1 == levelCount) {
        winText = @"Nooo! You made it.";
    }
    
    _levelWinText.string = [NSString stringWithFormat:@"%d out of %lu.\n%@", currentLevel+1, (unsigned long) levelCount, winText];
    
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

#pragma mark - Getter/Setter implementations

- (NSString *)nextLevelButtonText {
    return _nextLevelButton.title;
}

- (void)setNextLevelButtonText:(NSString *)nextLevelButtonText {
    _nextLevelButton.title = nextLevelButtonText;
}

@end
