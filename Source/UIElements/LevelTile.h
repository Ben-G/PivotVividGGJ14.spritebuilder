//
//  LevelTile.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 21/07/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface LevelTile : CCNode

@property CCLabelTTF *levelNumber;
@property NSInteger levelIndex;
@property (nonatomic) BOOL locked;

@property (nonatomic, copy) void (^levelSelectionBlock)();

@end
