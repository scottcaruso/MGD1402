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
    CCSprite *bathroom;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HelloWorldScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    [[OALSimpleAudio sharedInstance] playBg:@"swamp.caf" loop:YES];
    
    // Create a colored background (Dark Grey)
    CCSprite *background = [CCSprite spriteWithImageNamed:@"swamp_background_rough_placeholder.png"];
    background.anchorPoint = CGPointMake(0, 0);
    [self addChild:background];
    
    // Add sprints

    _hunter = [CCSprite spriteWithImageNamed:@"hunter.png"];
    _hunter.position  = ccp(420,50);
    [self addChild:_hunter];
    
    _gator = [CCSprite spriteWithImageNamed:@"gator.png"];
    _gator.position  = ccp(115,200);
    [self addChild:_gator];
    
    _bullet = [CCSprite spriteWithImageNamed:@"bullet.png"];
    _bullet.position  = ccp(365,38);
    [self addChild:_bullet];

    // done
	return self;
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
    
    // Log touch location
    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
    
    //Hunter rect
    CGRect rectHunt = CGRectMake(_hunter.position.x-(_hunter.contentSize.width/2), _hunter.position.y-(_hunter.contentSize.height/2), _hunter.contentSize.width, _hunter.contentSize.height);
    CGRect rectGator = CGRectMake(_gator.position.x-(_gator.contentSize.width/2), _gator.position.y-(_gator.contentSize.height/2), _gator.contentSize.width, _gator.contentSize.height);
    if (CGRectContainsPoint(rectHunt, touchLoc)) {
        [[OALSimpleAudio sharedInstance] playEffect:@"shotgun.caf"];
    } else if (CGRectContainsPoint(rectGator, touchLoc)) {
        [[OALSimpleAudio sharedInstance] playEffect:@"alligator.wav"];
    }
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

- (void)onNewtonClicked:(id)sender
{
    [[CCDirector sharedDirector] pushScene:[NewtonScene scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------
@end