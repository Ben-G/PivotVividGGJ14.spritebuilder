//
//  TutorialGameplay.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/02/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TutorialGameplay.h"

@implementation TutorialGameplay {
    NSArray *_tutorialFragments;
}

- (void)didLoadFromCCB {
    [super didLoadFromCCB];
        
    [self.level removeAllChildren];
    
    CCNode *tutorialFragment1 = [CCBReader load:@"Tutorials/Tutorial1/Tutorial1_0"];
    [self.level addChild:tutorialFragment1];
    
    CCNode *tutorialFragment2 = [CCBReader load:@"Tutorials/Tutorial1/Tutorial1_0"];
    tutorialFragment2.position = ccp(tutorialFragment1.contentSize.width, 0);
    [self.level addChild:tutorialFragment2];
    
    _tutorialFragments = @[tutorialFragment1, tutorialFragment2];
    
    [super findBlocks:self.level];
}

- (void)restartLevel {
    // reload level
    [super stopMusic];
    CCScene *scene = [CCBReader loadAsScene:@"TutorialGameplay"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)update:(CCTime)delta {
    [super update:delta];
    
    // loop tutorial fragments
    for (int i = 0; i < [_tutorialFragments count]; i++) {
        CCNode *fragment = _tutorialFragments[i];
        
        // get the world position of the fragment
        CGPoint fragmentWorldPosition = [self.level convertToWorldSpace:fragment.position];
        // get the screen position of the fragment
        CGPoint fragmentScreenPosition = [self convertToNodeSpace:fragmentWorldPosition];
        
        // if the left corner is one complete width off the screen, move it to the right
        if (fragmentScreenPosition.x <= (-1 * fragment.contentSize.width)) {
            // workaround for compound static physics objects not beeing movable
            CCNode *parent = fragment.parent;
            [fragment removeFromParent];
            fragment.position = ccp(fragment.position.x + 2 * fragment.contentSize.width, fragment.position.y);
            [parent addChild:fragment];
        }
    }
}

@end
