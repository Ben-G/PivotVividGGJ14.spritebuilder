//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "CCAnimatedSprite.h"

@implementation MainScene {
    NSArray *_nodes;
    int _onScreen;
}

- (void)didLoadFromCCB {
    _onScreen = 1;
    
    CCNodeColor *node1 = [CCNodeColor nodeWithColor:[CCColor redColor]];
    node1.anchorPoint = ccp(0,0);
    node1.position = ccp(0, 0);
    
    CCNodeColor *node2 = [CCNodeColor nodeWithColor:[CCColor greenColor]];
    node2.anchorPoint = ccp(0, 0);
    
    [self addChild:node1 z:INT_MIN];
    [self addChild:node2 z:INT_MIN];
    
    _nodes = @[node1, node2];
    
    self.userInteractionEnabled = TRUE;
}


- (void)prev {
    if (!self.userInteractionEnabled) {
        return;
    }
    
    // slide to left, place other node right
    int other = (_onScreen + 1) % 2;
    CCNode *currentNode = _nodes[_onScreen];
    CCNode *otherNode = _nodes[other];
    otherNode.position = ccp(otherNode.contentSize.width, 0);    
    
    
    CCActionMoveTo *moveBy = [CCActionMoveTo actionWithDuration:0.25f position:ccp(0, 0)];
    [otherNode runAction:moveBy];
    
    CCActionMoveTo *moveLeft = [CCActionMoveTo actionWithDuration:0.25f position:ccp(-currentNode.contentSize.width, 0)];
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
    
    self.userInteractionEnabled = FALSE;
    
    // slide to left, place other node right
    int other = (_onScreen + 1) % 2;
    CCNode *currentNode = _nodes[_onScreen];
    CCNode *otherNode = _nodes[other];
    otherNode.position = ccp(-otherNode.contentSize.width, 0);
    
    CCActionMoveTo *moveBy = [CCActionMoveTo actionWithDuration:0.25f position:ccp(0, 0)];
    [otherNode runAction:moveBy];
    
    CCActionMoveTo *moveRight = [CCActionMoveTo actionWithDuration:0.25f position:ccp(+currentNode.contentSize.width, 0)];
    [currentNode runAction:moveRight];
    
    _onScreen = other;
    
    [self performSelector:@selector(reactivateInteraction) withObject:nil afterDelay:0.25f];
}

- (void)startButtonPressed {
    self.userInteractionEnabled = FALSE;

    CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

@end
