//
//  GameEndLayer.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 02/08/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface GameEndLayer : CCNode

@property (nonatomic, strong) NSString *nextLevelButtonText;

- (void)displayCompletionRate:(CGFloat)completionRate;
- (void)displayHint:(NSString *)hint;

@end
