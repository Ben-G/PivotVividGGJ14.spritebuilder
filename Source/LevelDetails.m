//
//  LevelDetails.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 26/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelDetails.h"

@implementation LevelDetails {
    CCLabelTTF *_titleLabel;
}

- (void)setLevel:(NSDictionary*)levelDescription {
    _titleLabel.string = levelDescription[@"levelTitle"];
}

@end
