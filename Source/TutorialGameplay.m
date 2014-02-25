//
//  TutorialGameplay.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/02/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TutorialGameplay.h"

@implementation TutorialGameplay

- (void)didLoadFromCCB {
    [super didLoadFromCCB];
        
    [self.level removeAllChildren];
    
    CCNode *tutorialFragment1 = [CCBReader load:@"Tutorials/Tutorial1/Tutorial1_0"];
    [self.level addChild:tutorialFragment1];
    
    CCNode *tutorialFragment2 = [CCBReader load:@"Tutorials/Tutorial1/Tutorial1_0"];
    tutorialFragment2.position = ccp(tutorialFragment1.contentSize.width, 0);
    [self.level addChild:tutorialFragment2];
}

- (void)restartLevel {
    // reload level
    [super stopMusic];
    CCScene *scene = [CCBReader loadAsScene:@"TutorialGameplay"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
