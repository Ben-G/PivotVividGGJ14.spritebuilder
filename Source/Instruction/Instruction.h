//
//  Instruction.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 27/07/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Instruction : CCNode

@property (nonatomic, readonly) NSString *instructionText;
@property (nonatomic, assign) NSRange instructionRange;

@end
