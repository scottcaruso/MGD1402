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
#import "MainGameScene.h"
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
    
    //Background
    CCSprite *background = [CCSprite spriteWithImageNamed:@"menu_background-568h@2x.png"];
    background.positionType = CCPositionTypeNormalized;
    background.position = ccp(0.5f,0.5f);
    [self addChild:background];
    
    // Label
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Gator Gallery" fontName:@"Optima" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.85f); // Middle of screen
    [self addChild:label];
    
    // Play game button
    CCButton *playGame = [CCButton buttonWithTitle:@"[ Play Game ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    playGame.color = [CCColor blackColor];
    playGame.positionType = CCPositionTypeNormalized;
    playGame.position = ccp(0.5f, 0.45f);
    [playGame setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:playGame];
    
    // High scores button
    CCButton *highScores = [CCButton buttonWithTitle:@"[ High Scores ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    highScores.color = [CCColor blackColor];
    highScores.positionType = CCPositionTypeNormalized;
    highScores.position = ccp(0.5f, 0.35f);
    [highScores setTarget:self selector:@selector(onHighScoresClicked:)];
    [self addChild:highScores];
    
    // Instructions button
    CCButton *howToPlay = [CCButton buttonWithTitle:@"[ Instructions ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    howToPlay.color = [CCColor blackColor];
    howToPlay.positionType = CCPositionTypeNormalized;
    howToPlay.position = ccp(0.5f, 0.25f);
    [howToPlay setTarget:self selector:@selector(onInstructionsClicked:)];
    [self addChild:howToPlay];
    
    // Credits button
    CCButton *credits = [CCButton buttonWithTitle:@"[ Credits ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    credits.color = [CCColor blackColor];
    credits.positionType = CCPositionTypeNormalized;
    credits.position = ccp(0.5f, 0.15f);
    [credits setTarget:self selector:@selector(onCreditsClicked:)];
    [self addChild:credits];
	
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onPlayClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[MainGameScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onInstructionsClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[InstructionsScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onCreditsClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CreditsScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onHighScoresClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[HighScoresScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

@end
