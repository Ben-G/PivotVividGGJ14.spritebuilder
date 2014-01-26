//
//  Startscreen.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 26/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Startscreen.h"

@implementation Startscreen

- (void)startNow {
    CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)levelSelect {
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] pushScene:scene];
}

@end
