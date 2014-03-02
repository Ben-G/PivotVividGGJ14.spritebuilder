//
//  TutorialFragment.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 01/03/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "TutorialGameplay.h"

@interface TutorialFragment : CCNode <TutorialGameplayDelegate>

@property (nonatomic, strong) NSString *instruction;

@end
