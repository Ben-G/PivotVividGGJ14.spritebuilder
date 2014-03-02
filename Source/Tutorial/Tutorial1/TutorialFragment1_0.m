//
//  TutorialFragment1_0.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 01/03/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TutorialFragment1_0.h"

@implementation TutorialFragment1_0

- (void)tutorialGameplayChangedMood:(TutorialGameplay *)tutorialGameplay {
    [tutorialGameplay nextTutorialStep];
}

@end
