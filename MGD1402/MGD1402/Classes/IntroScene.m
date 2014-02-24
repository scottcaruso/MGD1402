//
//  IntroScene.m
//  MGD1402
//
//  Created by Scott Caruso on 2/3/14.
//  Copyright Scott Caruso 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "NewtonScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Label
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Gator Gallery" fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.65f); // Middle of screen
    [self addChild:label];
    
    // Play game button
    CCButton *playGame = [CCButton buttonWithTitle:@"[ Play Game ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    playGame.positionType = CCPositionTypeNormalized;
    playGame.position = ccp(0.5f, 0.45f);
    [playGame setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:playGame];
    
    // High scores button
    CCButton *highScores = [CCButton buttonWithTitle:@"[ High Scores ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    highScores.positionType = CCPositionTypeNormalized;
    highScores.position = ccp(0.5f, 0.35f);
    [highScores setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:highScores];
    
    // Instructions button
    CCButton *howToPlay = [CCButton buttonWithTitle:@"[ Instructions ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    howToPlay.positionType = CCPositionTypeNormalized;
    howToPlay.position = ccp(0.5f, 0.25f);
    [howToPlay setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:howToPlay];
    
    // Credits button
    CCButton *credits = [CCButton buttonWithTitle:@"[ Credits ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    credits.positionType = CCPositionTypeNormalized;
    credits.position = ccp(0.5f, 0.15f);
    [credits setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:credits];
	
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onPlayClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

@end
