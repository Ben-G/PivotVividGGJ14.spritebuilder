//
//  Instruction.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 27/07/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Instruction.h"

@implementation Instruction {
    CCLabelTTF *_instructionLabel;
}

- (void)didLoadFromCCB {
    self.visible = NO;
    self.instructionRange = NSMakeRange(CGRectGetMinX(self.boundingBox), CGRectGetWidth(self.boundingBox));
    _instructionText = _instructionLabel.string;
}

@end
