//
//  CCActionFollowGGJ.h
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCAction.h"
#include <sys/time.h>
#import <Foundation/Foundation.h>

#import "ccTypes.h"

@class CCNode;

/**
 *  Creates an action which follows a node.
 *
 *  Note:
 *  In stead of using CCCamera to follow a node, use this action.
 *
 *  Example:
 *  [layer runAction: [CCFollow actionWithTarget:hero]];
 */
@interface CCActionFollowGGJ : CCAction <NSCopying> {
    
	// Node to follow.
	CCNode	*_followedNode;
    
	// Whether camera should be limited to certain area.
	BOOL _boundarySet;
    
	// If screen-size is bigger than the boundary - update not needed.
	BOOL _boundaryFullyCovered;
    
	// Fast access to the screen dimensions.
	CGPoint _halfScreenSize;
	CGPoint _fullScreenSize;
    
	// World boundaries.
	float _leftBoundary;
	float _rightBoundary;
	float _topBoundary;
	float _bottomBoundary;
}


/// -----------------------------------------------------------------------
/// @name Accessing the Follow Action Attributes
/// -----------------------------------------------------------------------

/** Turns boundary behaviour on / off.  If set to YES, movement will be clamped to boundaries. */
@property (nonatomic,readwrite) BOOL boundarySet;


/// -----------------------------------------------------------------------
/// @name Creating a CCActionFollow Object
/// -----------------------------------------------------------------------

/**
 *  Creates a follow action with no boundaries.
 *
 *  @param followedNode Node to follow.
 *
 *  @return The follow action object.
 */
+ (id)actionWithTarget:(CCNode *)followedNode;

/**
 *  Creates a follow action with boundaries.
 *
 *  @param followedNode Node to follow.
 *  @param rect         Boundary rect.
 *
 *  @return The follow action object.
 */
+ (id)actionWithTarget:(CCNode *)followedNode worldBoundary:(CGRect)rect;


/// -----------------------------------------------------------------------
/// @name Initializing a CCActionFollow Object
/// -----------------------------------------------------------------------

/**
 *  Initalizes a follow action with no boundaries.
 *
 *  @param followedNode Node to follow.
 *
 *  @return An initialized follow action object.
 */
- (id)initWithTarget:(CCNode *)followedNode;

/**
 *  Initalizes a follow action with boundaries.
 *
 *  @param followedNode Node to follow.
 *  @param rect         Boundary rect.
 *
 *  @return The initalized follow action object.
 */
- (id)initWithTarget:(CCNode *)followedNode worldBoundary:(CGRect)rect;

@end
