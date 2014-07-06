//
//  TutorialGameplay.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/02/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TutorialGameplay.h"
#import "TutorialFragment.h"
#import "Level.h"
#import "GameState.h"
#import "TutorialInstructionPopup.h"
#import "Hero.h"

// TODO: this can only be used for prototype
static int _currentFragmentIndex;

@implementation TutorialGameplay {
    NSMutableArray *_tutorialFragments;
    CCLabelTTF *_instructionLabel;
    NSString *_tutorialName;
    NSArray *_fragmentNames;
    BOOL _newFragmentLoaded;
    UITouch *_resumeTouch;
    CCNode *_instructionBox;
    TutorialInstructionPopup *_tutorialInstructionPopup;
    
    CCNode *_startPositionNode;
    
    NSString *_lastInstruction;
}

- (void)didLoadFromCCB {
    self.level = [[Level alloc] init];
    self.level.levelSpeed = 200.f;
    [super didLoadFromCCB];

    /* Load the last active tutorial step. If a player doesn't pass a tutorial step he will have to repeat it*/
    NSDictionary *tutorialInfo = [[GameState sharedInstance] currentLevelInfo];
    _tutorialName = tutorialInfo[@"levelName"];
    _fragmentNames = tutorialInfo[@"tutorialFragments"];
    
    _tutorialInstructionPopup = (TutorialInstructionPopup *)[CCBReader load:@"TutorialInstructionPopup"];
    _tutorialInstructionPopup.visible = FALSE;
    [self addChild:_tutorialInstructionPopup];
    _tutorialInstructionPopup.positionType = CCPositionTypeNormalized;
    _tutorialInstructionPopup.position = ccp(0.5f, 0.5f);

    [self restoreCurrentTutorialFragment];
}

#pragma mark - Load Tutorial Fragement

- (NSString *)currentFragmentCCBName {
    NSString *currentFragmentName = _fragmentNames[_currentFragmentIndex];
    NSString *fragmentCCBFile = [NSString stringWithFormat:@"Tutorials/%@/%@", _tutorialName, currentFragmentName];
    
    return fragmentCCBFile;
}

- (void)restoreCurrentTutorialFragment {
    NSString *fragmentCCBFile = [self currentFragmentCCBName];
    
    // add a little blank level before the tutorial fragment so player can prepare
    CCNode *tutorialPreplay = [CCBReader load:@"Fragments/Tutorial_blank" owner:self];
    [self.level addChild:tutorialPreplay];
    
    self.hero.position = _startPositionNode.position;
    
    //TODO: instead of looping fragment twice add blank space afterwards?
    TutorialFragment *tutorialFragment1 = (TutorialFragment *) [CCBReader load:fragmentCCBFile];
    tutorialFragment1.position = ccp(tutorialPreplay.contentSize.width, 0);
    [self.level addChild:tutorialFragment1];
    self.delegate = tutorialFragment1;
    
    TutorialFragment *tutorialFragment2 = (TutorialFragment *) [CCBReader load:fragmentCCBFile];
    tutorialFragment2.position = ccp(tutorialFragment1.position.x + tutorialFragment1.contentSize.width, 0);
    [self.level addChild:tutorialFragment2];
    
    _tutorialFragments = [@[tutorialFragment1, tutorialFragment2] mutableCopy];
    
    
    // update instruction
    _instructionLabel.string = NSLocalizedString(tutorialFragment1.instruction, nil);
    _instructionBox.visible = FALSE;
    
    _tutorialInstructionPopup.instructionLabel.string = NSLocalizedString(tutorialFragment1.instruction, nil);
    _tutorialInstructionPopup.visible = TRUE;
    self.contentNode.paused = TRUE;
    
    /* since we dynamically loaded new blocks to the world we need to call findBlocks again to collect these new blocks.
     The game needs to know about all blocks to be able to apply moods, etc. */
    [super findBlocks:self.level];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.contentNode.paused) {
        self.contentNode.paused = FALSE;
        _instructionBox.visible = TRUE;
        _tutorialInstructionPopup.visible = FALSE;
        _resumeTouch = touch;
    } else {
        [super touchBegan:touch withEvent:event];
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (touch == _resumeTouch) {
        _resumeTouch = nil;
    } else {
        [super touchEnded:touch withEvent:event];
    }
}

#pragma mark - Next Tutorial Step

- (void)nextTutorialStep {
    if ((_currentFragmentIndex+1) < [_fragmentNames count]) {
        _currentFragmentIndex++;
        _newFragmentLoaded = FALSE;
    }
    _instructionLabel.string = @"Well done!";
}

- (void)activateNextTutorialStep:(TutorialFragment *)fragment {
    _instructionLabel.string = NSLocalizedString(fragment.instruction, nil);
    _instructionBox.visible = FALSE;
    _tutorialInstructionPopup.instructionLabel.string = NSLocalizedString(fragment.instruction, nil);
    _tutorialInstructionPopup.visible = TRUE;
    self.contentNode.paused = TRUE;
}

- (void)winTutorial {
    [super winGame];
}

#pragma mark - Inform Delegate

- (void)jump {
    [super jump];
    
    if ([self.delegate respondsToSelector:@selector(tutorialGameplayJumped:)]) {
        [self.delegate tutorialGameplayJumped:self];
    }
}

- (void)switchMood {
    [super switchMood];
    
    if ([self.delegate respondsToSelector:@selector(tutorialGameplayChangedMood:)]) {
        [self.delegate tutorialGameplayChangedMood:self];
    }
}

#pragma mark - Overriden Gameplay Methods

- (void)endGame {
    [self restartLevel];
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
        TutorialFragment *fragment = _tutorialFragments[i];
        
        // get the world position of the fragment
        CGPoint fragmentWorldPosition = [self.level convertToWorldSpace:fragment.position];
        // get the screen position of the fragment
        CGPoint fragmentScreenPosition = [self convertToNodeSpace:fragmentWorldPosition];
        
        // if the left corner is one complete width off the screen, move it to the right
        if (fragmentScreenPosition.x <= (-1 * fragment.contentSize.width)) {
            // workaround for compound static physics objects not beeing movable
            CCNode *parent = fragment.parent;
            CGPoint fragmentPosition = fragment.position;
            [fragment removeFromParent];
            
            if ([fragment respondsToSelector:@selector(tutorialGameplayCompletedFragment:)]) {
                [fragment tutorialGameplayCompletedFragment:self];
            }
            
            TutorialFragment *otherFragment = (i == 0) ? _tutorialFragments[1] : _tutorialFragments[0];
            if (!_newFragmentLoaded) {
                fragment = _tutorialFragments[i] = (TutorialFragment *) [CCBReader load:[self currentFragmentCCBName]];
                _newFragmentLoaded = TRUE;
//                _instructionLabel.string = NSLocalizedString(fragment.instruction, nil);
                
                if (![_instructionLabel.string isEqualToString:NSLocalizedString(fragment.instruction, nil)]) {
                    // update instruction
                    [self activateNextTutorialStep:fragment];
                }
                
                self.delegate = fragment;
            } else if (![_instructionLabel.string isEqualToString:NSLocalizedString(fragment.instruction, nil)]) {
                fragment = _tutorialFragments[i] = [CCBReader load:@"Fragments/Tutorial_blank"];
            }
            fragment.position = ccp(otherFragment.position.x + otherFragment.contentSize.width, fragmentPosition.y);
            [parent addChild:fragment];
            
#pragma message "Use smarter solution in future"
            [super removeAllBlocks];
            [super findBlocks:self.level];
        }
    }
}




@end
