//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "CCAnimatedSprite.h"
#import "LevelDetails.h"
#import "GameState.h"

@implementation MainScene {
    NSArray *_nodes;
    int _onScreen;
    int _selectedLevel;
    NSArray *_levels;
    
    CGSize _screenSize;
}

- (void)didLoadFromCCB {
    _screenSize = [[CCDirector sharedDirector] viewSize];
    
    _selectedLevel = 0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"];
    _levels = [NSArray arrayWithContentsOfFile:path];
    
    _onScreen = 1;
    
    LevelDetails *node1 = (LevelDetails*) [CCBReader load:@"LevelDetails"];
    node1.anchorPoint = ccp(0,0);
    node1.position = ccp(0, 0);
    
    LevelDetails *node2 = (LevelDetails*) [CCBReader load:@"LevelDetails"];
    node2.anchorPoint = ccp(0, 0);
    [node2 setLevel:_levels[0]];
    
    [self addChild:node1 z:INT_MIN];
    [self addChild:node2 z:INT_MIN];
    
    _nodes = @[node1, node2];
    
    self.userInteractionEnabled = TRUE;
}


- (void)prev {
    if (!self.userInteractionEnabled) {
        return;
    }
    
    _selectedLevel --;
    if (_selectedLevel < 0) {
        _selectedLevel = [_levels count]-1;
    }
    
    // slide to left, place other node right
    int other = (_onScreen + 1) % 2;
    CCNode *currentNode = _nodes[_onScreen];
    LevelDetails *otherNode = _nodes[other];
    [otherNode setLevel:_levels[_selectedLevel]];
    otherNode.position = ccp(_screenSize.width, 0);
    
    
    CCActionMoveTo *moveBy = [CCActionMoveTo actionWithDuration:0.25f position:ccp(0, 0)];
    [otherNode runAction:moveBy];
    
    CCActionMoveTo *moveLeft = [CCActionMoveTo actionWithDuration:0.25f position:ccp(-_screenSize.width, 0)];
    [currentNode runAction:moveLeft];
    
    _onScreen = other;
    
    [self performSelector:@selector(reactivateInteraction) withObject:nil afterDelay:0.25f];
}

- (void)reactivateInteraction {
    self.userInteractionEnabled = TRUE;
}

- (void)next {
    if (!self.userInteractionEnabled) {
        return;
    }
    
    _selectedLevel ++;
    if (_selectedLevel >= [_levels count]) {
        _selectedLevel = 0;
    }
    
    self.userInteractionEnabled = FALSE;
    
    // slide to left, place other node right
    int other = (_onScreen + 1) % 2;
    CCNode *currentNode = _nodes[_onScreen];
    
    LevelDetails *otherNode = _nodes[other];
    [otherNode setLevel:_levels[_selectedLevel]];
    otherNode.position = ccp(-_screenSize.width, 0);
    
    
    CCActionMoveTo *moveBy = [CCActionMoveTo actionWithDuration:0.25f position:ccp(0, 0)];
    [otherNode runAction:moveBy];
    
    CCActionMoveTo *moveRight = [CCActionMoveTo actionWithDuration:0.25f position:ccp(+_screenSize.width, 0)];
    [currentNode runAction:moveRight];
    
    _onScreen = other;
    
    [self performSelector:@selector(reactivateInteraction) withObject:nil afterDelay:0.25f];
}

- (void)startButtonPressed {
    self.userInteractionEnabled = FALSE;
    
    NSDictionary *levelInfo = _levels[_selectedLevel];
    [[GameState sharedInstance] setCurrentLevel:levelInfo[@"levelName"]];

    CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
