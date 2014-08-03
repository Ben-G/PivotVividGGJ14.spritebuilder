//
//  GameEndLayer.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 02/08/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameEndLayer.h"

@implementation GameEndLayer {
    CCNodeColor *_progressBar;
    CCLabelTTF *_hintLabel;
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
