//
//  GameState.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 26/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameState.h"

@implementation GameState {
    NSArray *_levels;
}

+ (id)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (id)init {
    self = [super init];
    
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"];
        _levels = [NSArray arrayWithContentsOfFile:path];
    }
    
    return self;
}

- (NSDictionary *)nextLevelInfo {
    NSDictionary *nextLevel = _levels[self.currentLevelIndex+1];
    
    return nextLevel;
}

- (void)loadNextLevel {
    NSDictionary *nextLevel = _levels[self.currentLevelIndex+1];
    self.currentLevel = nextLevel[@"levelName"];
    self.currentLevelIndex = self.currentLevelIndex + 1;
}

@end
