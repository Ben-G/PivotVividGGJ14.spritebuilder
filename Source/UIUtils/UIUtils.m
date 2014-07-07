//
//  UIUtils.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 06/07/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "UIUtils.h"
#import "GameState.h"

void presentGameplaySceneWithCurrentLevel() {
    NSDictionary *levelInfo = [[GameState sharedInstance] currentLevelInfo];
    
    if (levelInfo[@"isTutorial"] == [NSNumber numberWithBool:TRUE]) {
        CCScene *scene = [CCBReader loadAsScene:@"TutorialGameplay"];
        [[CCDirector sharedDirector] replaceScene:scene];
    } else {
        CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
        [[CCDirector sharedDirector] replaceScene:scene];
    }
}