//
//  Gameplay.m
//  PivotVividGGJ14
//
//  Created by Benjamin Encz on 24/01/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "CCActionFollowGGJ.h"
#import "GroundBlock.h"
#import "Mood.h"
#import "BasicEnemy.h"
#import "Mask.h"
#import "Hero.h"
#import "Block.h"
#import "GameState.h"
#import "Level.h"

@implementation Gameplay {
    CCNode *_contentNode;
    CCNode *_progressBar;
    CCPhysicsNode *_physicsNode;
    Level *_level;
    Hero *_hero;
    
    int updates;
    
    // array of masks the player has; masks are required for mood changes
    NSMutableArray *_masks;
        
    // current mood
    int _currentMoodIndex;
    
    // array of all blocks
    NSMutableArray *_blocks;
    
    // array of all moods
    NSArray *_moods;
    
    // position of touch start (recorded in touchBegan)
    CGPoint _touchStartPosition;
    
    // stores three version of the scrolling background (to allow endless scrolling)
    NSArray *_backgrounds;
    
    // determines the goal position of this level, when this is reached it is consisdered a win!
    int levelGoal;
    
    // the position of the player on the screen
    int playerPositionX;
    
    BOOL _gameOver;
    
    CCButton *_nextLevelButton;
    CCButton *_levelSelectionButton;
    
    CGFloat _baseSpeed;
    int _initialMasks;
}

// distance between masks
static const CGPoint DISTANCE_PER_MASK = {-25.f,0.f};

// amount of initial masks
// static const int RAMP = 1;

static const int JUMP_IMPULSE = 100000;

#pragma mark - Init

- (void)didLoadFromCCB {
    _physicsNode.sleepTimeThreshold = 10.f;
    
    _progressBar.opacity = 0.f;
    
    // load initial background
    NSString *spriteFrameName = @"art/sad_background.png";
    CCSpriteFrame* spriteFrame = [CCSpriteFrame frameWithImageNamed:spriteFrameName];

    // position backgrounds
    CCSprite *bg1 = [CCSprite spriteWithSpriteFrame:spriteFrame];
    CCSprite *bg2 = [CCSprite spriteWithSpriteFrame:spriteFrame];
    CCSprite *bg3 = [CCSprite spriteWithSpriteFrame:spriteFrame];
    bg1.anchorPoint = ccp(0, 0);
    bg1.position = ccp(0, 0);
    bg2.anchorPoint = ccp(0, 0);
    bg2.position = ccp(bg1.contentSize.width-1, 0);
    bg3.anchorPoint = ccp(0, 0);
    bg3.position = ccp(2*bg1.contentSize.width-1, 0);
    _backgrounds = @[bg1, bg2, bg3];
    
    [self addChild:bg1 z:INT_MIN];
    [self addChild:bg2 z:INT_MIN];
    [self addChild:bg3 z:INT_MIN];
    
    _currentMoodIndex = 0;
    
    // load first level
    NSString *levelName = [[GameState sharedInstance] currentLevel];
    _level = (Level*) [CCBReader load:levelName];
    
    _hero.position = _level.startPosition;
    
    // read custom level properties
    _initialMasks = _level.initialMasks;
    _baseSpeed = _level.levelSpeed;
    
    // determines how the camera shall follow the player (where in the camera image the hero will be positioned)
    playerPositionX = 150;
    _hero.position = ccp(playerPositionX, _hero.position.y);
    
    levelGoal = _level.contentSize.width - 300;
    
    // collition type for hero
    _hero.physicsBody.allowsRotation = FALSE;
    _hero.physicsBody.collisionType = @"hero";
    _hero.speed = _baseSpeed;
    
    // load level into physics node, setup ourselves as physics delegate
    [_physicsNode addChild:_level];
    _physicsNode.collisionDelegate = self;
    
    // setup a camera to follow the hero
//    CCActionFollowGGJ *followHero = [CCActionFollowGGJ actionWithTarget:_hero worldBoundary:_level.boundingBox];
//    [_contentNode runAction:followHero];
    
    // activate user interaction to grab touches
    self.userInteractionEnabled = TRUE;
    
    
    // collect all blocks in blocks array
    _blocks = [NSMutableArray array];
    
    [self findBlocks:_level];
    
    _masks = [NSMutableArray array];
    
    // setup all moods
    Mood *happy = [[Mood alloc] init];
    happy.moodPrefix = @"happy";
    happy.moodColor = [CCColor purpleColor];
    
    Mood *angry = [[Mood alloc] init];
    angry.moodPrefix = @"angry";
    angry.moodColor = [CCColor redColor];
    
    Mood *calm = [[Mood alloc] init];
    calm.moodPrefix = @"calm";
    calm.moodColor = [CCColor blueColor];
    
    Mood *fear = [[Mood alloc] init];
    fear.moodPrefix = @"fear";
    fear.moodColor = [CCColor yellowColor];
    
    _moods = @[happy, angry, calm, fear];
        
    // initialize mood & mask
    [self setMood:_currentMoodIndex];
    
    for (int i = 0; i < _initialMasks; i++) {
        [self addMaskAtPosition:_hero.position];
    }
    
    _hero.physicsBody.velocity = ccp(_baseSpeed,  _hero.physicsBody.velocity.y);
}

