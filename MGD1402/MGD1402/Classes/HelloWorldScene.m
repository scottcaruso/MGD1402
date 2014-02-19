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
#import "NewtonScene.h"

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
    CCPhysicsNode *_physics;
    NSMutableArray *arrayOfGatorSprites;
    int scoreInt;
    bool gameOver;
    CCLabelTTF *score;
    CGSize winSize;
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
    
    scoreInt = 0;
    arrayOfGatorSprites = [[NSMutableArray alloc] init];
    gameOver = false;
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    [[OALSimpleAudio sharedInstance] playBg:@"swamp.caf" loop:YES];
    
    [self schedule:@selector(tick:) interval:1.0];
    [self schedule:@selector(checkForEnd:) interval:0.1];
    
    // Create a background
    if (winSize.height == 1536)
    {
        background = [CCSprite spriteWithImageNamed:@"swamp_background_rough_placeholder_large.png"];
    } else
    {
        background = [CCSprite spriteWithImageNamed:@"swamp_background_rough_placeholder_large.png"];
        [background setScale:0.21f];
    }

    background.anchorPoint = CGPointMake(0, 0);
    [self addChild:background];
    
    //Score display
    [self updateScore];
    
    _physics = [CCPhysicsNode node];
    _physics.gravity = ccp(0,0);
    _physics.debugDraw = YES;
    _physics.collisionDelegate = self;
    [self addChild:_physics];
    
    _hunter = [CCSprite spriteWithImageNamed:@"hunter.png"];
    _hunter.position  = ccp(420,50);
    [self addChild:_hunter];

    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Function of creating and "animating" the gators
// -----------------------------------------------------------------------

-(void)goGators
{
    _gator = [CCSprite spriteWithImageNamed:@"gator.png"];
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
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:actualDuration position:ccp(600, yLocation)];
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
            if(thisGator.position.x > 380) {
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
    
    int     bulletX   =  0;
    int     bulletY   = _hunter.position.y;
    CGPoint targetPosition = ccp(bulletX,bulletY);
    
    if (CGRectContainsPoint(rectHunt, touchLoc)) {
        //Do nothing
    } else {
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

//  -----------------------------------------------------------------------
#pragma mark - Collision
//  -----------------------------------------------------------------------

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair gatorCollision:(CCNode *)gator bulletCollision:(CCNode *)projectile {
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
    retval.x = 420;
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

-(void)updateScore
{
    NSString *scoreString = [[NSString alloc] initWithFormat:@"Score: %i",scoreInt];
    score = [CCLabelTTF labelWithString:scoreString fontName:@"Verdana-Bold" fontSize:14.0f];
    score.positionType = CCPositionTypeNormalized;
    score.position = ccp(0.1f,0.95f);
    [self addChild:score];
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