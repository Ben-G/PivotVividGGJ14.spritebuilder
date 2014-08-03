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
#import "Instruction.h"
#import "DisplayInstruction.h"
#import "CCDirector_Private.h"
#import "GameEndLayer.h"
#define CP_ALLOW_PRIVATE_ACCESS 1
#import "CCPhysics+ObjectiveChipmunk.h"

#ifndef ANDROID
#import <Kamcord/Kamcord.h>
#endif

@interface Gameplay()

@property (nonatomic, weak) Instruction *activeInstruction;

@end

@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    
    int updates;
    
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
    
    // stores start position
    CCNode *_startPositionNode;
  
    CGFloat _baseSpeed;
    int _initialMasks;
    
    DisplayInstruction *_activeDisplayInstruction;
    NSMutableArray *_levelInstructions;
    
    id _pauseKey;
}

// distance between masks
static const CGPoint DISTANCE_PER_MASK = {-25.f,0.f};

// amount of initial masks
// static const int RAMP = 1;

static CGFloat baseSpeed = 0;

static const int JUMP_IMPULSE = 100000;

#pragma mark - Init


static void
playerUpdateVelocity(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt)
{
    cpBodyUpdateVelocity(body, gravity, damping, dt);
	
	body->v.x = baseSpeed;
}


- (void)didLoadFromCCB {
    _physicsNode.sleepTimeThreshold = 10.f;
//    _physicsNode.debugDraw= TRUE;
    
    _hero.physicsBody.body.body->velocity_func = playerUpdateVelocity;
    
    // load initial background
    NSString *spriteFrameName = @"art/calm_background.png";
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
    
    NSNumber *isTutorial = ([[GameState sharedInstance] currentLevelInfo]) [@"isTutorial"];
    
    if (![isTutorial isEqualToNumber:[NSNumber numberWithBool:TRUE]]) {
      // if this isn't a tutorial, load the level
      _level = (Level*) [CCBReader load:levelName owner:self];
        _levelInstructions = [_level.instructions mutableCopy];
    }
    
    _hero.position = _level.startPosition;
    // initialize previous position for mask following
    _hero.previousPosition = _hero.position;
    
    // read custom level properties
    _initialMasks = _level.initialMasks;
    baseSpeed = _baseSpeed = _level.levelSpeed;
    
    
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
    
    self.masks = [NSMutableArray array];
    
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

    // set up level instructions
    
#ifndef ANDROID
    [Kamcord stopRecording];
    [Kamcord startRecording];
#endif
}

- (void)addMaskAtPosition:(CGPoint)pos {
    Mood *moodForMask = nil;
    
    if ([_masks count] == 0) {
        NSInteger nextMood  = _currentMoodIndex + 1;
        
        if (nextMood >= [_moods count]) {
            nextMood = 0;
        }
        
        moodForMask = _moods[nextMood];
    } else {
        Mask *lastMask = [_masks lastObject];
        Mood *lastMaskMood = lastMask.mood;
        
        int lastMaskMoodIndex = [_moods indexOfObject:lastMaskMood];
        int nextMaskMoodIndex = lastMaskMoodIndex + 1;
        
        if (nextMaskMoodIndex >= [_moods count]) {
            nextMaskMoodIndex = 0;
        }
        moodForMask = _moods[nextMaskMoodIndex];
    }

    Mask *mask = (Mask*)[CCBReader load:@"Mask"];
    mask.mood = moodForMask;
    mask.position = ccp(-1000, 1000);
    [_level addChild:mask];
    [_masks addObject:mask];
}

- (void)removeAllBlocks {
    _blocks = [NSMutableArray array];
}

- (void)findBlocks:(CCNode *)node {
    node.cascadeOpacityEnabled = TRUE;
    
    for (int i = 0; i < node.children.count; i++) {
        CCNode *child = node.children[i];
        
        if ([child children] > 0) {
            [self findBlocks:(CCNode *)child];
        } else if ([child isKindOfClass:[Block class]]) {
            [_blocks addObject:child];
            [((GroundBlock *) child) applyMood:_moods[_currentMoodIndex]];
        }
    }
}

#pragma mark - Update

- (void)fixedUpdate:(CCTime)delta {
    
    if (_gameOver || self.contentNode.paused) {
        return;
    }
    
    // GJ hack, to forbid rotation
    _hero.rotation = 0.f;
    
    CGPoint heroWorldPos = [_physicsNode convertToWorldSpace:_hero.position];
    CGPoint heroOnScreen = [self convertToNodeSpace:heroWorldPos];
    
    if (heroOnScreen.x < 0) {
        [self endGame:DeathTypeOffScreen];
    }
    
    if (_hero.position.x >= levelGoal) {
        //[self winGame];
    }
    
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
        [self endGame:DeathTypeOffScreen];
    }
    