- (void)addMaskAtPosition:(CGPoint)pos {
    Mood *moodForMask = nil;
    
    if ([_masks count] == 0) {
        moodForMask = _moods[_currentMoodIndex+1];
    } else {
        Mask *lastMask = [_masks lastObject];
        Mood *lastMaskMood = lastMask.mood;
        int lastMaskMoodIndex = [_moods indexOfObject:lastMaskMood];
        
        moodForMask = _moods[lastMaskMoodIndex+1];
    }
    
    
    Mask *mask = (Mask*)[CCBReader load:@"Mask"];
    mask.mood = moodForMask;
    mask.position = pos;
    [_level addChild:mask];
    [_masks addObject:mask];
}

- (void)findBlocks:(CCNode *)node {
    node.cascadeOpacityEnabled = TRUE;
    
    for (int i = 0; i < node.children.count; i++) {
        CCNode *child = node.children[i];
        
        if ([child children] > 0) {
            [self findBlocks:(CCNode *)child];
        } else if ([child isKindOfClass:[Block class]]) {
            [_blocks addObject:child];
        }
    }
}

#pragma mark - Update

- (void)update:(CCTime)delta {
    
    if (_gameOver) {
        return;
    }
    
    // GJ hack, to forbid rotation
    _hero.physicsBody.angularVelocity = 0.f;
    _hero.rotation = 0.f;
    
    CGPoint heroWorldPos = [_physicsNode convertToWorldSpace:_hero.position];
    CGPoint heroOnScreen = [self convertToNodeSpace:heroWorldPos];
    
    if (heroOnScreen.x < 0) {
        [self endGame];
    }
    
    if (_hero.position.x >= levelGoal) {
        //[self winGame];
    }
    
    _progressBar.scaleX = (_hero.position.x / (levelGoal  * 1.f));
    
    // scroll left
    if (heroOnScreen.x >= (playerPositionX*1.05f)) {
        _contentNode.position = ccp(_contentNode.position.x - _baseSpeed *delta*1.1f, _contentNode.position.y);
    } else if (heroOnScreen.x < (playerPositionX*0.95f)) {
        _contentNode.position = ccp(_contentNode.position.x - _baseSpeed*delta*0.9f, _contentNode.position.y);
    } else {
        _contentNode.position = ccp(_contentNode.position.x - _baseSpeed*delta, _contentNode.position.y);
    }
    
    if ((_hero.boundingBox.origin.y + _hero.boundingBox.size.height) < 0) {
        // when the hero falls -> game over
        [self endGame];
    }
    
    // add SPEED to position
//    _hero.physicsBody.velocity = ccp(_baseSpeed,  _hero.physicsBody.velocity.y);
    
    if (_hero.physicsBody.velocity.x < _baseSpeed) {
        [_hero.physicsBody applyForce:ccp(10000.f, _hero.physicsBody.force.y)];
    }
    
    // make masks follow the player
    CGPoint previous = ccp(_hero.previousPosition.x, _hero.previousPosition.y-8);
    for (int i = 0; i < [_masks count]; i++) {
        Mask *mask = _masks[i];
        CGPoint temp = mask.position;
        mask.position = ccp(_hero.position.x - (DISTANCE_PER_MASK.x * -(i+2)), previous.y);
        previous = temp;
    }
    _hero.previousPosition = _hero.position;

    // endless scrolling for backgrounds
    for (CCSprite *bg in _backgrounds) {
        bg.position = ccp(bg.position.x - 50 * delta, bg.position.y);
        if (bg.position.x < -1 * (bg.contentSize.width)) {
            bg.position = ccp(bg.position.x + (bg.contentSize.width*2)-2, 0);
        }
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (_gameOver) {
        return;
    }
    
    _touchStartPosition = [touch locationInNode:self];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (_gameOver) {
        return;
    }
    
    CGPoint currentPos = [touch locationInNode:self];
    CGFloat distance = ccpDistance(currentPos, _touchStartPosition);
    
    if (distance > 30.f) {
        [self switchMood];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(jump) object:nil];
    }
    else {
        [self jump];
    }
}

