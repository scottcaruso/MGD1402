//
//  HelloWorldScene.m
//  MGD1402
//
//  Created by Scott Caruso on 2/3/14.
//  Copyright Scott Caruso 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "HelloWorldScene.h"
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - HelloWorldScene
// -----------------------------------------------------------------------

@implementation HelloWorldScene
{
    CCSprite *_hunter;
    CCSprite *_gator;
    CCSprite *_bullet;
    CCSprite *background;
    CCSprite *physicsWallForShore;
    CCSprite *pauseButton;
    CCPhysicsNode *_physics;
    CCAnimation *hitAnimation;
    NSMutableArray *arrayOfGatorSprites;
    NSMutableArray *arrayOfHitFrames;
    int scoreInt;
    bool gameOver;
    bool pauseState;
    CCLabelTTF *score;
    CGSize winSize;
    CGSize winSizeInPoints;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize = [[CCDirector sharedDirector] viewSizeInPixels];
    winSizeInPoints = [[CCDirector sharedDirector] viewSize];
    
    scoreInt = 0;
    arrayOfGatorSprites = [[NSMutableArray alloc] init];
    gameOver = false;
    pauseState = false;
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    [[OALSimpleAudio sharedInstance] playBg:@"swamp.caf" loop:YES];
    
    [self schedule:@selector(tick:) interval:1.0];
    [self schedule:@selector(checkForEnd:) interval:0.1];
    

    background = [CCSprite spriteWithImageNamed:@"swamp_background_rough_placeholder.png"];
    background.scale = 0.55f;
    background.positionType = CCPositionTypeNormalized;
    background.position = ccp(0.5f,0.5f);
    [self addChild:background];
    
    //Score display
    [self updateScore];
    
    _physics = [CCPhysicsNode node];
    _physics.gravity = ccp(0,0);
    _physics.debugDraw = YES;
    _physics.collisionDelegate = self;
    [self addChild:_physics];
    
    //THIS IS A HACK - FOR FINAL, USE A REAL, PROPERLY-SCALED HUNTER IMAGE
    _hunter = [CCSprite spriteWithImageNamed:@"hunter.png"];
    if (winSize.height == 1536)
    {
        [_hunter setScale:2.5f];
    }
    _hunter.position  = ccp(winSizeInPoints.width*.88,50);
    [self addChild:_hunter];
    
    pauseButton = [CCSprite spriteWithImageNamed:@"pause.png"];
    pauseButton.position = ccp(winSizeInPoints.width*.27,winSizeInPoints.height*.92);
    [self addChild:pauseButton];
    
    // Create batch node for text animation
    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"hit_text_sheet_default.png"];
    
    // Add the batch node to parent
    [self addChild:batchNode];
    
    // Load sprite frames, which are just a bunch of named rectangle
    // definitions that go along with the image in a sprite sheet
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hit_text_sheet_default.plist"];
    
    //Gather the list of frames for the hit animation
    
    arrayOfHitFrames = [[NSMutableArray alloc] init];
    for (int x=0; x<=5; x++) {
        [arrayOfHitFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"hit%d.png",x]]];
    }
    
    hitAnimation = [CCAnimation animationWithSpriteFrames:arrayOfHitFrames delay:0.1f];
    
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Function of creating and "animating" the gators
// -----------------------------------------------------------------------

-(void)goGators
{
    _gator = [CCSprite spriteWithImageNamed:@"gator.png"];
    if (winSize.height == 1536)
    {
        [_gator setScale:2.5f];
    }
    // Determine where to spawn the monster along the Y axis
    int minY = _gator.contentSize.height + 175;
    int maxY = winSize.height - 100;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY);
    _gator.position  = ccp(-50,actualY);
    _gator.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _gator.contentSize} cornerRadius:0];
    _gator.physicsBody.collisionGroup = @"gatorGroup";
    _gator.physicsBody.collisionType  = @"gatorCollision";
    [arrayOfGatorSprites addObject:_gator];
    [_physics addChild:_gator];
    [self moveGator:_gator yLoc:actualY];
    
}

-(void)moveGator:(CCSprite*)gator yLoc:(int)yLocation
{
    int minDuration = 2.5;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:actualDuration position:ccp(winSizeInPoints.width*1.1, yLocation)];
    //CCActionCallBlock * actionMoveDone = [CCActionCallBlock actionWithBlock:^(CCNode *node) {
        //[node removeFromParent];
    //}];
    [gator runAction:[CCActionSequence actions:actionMove, nil, nil]];
}

// -----------------------------------------------------------------------
#pragma mark - Timer
// ----------------------------------------------------------------------

-(void)tick:(CCTime)dt
{
    if (gameOver == false)
    {
        [self goGators];
    } else {
        // Reset button
        CCButton *reset = [CCButton buttonWithTitle:@"Reset" fontName:@"Verdana-Bold" fontSize:18.0f];
        reset.positionType = CCPositionTypeNormalized;
        reset.position = ccp(0.75f,0.75f);
        [reset setTarget:self selector:@selector(onBackClicked:)];
        [self addChild:reset];
    }
}