//    if (_hero.physicsBody.velocity.x < _baseSpeed) {
//        [_hero.physicsBody applyForce:ccp(10000.f, _hero.physicsBody.force.y)];
//    }
    
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
    
    // check for instructions
    NSRange heroRange = NSMakeRange(CGRectGetMinX(_hero.boundingBox), CGRectGetWidth(_hero.boundingBox));
    
    if (!self.activeInstruction) {
        for (Instruction *instruction in _levelInstructions) {
            NSRange intersectionRange = NSIntersectionRange(heroRange, instruction.instructionRange);
            
            if (intersectionRange.length != 0) {
                // check if the instruction might already be fullfilled, before displaying it
                BOOL fullfilled = [instruction switchedMood:_moods[_currentMoodIndex]];
                
                if (!fullfilled) {
                    if (instruction.instructionType == InstructionTypeSwitch) {
                        if ([_masks count] > 0) {
                            self.activeInstruction = instruction;
                        }
                    } else {
                        self.activeInstruction = instruction;
                    }
                }
                
                // only one instruction can be shown at a time, so break here and don't check other instructions
                break;
            }
        }
    } else {
        NSRange intersectionRange = NSIntersectionRange(heroRange, self.activeInstruction.instructionRange);
        
        // if a player missed an instruction, check if the instruction is forgiving
        if (intersectionRange.length == 0) {
            if (self.activeInstruction.forgiving) {
                [self pauseWithKey:self.activeInstruction];
            } else {
                self.activeInstruction = nil;
            }
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
    
    if (distance > 50.f) {
        [self switchMood];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(jump) object:nil];
    }
    else {
        [self jump];
    }
}

- (void)removeOneMask {
    Mask *firstMask = [_masks firstObject];
    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:6.f position:ccp(-200, 800)];
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:6.f];
    CCActionCallBlock *removeFromParent = [CCActionCallBlock actionWithBlock:^{
        [firstMask removeFromParent];
    }];
    
    CCActionEaseBounceOut *bounceOut = [CCActionEaseBounceOut actionWithAction:moveBy];
    CCActionSpawn *group = [CCActionSpawn actionOne:bounceOut two:fadeOut];

    CCActionSequence *sequence = [CCActionSequence actions:group, removeFromParent, nil];
    
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
//    [audio playEffect:filename loop:TRUE];
    
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
    
    if (_activeInstruction) {
        BOOL completed = [_activeInstruction switchedMood:_moods[_currentMoodIndex]];
        if (completed) {
            [self resumeWithKey:self.activeInstruction];
            self.activeInstruction = nil;
        }
    }
//    [[[CCDirector sharedDirector] scheduler] setTimeScale:0.5f];
}

- (void)jump {
    if (_activeInstruction) {
        BOOL completed = [_activeInstruction jumped];
        if (completed) {
            [self resumeWithKey:self.activeInstruction];
            self.activeInstruction = nil;
        }
    }
    
    //TODO: needs to be improved, need to check that arbiter actually is the ground
    __block BOOL jumped = FALSE;
    
    [_hero.physicsBody.chipmunkObjects[0] eachArbiter:^(cpArbiter *arbiter) {
        if (!jumped && self.onGround) {
            [_hero.physicsBody setVelocity:ccp(_hero.physicsBody.velocity.x, 500.f)];
            jumped = TRUE;
            self.onGround = FALSE;
        }
    }];
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

- (void)endGame:(DeathType)deathType {
    if (_gameOver) {
        return;
    }
    
    self.activeInstruction = nil;
    
    [_hero runDeathAnimation];
    
    for (CCNode *block in _blocks) {
        // stop blinking of blocks, because we will fade out now
        [block stopAllActions];
    }
    
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:1.f];
    _level.cascadeOpacityEnabled = TRUE;
    [_level runAction:fadeOut];
    
    CCActionFadeOut *fadeOutHero = [CCActionFadeOut actionWithDuration:1.f];
    [_hero runAction:fadeOutHero];

    GameEndLayer *gameEndLayer = (GameEndLayer *) [CCBReader load:@"UI/GameEndLayer" owner:self];
    gameEndLayer.cascadeOpacityEnabled = YES;
    gameEndLayer.opacity = 0.f;
    [gameEndLayer displayCompletionRate:(_hero.position.x / (levelGoal  * 1.f))];
    
    NSString *hint;
    if ([_masks count] == 0) {
        hint = NSLocalizedString(@"hint_no_masks", nil);
    } else if (deathType == DeathTypeEnemy) {
        hint = NSLocalizedString(@"hint_kill_enemy", nil);
    } else if (deathType == DeathTypeOffScreen) {
        hint = NSLocalizedString(@"hint_blocks_colors", nil);
    }
    
    [gameEndLayer displayHint:hint];
    
    [self addChild:gameEndLayer];
    
    CCActionFadeIn *fadeIn = [CCActionFadeIn actionWithDuration:1.f];
    [gameEndLayer runAction:fadeIn];
    
    
    int n = [_masks count];
    
    for (int i = 0; i < n; i++) {
        [self removeOneMask];
    }
    
    _gameOver = TRUE;
}