- (void)removeOneMask {
    Mask *firstMask = [_masks lastObject];
    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:3.f position:ccp(600, 800)];
    CCActionCallBlock *removeFromParent = [CCActionCallBlock actionWithBlock:^{
        [firstMask removeFromParent];
    }];
    
    CCActionEaseBounceOut *bounceOut = [CCActionEaseBounceOut actionWithAction:moveBy];
    CCActionSequence *sequence = [CCActionSequence actions:bounceOut, removeFromParent, nil];
    
    [firstMask runAction:sequence];
    [_masks removeObject:firstMask];
}

- (void)stopMusic {
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio stopAllEffects];
}

- (void)setMood:(int)newMoodIndex {
    Mood *newMood = _moods[_currentMoodIndex];
    
    // play new song for this mood
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio stopAllEffects];
    NSString *filename = [NSString stringWithFormat:@"%@.mp3", newMood.moodPrefix];
    [audio playEffect:filename loop:TRUE];
    
    [_hero applyMood:newMood];
    
    // apply new mood to all blocks
    for (GroundBlock *block in _blocks) {
        [block applyMood:newMood];
    }
    
    // change background color for moods
    NSString *spriteFrameName = [NSString stringWithFormat:@"art/%@_background.png", newMood.moodPrefix];
    CCSpriteFrame* spriteFrame = [CCSpriteFrame frameWithImageNamed:spriteFrameName];
    
    for (CCSprite *bg in _backgrounds) {
        [bg setSpriteFrame:spriteFrame];
    }
    
    //TEST
    //_hero.speed += RAMP;
}

- (void)switchMood {
    if ([_masks count] == 0) {
        // mood changes are only possible with masks
        return;
    }
    
    // remove one mask
    [self removeOneMask];
    
    // set the new mood index
    _currentMoodIndex += 1;
    
    if (_currentMoodIndex >= [_moods count]) {
        _currentMoodIndex = 0;
    }
    
    [self setMood:_currentMoodIndex];
}

- (void)jump {
    if (self.onGround) {
        self.onGround = FALSE;
//        [_hero.physicsBody applyForce:ccp(_hero.physicsBody.force.x, JUMP_IMPULSE)];
        [_hero.physicsBody setVelocity:ccp(_hero.physicsBody.velocity.x, 500.f)];
    }
}

- (void)setOnGround:(BOOL)onGround {
    if (_onGround != onGround) {
        _onGround = onGround;
        
        if (_onGround) {
            [_hero runAnimationIfNotRunning:[_moods[_currentMoodIndex] moodPrefix]];
        } else {
            [_hero stopAnimation];
        }
    }
}

#pragma mark - Loose / Win interation

- (void)endGame {
    if (_gameOver) {
        return;
    }
    
    _levelSelectionButton.visible = TRUE;
    
    [_hero runDeathAnimation];
    
    CCLabelTTF *winLabel = [CCLabelTTF labelWithString:@"YOU LOSE!" fontName:@"Arial"fontSize:40.f];
    winLabel.color = [CCColor blackColor];
    winLabel.positionType = CCPositionTypeNormalized;
    winLabel.position = ccp(0.5f, 0.5f);
    
    [self addChild:winLabel];
    
    CCActionFadeIn *fadeIn = [CCActionFadeIn actionWithDuration:1.f];
    [_progressBar runAction:fadeIn];
    
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:1.f];
    _level.cascadeOpacityEnabled = TRUE;
    [_level runAction:fadeOut];
    
    CCActionFadeOut *fadeOutHero = [CCActionFadeOut actionWithDuration:1.f];
    [_hero runAction:fadeOutHero];
