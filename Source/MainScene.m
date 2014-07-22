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

static const NSInteger GRID_WIDTH = 4;
static const NSInteger VERTICAL_MARGIN = 12;


@implementation MainScene {
    NSArray *_nodes;
    int _onScreen;
    int _selectedLevel;
    NSArray *_levels;
    
    CGSize _screenSize;
    
    CCScrollView *_scrollView;
}

- (void)didLoadFromCCB {
    _screenSize = [[CCDirector sharedDirector] viewSize];
    
    _selectedLevel = 0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"];
    _levels = [NSArray arrayWithContentsOfFile:path];
    
    CCNode *contentNode = [CCNode node];
    contentNode.anchorPoint = ccp(0,0);
    contentNode.position = ccp(0,0);
    _scrollView.contentNode = contentNode;
    _scrollView.horizontalScrollEnabled = NO;
    
    self.userInteractionEnabled = TRUE;
}

- (void)onEnter {
    [super onEnter];
    
    int elementsPerRow = 4;
    int amountOfRows = (int) [_levels count] / elementsPerRow;
    
    if (([_levels count] % elementsPerRow) > 0) {
        amountOfRows++;
    }
    
    CCNode *tile = [CCBReader load:@"LevelTile"];
    CGFloat columnWidth = tile.contentSizeInPoints.width;
    CGFloat columnHeight = tile.contentSizeInPoints.height;
    
    // this hotfix is needed because of issue #638 in Cocos2D 3.1 / SB 1.1 (https://github.com/spritebuilder/SpriteBuilder/issues/638)
    [tile performSelector:@selector(cleanup)];
    
    // calculate the margin by subtracting the tile sizes from the grid size
    CGFloat tileMarginHorizontal = (self.contentSizeInPoints.width - (GRID_WIDTH * columnWidth)) / (GRID_WIDTH+1);
    CGFloat tileMarginVertical = VERTICAL_MARGIN;
    
    CGFloat x = tileMarginHorizontal;
    CGFloat y = tileMarginVertical;
    
    for (int row = 0; row < amountOfRows; row++) {
        x = tileMarginHorizontal;
        
        for (int column = 0; column < elementsPerRow; column++) {
            CCNode *levelTile = [CCBReader load:@"LevelTile"];
            levelTile.positionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitPoints, CCPositionReferenceCornerTopLeft);
            levelTile.position = ccp(x, y);
            [_scrollView.contentNode addChild:levelTile];
            
            x += columnWidth + tileMarginHorizontal;
        }
        
        y += columnHeight + tileMarginVertical;
    }
    
    _scrollView.contentNode.contentSize = CGSizeMake(self.contentSizeInPoints.width, y + columnHeight);
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
    otherNode.position = ccp(-_screenSize.width, 0);
    
    
    CCActionMoveTo *moveBy = [CCActionMoveTo actionWithDuration:0.25f position:ccp(0, 0)];
    [otherNode runAction:moveBy];
    
    CCActionMoveTo *moveRight = [CCActionMoveTo actionWithDuration:0.25f position:ccp(+_screenSize.width, 0)];
    [currentNode runAction:moveRight];
    
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
    otherNode.position = ccp(_screenSize.width, 0);
    
    CCActionMoveTo *moveBy = [CCActionMoveTo actionWithDuration:0.25f position:ccp(0, 0)];
    [otherNode runAction:moveBy];
    
    CCActionMoveTo *moveLeft = [CCActionMoveTo actionWithDuration:0.25f position:ccp(-_screenSize.width, 0)];
    [currentNode runAction:moveLeft];

    
    _onScreen = other;
    
    [self performSelector:@selector(reactivateInteraction) withObject:nil afterDelay:0.25f];
}

- (void)startButtonPressed {
    self.userInteractionEnabled = FALSE;
    
    NSDictionary *levelInfo = _levels[_selectedLevel];
    [[GameState sharedInstance] setCurrentLevel:levelInfo[@"levelName"]];
    [[GameState sharedInstance] setCurrentLevelIndex:_selectedLevel];

    if (levelInfo[@"isTutorial"] == [NSNumber numberWithBool:TRUE]) {
        CCScene *scene = [CCBReader loadAsScene:@"TutorialGameplay"];
        [[CCDirector sharedDirector] replaceScene:scene];
    } else {
        CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
        [[CCDirector sharedDirector] replaceScene:scene];
    }
}

- (void)backButtonPressed {
    CCScene *scene = [CCBReader loadAsScene:@"Startscreen"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