- (void)restartLevel {
    // reload level
    [self stopMusic];

    CCNode *loadingScreen = [CCBReader load:@"UI/LoadingScreen"];
    [self addChild:loadingScreen];
    [self performSelector:@selector(actualRestartLevel) withObject:nil afterDelay:0.1f];
}

- (void)actualRestartLevel {
    CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)levelSelectionButtonPressed {
    [self stopMusic];
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)watchReplay {
#ifndef ANDROID
    [Kamcord showView];
#endif
}

- (void)restartPressed {
    [self restartLevel];
}

- (void)nextLevel {
    // reload level
    [[GameState sharedInstance] loadNextLevel];
    
    [self stopMusic];
    
    CCNode *loadingScreen = [CCBReader load:@"UI/LoadingScreen"];
    [self addChild:loadingScreen];
    [self performSelector:@selector(actualNextLevel) withObject:nil afterDelay:0.1f];
}

- (void)actualNextLevel {
    CCScene *scene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)winGame {
    if (_gameOver) {
        return;
    }
    
    self.activeInstruction = nil;
    
    baseSpeed = 0;
    
    [_hero stopAllActions];
    
    _gameOver = TRUE;

    CCNode *gameWinLayer = [CCBReader load:@"UI/GameWinLayer" owner:self];
    gameWinLayer.cascadeOpacityEnabled = YES;
    gameWinLayer.opacity = 0.f;
    [self addChild:gameWinLayer];
    
    CCActionFadeIn *fadeIn = [CCActionFadeIn actionWithDuration:1.f];
    [gameWinLayer runAction:fadeIn];
    

    for (CCNode *block in _blocks) {
        // stop blinking of blocks, because we will fade out now
        [block stopAllActions];
    }
    
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:1.f];
    _level.cascadeOpacityEnabled = TRUE;
    [_level runAction:fadeOut];
    
    CCActionFadeOut *fadeOutHero = [CCActionFadeOut actionWithDuration:1.f];
    [_hero runAction:fadeOutHero];
    
#ifndef ANDROID
    // wait 1 second, then stop recording
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [Kamcord stopRecording];
    });
#endif
}

#pragma mark - Collision Handling

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero ground:(CCNode *)ground {
    CCContactSet contactSet = pair.contacts;
    CGPoint collisionNormal = contactSet.normal;
    if (collisionNormal.y < -0.5f) {
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

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero enemy:(CCNode *)enemy {
    
    BasicEnemy *basicEnemy = (BasicEnemy*)enemy;
    NSString *moodPrefix = [_moods[_currentMoodIndex] moodPrefix];
    
    // test if enemy should be killed in current mood
    if ([basicEnemy.moodToKill isEqualToString:moodPrefix]) {
        CGPoint pos = basicEnemy.position;
        
        // particle effect for death
        CCParticleSystem *particle = (CCParticleSystem *)[CCBReader load:@"EnemyDies"];
        CGPoint enemyWorldPosition = [basicEnemy.parent convertToWorldSpace:basicEnemy.position];
        particle.position = [_physicsNode convertToNodeSpace:enemyWorldPosition];
        particle.autoRemoveOnFinish = TRUE;
        [_physicsNode addChild:particle];
        
        // add a mask
        [basicEnemy removeFromParentAndCleanup:TRUE];
        [self addMaskAtPosition:pos];
    } else {
        // if enemy does not die -> player dies
        [self endGame:DeathTypeEnemy];
    }
    
    return NO;
}

#pragma mark - Instructions

- (void)setActiveInstruction:(Instruction *)activeInstruction {
    if (activeInstruction == nil) {
        // hide old instruction
        [_activeDisplayInstruction completeInstruction];
        // remove old instruction from instruction list
        [_levelInstructions removeObject:_activeInstruction];
    } else {
        // show new instruction
        DisplayInstruction *instruction = (DisplayInstruction *)[CCBReader load:@"Instructions/DisplayInstruction"];
        instruction.positionType = CCPositionTypeNormalized;
        instruction.position = ccp(0.5f, 0.5f);
        _activeDisplayInstruction = instruction;
        [self addChild:_activeDisplayInstruction];
        _activeDisplayInstruction.instructionLabel.string = activeInstruction.instructionText;
    }
    
    _activeInstruction = activeInstruction;
}

#pragma mark - Pause / Resume

- (void)pauseWithKey:(id)pauseKey {
    if (self.contentNode.paused == NO) {
        _pauseKey = pauseKey;
        self.contentNode.paused = YES;
    }
}

- (void)resumeWithKey:(id)pauseKey {
    if (pauseKey == _pauseKey) {
        self.contentNode.paused = NO;
    }
}

@end
