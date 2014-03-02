//
//  TutorialGameplay.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/02/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@class TutorialGameplay;

@protocol TutorialGameplayDelegate <NSObject>

@optional

- (void)tutorialGameplayChangedMood:(TutorialGameplay *)tutorialGameplay;
- (void)tutorialGameplayJumped:(TutorialGameplay *)tutorialGameplay;
- (void)tutorialGameplayCompletedFragment:(TutorialGameplay *)tutorialGameplay;

@end


@interface TutorialGameplay : Gameplay

@property (nonatomic, weak) id<TutorialGameplayDelegate> delegate;

- (void)nextTutorialStep;

@end
