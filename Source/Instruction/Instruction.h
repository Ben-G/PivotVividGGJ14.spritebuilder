//
//  Instruction.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 27/07/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

typedef NS_ENUM(NSInteger, InstructionType) {
    InstructionTypeSwitch,
    InstructionTypeJump
};

@interface Instruction : CCNode

@property (nonatomic, readonly) NSString *instructionText;
@property (nonatomic, assign) NSRange instructionRange;
@property (nonatomic, assign) InstructionType instructionType;

- (BOOL)jumped;
- (BOOL)switched;

@end
