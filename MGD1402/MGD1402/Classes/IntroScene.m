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
{

}

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
    
    CGSize winSize = [[CCDirector sharedDirector] viewSizeInPixels];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //Background
    CCSprite *background;
    if (winSize.height == 1536)
    {
        background = [CCSprite spriteWithImageNamed:@"menu_background@2x~iPad.png"];
    } else
    {
        background = [CCSprite spriteWithImageNamed:@"menu_background-568h@2x.png"];
    }
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
    playGame.position = ccp(0.5f, 0.7f);
    [playGame setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:playGame];
    
    // Online Leaderboards button
    CCButton *leaderboards = [CCButton buttonWithTitle:@"[ Leaderboards ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    leaderboards.color = [CCColor blackColor];
    leaderboards.positionType = CCPositionTypeNormalized;
    leaderboards.position = ccp(0.5f, 0.6f);
    [leaderboards setTarget:self selector:@selector(onLeaderboardsClicked:)];
    [self addChild:leaderboards];
    
    // High scores button
    CCButton *highScores = [CCButton buttonWithTitle:@"[ Local High Scores ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    highScores.color = [CCColor blackColor];
    highScores.positionType = CCPositionTypeNormalized;
    highScores.position = ccp(0.5f, 0.5f);
    [highScores setTarget:self selector:@selector(onHighScoresClicked:)];
    [self addChild:highScores];
    
    // Achievements button
    CCButton *achievements = [CCButton buttonWithTitle:@"[ Achievements ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    achievements.color = [CCColor blackColor];
    achievements.positionType = CCPositionTypeNormalized;
    achievements.position = ccp(0.5f, 0.4f);
    [achievements setTarget:self selector:@selector(onHighScoresClicked:)];
    [self addChild:achievements];
    
    // Instructions button
    CCButton *howToPlay = [CCButton buttonWithTitle:@"[ Instructions ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    howToPlay.color = [CCColor blackColor];
    howToPlay.positionType = CCPositionTypeNormalized;
    howToPlay.position = ccp(0.5f, 0.3f);
    [howToPlay setTarget:self selector:@selector(onInstructionsClicked:)];
    [self addChild:howToPlay];
    
    // Credits button
    CCButton *credits = [CCButton buttonWithTitle:@"[ Credits ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    credits.color = [CCColor blackColor];
    credits.positionType = CCPositionTypeNormalized;
    credits.position = ccp(0.5f, 0.2f);
    [credits setTarget:self selector:@selector(onCreditsClicked:)];
    [self addChild:credits];
    
    // Login label
    bool isGuest = [userDefaults boolForKey:@"IsGuestUser"];
    NSString *nameString = [[NSString alloc] init];
    if (isGuest == true)
    {
        nameString = @"Guest User";
    } else
    {
        nameString = [[NSString alloc] initWithFormat:@"User: %@",[userDefaults objectForKey:@"CurrentUser"]];
    }
    
    CCLabelTTF *userName = [CCLabelTTF labelWithString:nameString fontName:@"Verdana-Bold" fontSize:10.0f];
    userName.positionType = CCPositionTypeNormalized;
    userName.color = [CCColor blackColor];
    userName.position = ccp(0.90f, 0.95f); // Middle of screen
    [self addChild:userName];
	
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

- (void)onLeaderboardsClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[LeaderboardScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

@end