//    [_hero removeFromParent];
    
    int n = [_masks count];
    
    for (int i = 0; i < n; i++) {
        [self removeOneMask];
    }
    
    _gameOver = TRUE;
    
    // Delay execution of my block for couple seconds.
    [self performSelector:@selector(restartLevel) withObject:nil afterDelay:3.f];
}

- (void)restartLevel {
    // reload level
    [self stopMusic];
    CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)levelSelectionButtonPressed {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(restartLevel) object:nil];

    [self stopMusic];
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)nextLevel {
    // reload level
    [[GameState sharedInstance] loadNextLevel];
    
    [self stopMusic];
    CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)winGame {
    if (_gameOver) {
        return;
    }
    
    [_hero stopAllActions];
    
    _gameOver = TRUE;

    _nextLevelButton.visible = TRUE;

    CCLabelTTF *winLabel = [CCLabelTTF labelWithString:@"WELL DONE!" fontName:@"Arial"fontSize:40.f];
    winLabel.color = [CCColor blackColor];
    winLabel.positionType = CCPositionTypeNormalized;
    winLabel.position = ccp(0.5f, 0.5f);
    [self addChild:winLabel];
    
    NSDictionary *nextLevel = [[GameState sharedInstance] nextLevelInfo];
    NSString *levelName = [NSString stringWithFormat:@"next: %@",nextLevel[@"levelTitle"]];
    
    CCLabelTTF *nextLevelLabel = [CCLabelTTF labelWithString:levelName fontName:@"Arial"fontSize:40.f];
    nextLevelLabel.color = [CCColor blackColor];
    nextLevelLabel.positionType = CCPositionTypeNormalized;
    nextLevelLabel.position = ccp(0.5f, 0.2f);
    [self addChild:nextLevelLabel];

    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:1.f];
    _level.cascadeOpacityEnabled = TRUE;
    [_level runAction:fadeOut];
    
    CCActionFadeOut *fadeOutHero = [CCActionFadeOut actionWithDuration:1.f];
    [_hero runAction:fadeOutHero];
}

#pragma mark - Collision Handling

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero ground:(CCNode *)ground {
    if (pair.totalImpulse.y > fabs(pair.totalImpulse.x)) {
        // allow jump when we are on ground
        self.onGround = TRUE;
    }
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero goal:(CCNode *)goal {
    [self winGame];
    
    // particle effect for death
    CCParticleSystem *particle = (CCParticleSystem *)[CCBReader load:@"EnemyDies"];
    particle.position = goal.position;
    particle.autoRemoveOnFinish = TRUE;
    [goal removeFromParentAndCleanup:TRUE];
    [_physicsNode addChild:particle];

    return TRUE;
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero enemy:(CCNode *)enemy {
    BasicEnemy *basicEnemy = (BasicEnemy*)enemy;
    NSString *moodPrefix = [_moods[_currentMoodIndex] moodPrefix];
    
    // test if enemy should be killed in current mood
    if ([basicEnemy.moodToKill isEqualToString:moodPrefix]) {
        CGPoint pos = basicEnemy.position;
        
        // particle effect for death
        CCParticleSystem *particle = (CCParticleSystem *)[CCBReader load:@"EnemyDies"];
        particle.position = basicEnemy.position;
        particle.autoRemoveOnFinish = TRUE;
        [_physicsNode addChild:particle];
        
        // add a mask
        [basicEnemy removeFromParentAndCleanup:TRUE];
        [self addMaskAtPosition:pos];
    } else {
        // if enemy does not die -> player dies
        [self endGame];
    }
}

-(void)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero ground:(CCNode *)ground {
    // once we're in the air, we're not on the ground anymore and cannot jump
    _onGround = FALSE;
}

@end
