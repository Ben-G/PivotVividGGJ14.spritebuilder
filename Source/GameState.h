//
//  GameState.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 26/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject

@property (nonatomic, readonly) NSString *currentLevel;
@property (nonatomic, readonly) int currentLevelIndex;
@property (nonatomic) int currentLevelAttempts;

+ (instancetype)sharedInstance;
- (NSDictionary *)nextLevelInfo;
- (NSDictionary *)currentLevelInfo;
- (void)loadNextLevel;
- (void)loadLevel:(NSInteger)levelIndex;

@end
