//
//  LoginScene.m
//  MGD1402
//
//  Created by Scott Caruso on 3/19/14.
//  Copyright 2014 Scott Caruso. All rights reserved.
//

#import "LoginScene.h"


@implementation LoginScene
{
    LeaderboardsAndSignIn *signInControl;
    NSString *userNameEntered;
    NSString *passwordEntered;
}


+ (LoginScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    signInControl = [[LeaderboardsAndSignIn alloc] init];
    CGSize winSize = [[CCDirector sharedDirector] viewSizeInPixels];
    
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
    
    // Label - headline
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Gator Gallery" fontName:@"Optima" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.85f); // Middle of screen
    [self addChild:label];
    
    // User name button
    CCButton *userName = [CCButton buttonWithTitle:@"User Name" fontName:@"Verdana-Bold" fontSize:18.0f];
    userName.color = [CCColor blackColor];
    userName.positionType = CCPositionTypeNormalized;
    userName.position = ccp(0.5f, 0.45f);
    [userName setTarget:self selector:@selector(onUserNameClicked:)];
    [self addChild:userName];
    
    // Password button
    CCButton *password = [CCButton buttonWithTitle:@"Password" fontName:@"Verdana-Bold" fontSize:18.0f];
    password.color = [CCColor blackColor];
    password.positionType = CCPositionTypeNormalized;
    password.position = ccp(0.5f, 0.35f);
    [password setTarget:self selector:@selector(onPasswordClicked:)];
    [self addChild:password];
    
    // Instructions button
    CCButton *guestButton = [CCButton buttonWithTitle:@"Continue as Guest" fontName:@"Verdana-Bold" fontSize:12.0f];
    guestButton.color = [CCColor blackColor];
    guestButton.positionType = CCPositionTypeNormalized;
    guestButton.position = ccp(0.2f, 0.15f);
    [guestButton setTarget:self selector:@selector(onGuestButtonClicked:)];
    [self addChild:guestButton];
    
    // Credits button
    CCButton *createNew = [CCButton buttonWithTitle:@"Create New User" fontName:@"Verdana-Bold" fontSize:12.0f];
    createNew.color = [CCColor blackColor];
    createNew.positionType = CCPositionTypeNormalized;
    createNew.position = ccp(0.8f, 0.15f);
    [createNew setTarget:self selector:@selector(onCreteClicked:)];
    [self addChild:createNew];
	
    // done
	return self;
}

-(void)onNameClicked:(id)sender
{
    UIAlertView *userNameEntry = [[UIAlertView alloc] initWithTitle:@"User Name" message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    userNameEntry.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[userNameEntry textFieldAtIndex:0] setPlaceholder:@"Enter your username here!"];
    userNameEntry.tag = 1; //This tag tells the alertView function where to insert the new high score.
    [userNameEntry show];    
    
}

-(void)onPasswordClicked:(id)sender
{
    UIAlertView *passwordEntry = [[UIAlertView alloc] initWithTitle:@"Password" message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    passwordEntry.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[passwordEntry textFieldAtIndex:0] setPlaceholder:@"Please enter a password!"];
    passwordEntry.tag = 2; //This tag tells the alertView function where to insert the new high score.
    [passwordEntry show];
}

-(void)onGuestButtonClicked:(id)sender
{
    UIAlertView *guestButton = [[UIAlertView alloc] initWithTitle:@"Password" message:@"High scores will not be saved as a guest. Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    guestButton.alertViewStyle = UIAlertViewStyleDefault;
    [[guestButton textFieldAtIndex:0] setPlaceholder:@"Please enter a password!"];
    guestButton.tag = 3; //This tag tells the alertView function where to insert the new high score.
    [guestButton show];
}

-(void)onCreateClicked:(id)sender
{
    UIAlertView *creationAlert = [[UIAlertView alloc] initWithTitle:@"Create New User" message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    creationAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[creationAlert textFieldAtIndex:0] setPlaceholder:@"Desired username"];
    [[creationAlert textFieldAtIndex:1] setPlaceholder:@"Desired password"];
    creationAlert.tag = 4; //This tag tells the alertView function where to insert the new high score.
    [creationAlert show];
}

-(void)onPlayGameClicked:(id)sender
{
    [signInControl logUserIn:userNameEntered password:passwordEntered];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
    }
    if (alertView.tag == 2)
    {
    }
    if (alertView.tag == 3)
    {
    }
    if (alertView.tag == 4)
    {
    }
        NSString *userName = [[alertView textFieldAtIndex:0] text];
        NSString *newScore = scoreString;
        NSString *ratioStringWithPercent = [[NSString alloc] initWithFormat:@"%@%%",ratioString];
        int whereToInsert = alertView.tag;
        [arrayOfHighScoreNames insertObject:userName atIndex:whereToInsert];
        [arrayOfHighScoreScores insertObject:newScore atIndex:whereToInsert];
        [arrayOfBulletScores insertObject:ratioStringWithPercent atIndex:whereToInsert];
        [arrayOfHighScoreNames removeLastObject];
        [arrayOfHighScoreScores removeLastObject];
        [arrayOfBulletScores removeLastObject];
        NSUserDefaults *highScores = [NSUserDefaults standardUserDefaults];
        [highScores setObject:arrayOfHighScoreNames forKey:@"Names"];
        [highScores setObject:arrayOfHighScoreScores forKey:@"Scores"];
        [highScores setObject:arrayOfBulletScores forKey:@"BulletScores"];
        [highScores synchronize];
    }
    //Return to main menu, regardless of which pop-up you get.
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

@end
