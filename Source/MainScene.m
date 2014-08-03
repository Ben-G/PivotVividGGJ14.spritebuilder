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
#import "LevelTile.h"

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
            LevelTile *levelTile = (LevelTile *) [CCBReader load:@"LevelTile"];
            levelTile.positionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitPoints, CCPositionReferenceCornerTopLeft);
            levelTile.position = ccp(x, y);
            [_scrollView.contentNode addChild:levelTile];
            
            x += columnWidth + tileMarginHorizontal;
        
            int selectedLevel = row * elementsPerRow + column;
            // check if level is unlocked:
            NSString *levelString = [NSString stringWithFormat:@"Level_%d_unlocked", selectedLevel];
            BOOL levelUnlocked = [[NSUserDefaults standardUserDefaults] boolForKey:levelString];
            levelTile.levelNumber.string = [NSString stringWithFormat:@"%d", selectedLevel+1];
            levelTile.levelIndex = selectedLevel;
            levelTile.locked = !levelUnlocked;
            
            __weak LevelTile *weakLevelTile = levelTile;
            
            levelTile.levelSelectionBlock = ^{
                [self selectedLevel:weakLevelTile.levelIndex];
            };
            
            if (row * elementsPerRow + column == [_levels count]-1) {
                break;
            }
        }
        
        y += columnHeight + tileMarginVertical;
    }
    
    _scrollView.contentNode.contentSize = CGSizeMake(self.contentSizeInPoints.width, y + columnHeight);
}

- (void)selectedLevel:(NSInteger)levelIndex {    
    [[GameState sharedInstance] loadLevel:levelIndex];
    NSDictionary *levelInfo = [[GameState sharedInstance] currentLevelInfo];
    
    if (levelInfo[@"isTutorial"] == [NSNumber numberWithBool:TRUE]) {
        CCScene *scene = [CCBReader loadAsScene:@"TutorialGameplay"];
        [[CCDirector sharedDirector] replaceScene:scene];
    } else {
        CCNode *loadingScreen = [CCBReader load:@"UI/LoadingScreen"];
        [self addChild:loadingScreen];
        [self performSelector:@selector(actualLoadLevel) withObject:nil afterDelay:0.1f];
    }
}

- (void)actualLoadLevel {
    CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)reactivateInteraction {
    self.userInteractionEnabled = TRUE;
}

- (void)backButtonPressed {
    CCScene *scene = [CCBReader loadAsScene:@"Startscreen"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