-(void)checkForEnd:(CCTime)dt
{
    if (arrayOfGatorSprites.count > 0)
    {
        for (CCSprite *thisGator in arrayOfGatorSprites)
        {
            if(thisGator.position.x > winSizeInPoints.width*.8f) {
                gameOver = true;
                for (CCSprite *thisGator in arrayOfGatorSprites)
                {
                    if(thisGator.position.x > 0)
                    {
                        [thisGator removeFromParent];
                    }
                }
            }
        }
    }
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Pr frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touches withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touches locationInNode:self];
    
    //Hunter rect
    CGRect rectHunt = CGRectMake(_hunter.position.x-(_hunter.contentSize.width/2), _hunter.position.y-(_hunter.contentSize.height/2), _hunter.contentSize.width, _hunter.contentSize.height);
    
    //Pause rect
    CGRect rectPause = CGRectMake(pauseButton.position.x-(pauseButton.contentSize.width/2), pauseButton.position.y-(pauseButton.contentSize.height/2), pauseButton.contentSize.width, pauseButton.contentSize.height);
    
    int     bulletX   =  0;
    int     bulletY   = _hunter.position.y;
    CGPoint targetPosition = ccp(bulletX,bulletY);
    
    if (CGRectContainsPoint(rectHunt, touchLoc)) {
        //Do nothing
    } else if (CGRectContainsPoint(rectPause, touchLoc))
    {
        if (pauseState == false)
        {
            for(CCSprite *sprite in [self children])
            {
                [[CCDirector sharedDirector] pause];
            }
            pauseState = true;
        } else
        {
            for(CCSprite *sprite in [self children])
            {
                [[CCDirector sharedDirector] resume];
            }
            pauseState = false;
        }
    } else {
        if (pauseState == false)
        {
            _bullet = [CCSprite spriteWithImageNamed:@"bullet.png"];
            _bullet.position  = ccp(365,bulletY);
            _bullet.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _bullet.contentSize} cornerRadius:0];
            _bullet.physicsBody.collisionGroup = @"bulletGroup";
            _bullet.physicsBody.collisionType = @"bulletCollision";
            [_physics addChild:_bullet];
            [[OALSimpleAudio sharedInstance] playEffect:@"shotgun.caf"];
            CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
            CCActionRemove *actionRemove = [CCActionRemove action];
            [_bullet runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
        }
    }
}

//  -----------------------------------------------------------------------
#pragma mark - Collision
//  -----------------------------------------------------------------------

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair gatorCollision:(CCNode *)gator bulletCollision:(CCNode *)projectile {
    CGPoint collisionPoint = projectile.positionInPoints;
    [self onHitAnimation:collisionPoint];
    [[OALSimpleAudio sharedInstance] playEffect:@"alligator.wav"];
    [gator removeFromParent];
    [projectile removeFromParent];
    scoreInt++;
    [score removeFromParent];
    [self updateScore];
    [arrayOfGatorSprites removeObject:gator];
    return YES;
}

- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGPoint retval = newPos;
    retval.x = winSizeInPoints.width*.88;
    return retval;
}

- (void)panForTranslation:(CGPoint)translation {
    if (_hunter) {
        CGPoint newPos = ccpAdd(_hunter.position, translation);
        _hunter.position = [self boundLayerPos:newPos];
    } else {
       //Do nothing
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    if (pauseState == false)
        {
        //Hunter rect
        CGRect rectHunt = CGRectMake(_hunter.position.x-(_hunter.contentSize.width/2), _hunter.position.y-(_hunter.contentSize.height/2), _hunter.contentSize.width, _hunter.contentSize.height);
        
        if (CGRectContainsPoint(rectHunt, touchLoc)) {
            
            CGPoint touchLocation = [self convertToNodeSpace:touch.locationInWorld];
            
            CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
            oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
            oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
            
            CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
            [self panForTranslation:translation];
        } else {
            //Do nothing
        }
    }
}

-(void)updateScore
{
    NSString *scoreString = [[NSString alloc] initWithFormat:@"Score: %i",scoreInt];
    score = [CCLabelTTF labelWithString:scoreString fontName:@"Verdana-Bold" fontSize:14.0f];
    score.positionType = CCPositionTypeNormalized;
    score.position = ccp(0.1f,0.95f);
    [self addChild:score];
}

//I couldn't for the life of me figure out how to do animations in V3 of Cocos. CCAnimation appears to no longer be supported - or at least is coming up as unrecognized when I try to use it. This is the best I could come up with.
-(void)onHitAnimation:(CGPoint)location
{
    CCSprite *hit = [CCSprite spriteWithImageNamed:@"hit0.png"];
    hit.position = ccp(location.x,location.y);
    CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:hitAnimation];
    CCActionRemove *remove = [CCActionRemove action];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[animationAction,remove]];
    [hit runAction:sequence];
    [self addChild:hit];
}


// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}


// -----------------------------------------------------------------------
@end