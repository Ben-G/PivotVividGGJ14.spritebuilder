//
//  CCActionFollowGGJ.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCActionFollowGGJ.h"
#import "CCDirector.h"
#import "ccMacros.h"
#import "CCAction.h"
#import "CCActionInterval.h"
#import "Support/CGPointExtension.h"

@implementation CCActionFollowGGJ

@synthesize boundarySet = _boundarySet;

+(id) actionWithTarget:(CCNode *) fNode
{
	return [[self alloc] initWithTarget:fNode];
}

+(id) actionWithTarget:(CCNode *) fNode worldBoundary:(CGRect)rect
{
	return [[self alloc] initWithTarget:fNode worldBoundary:rect];
}

-(id) initWithTarget:(CCNode *)fNode
{
	if( (self=[super init]) ) {
        
		_followedNode = fNode;
		_boundarySet = FALSE;
		_boundaryFullyCovered = FALSE;
        
		CGSize s = [[CCDirector sharedDirector] viewSize];
		_fullScreenSize = CGPointMake(s.width, s.height);
		_halfScreenSize = ccpMult(_fullScreenSize, .2f);
	}
    
	return self;
}

-(id) initWithTarget:(CCNode *)fNode worldBoundary:(CGRect)rect
{
	if( (self=[super init]) ) {
        
		_followedNode = fNode;
		_boundarySet = TRUE;
		_boundaryFullyCovered = FALSE;
        
		CGSize winSize = [[CCDirector sharedDirector] viewSize];
		_fullScreenSize = CGPointMake(winSize.width, winSize.height);
		_halfScreenSize = ccpMult(_fullScreenSize, .2f);
        
		_leftBoundary = -((rect.origin.x+rect.size.width) - _fullScreenSize.x);
		_rightBoundary = -rect.origin.x ;
		_topBoundary = -rect.origin.y;
		_bottomBoundary = -((rect.origin.y+rect.size.height) - _fullScreenSize.y);
        
		if(_rightBoundary < _leftBoundary)
		{
			// screen width is larger than world's boundary width
			//set both in the middle of the world
			_rightBoundary = _leftBoundary = (_leftBoundary + _rightBoundary) / 2;
		}
		if(_topBoundary < _bottomBoundary)
		{
			// screen width is larger than world's boundary width
			//set both in the middle of the world
			_topBoundary = _bottomBoundary = (_topBoundary + _bottomBoundary) / 2;
		}
        
		if( (_topBoundary == _bottomBoundary) && (_leftBoundary == _rightBoundary) )
			_boundaryFullyCovered = TRUE;
	}
    
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] init];
	copy.tag = _tag;
	return copy;
}

-(void) step:(CCTime) dt
{
	if(_boundarySet)
	{
		// whole map fits inside a single screen, no need to modify the position - unless map boundaries are increased
		if(_boundaryFullyCovered)
			return;
        
		CGPoint tempPos = ccpSub( _halfScreenSize, _followedNode.position);
		[(CCNode*)_target setPosition:ccp(clampf(tempPos.x, _leftBoundary, _rightBoundary), clampf(tempPos.y, _bottomBoundary, _topBoundary))];
	}
	else
		[(CCNode*)_target setPosition:ccpSub( _halfScreenSize, _followedNode.position )];
}


-(BOOL) isDone
{
	return !_followedNode.runningInActiveScene;
}

-(void) stop
{
	_target = nil;
	[super stop];
}

@end
