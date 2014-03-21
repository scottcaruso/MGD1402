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
    CCButton *userName;
    CCButton *password;
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
    userName = [CCButton buttonWithTitle:@"Tap to Enter User Name" fontName:@"Verdana-Bold" fontSize:16.0f];
    userName.color = [CCColor blackColor];
    userName.positionType = CCPositionTypeNormalized;
    userName.position = ccp(0.5f, 0.6f);
    [userName setTarget:self selector:@selector(onUserNameClicked:)];
    [self addChild:userName];
    
    // Password button
    password = [CCButton buttonWithTitle:@"Tap to Enter Password" fontName:@"Verdana-Bold" fontSize:16.0f];
    password.color = [CCColor blackColor];
    password.positionType = CCPositionTypeNormalized;
    password.position = ccp(0.5f, 0.5f);
    [password setTarget:self selector:@selector(onPasswordClicked:)];
    [self addChild:password];
    
    // Guest button
    CCButton *guestButton = [CCButton buttonWithTitle:@"Continue as Guest" fontName:@"Verdana-Bold" fontSize:12.0f];
    guestButton.color = [CCColor blackColor];
    guestButton.positionType = CCPositionTypeNormalized;
    guestButton.position = ccp(0.2f, 0.15f);
    [guestButton setTarget:self selector:@selector(onGuestButtonClicked:)];
    [self addChild:guestButton];
    
    // New User button
    CCButton *createNew = [CCButton buttonWithTitle:@"Create New User" fontName:@"Verdana-Bold" fontSize:12.0f];
    createNew.color = [CCColor blackColor];
    createNew.positionType = CCPositionTypeNormalized;
    createNew.position = ccp(0.8f, 0.15f);
    [createNew setTarget:self selector:@selector(onCreateClicked:)];
    [self addChild:createNew];
    
    // Login button
    CCButton *loginNow = [CCButton buttonWithTitle:@"Tap to Login" fontName:@"Verdana-Bold" fontSize:18.0f];
    loginNow.color = [CCColor blackColor];
    loginNow.positionType = CCPositionTypeNormalized;
    loginNow.position = ccp(0.5f, 0.35f);
    [loginNow setTarget:self selector:@selector(onPlayGameClicked:)];
    [self addChild:loginNow];
	
    // done
	return self;
}

-(void)onUserNameClicked:(id)sender
{
    UIAlertView *userNameEntry = [[UIAlertView alloc] initWithTitle:@"User Name" message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    userNameEntry.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[userNameEntry textFieldAtIndex:0] setPlaceholder:@"Enter your username here!"];
    userNameEntry.tag = 1;
    [userNameEntry show];    
    
}

-(void)onPasswordClicked:(id)sender
{
    UIAlertView *passwordEntry = [[UIAlertView alloc] initWithTitle:@"Password" message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    passwordEntry.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[passwordEntry textFieldAtIndex:0] setPlaceholder:@"Please enter a password!"];
    passwordEntry.tag = 2;
    [passwordEntry show];
}

-(void)onGuestButtonClicked:(id)sender
{
    UIAlertView *guestButton = [[UIAlertView alloc] initWithTitle:@"Password" message:@"High scores will not be saved as a guest. Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    guestButton.alertViewStyle = UIAlertViewStyleDefault;
    guestButton.tag = 3;
    [guestButton show];
}

-(void)onCreateClicked:(id)sender
{
    UIAlertView *creationAlert = [[UIAlertView alloc] initWithTitle:@"Create New User" message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    creationAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [[creationAlert textFieldAtIndex:0] setPlaceholder:@"Desired username"];
    [[creationAlert textFieldAtIndex:1] setPlaceholder:@"Desired password"];
    creationAlert.tag = 4;
    [creationAlert show];
}

-(void)onPlayGameClicked:(id)sender
{
    if ([userName.title isEqualToString:@""] || [password.title isEqualToString:@""])
    {
        UIAlertView *missingUserOrPassword = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Ensure that you have entered both a username and a password before logging in." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        missingUserOrPassword.alertViewStyle = UIAlertViewStyleDefault;
        missingUserOrPassword.tag = 5;
        [missingUserOrPassword show];
    } else
    {
        [signInControl logUserIn:userNameEntered password:passwordEntered];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        userNameEntered = [[alertView textFieldAtIndex:0] text];
        NSString *userNameString = [[NSString alloc] initWithFormat:@"User Name: %@",userNameEntered];
        userName.title = userNameString;
    }
    if (alertView.tag == 2)
    {
        passwordEntered = [[alertView textFieldAtIndex:0] text];
        password.title = @"Password: *******";
    }
    if (alertView.tag == 3)
    {
        if (buttonIndex == 1)
        {
            NSUserDefaults *highScores = [NSUserDefaults standardUserDefaults];
            [highScores setBool:YES forKey:@"IsGuestUser"];
            [highScores synchronize];
            [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                                   withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
        }
    }
    if (alertView.tag == 4)
    {
        if ([[[alertView textFieldAtIndex:0] text] isEqualToString:@""] || [[[alertView textFieldAtIndex:1] text] isEqualToString:@""])
        {
            UIAlertView *missingUserOrPassword = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Ensure that you have entered both a username and a password before trying to create an account." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            missingUserOrPassword.alertViewStyle = UIAlertViewStyleDefault;
            missingUserOrPassword.tag = 7;
            [missingUserOrPassword show];
        } else
        {
            NSString *enteredUserName = [[alertView textFieldAtIndex:0] text];
            NSString *enteredPassword = [[alertView textFieldAtIndex:1] text];
            [signInControl createNewAccount:enteredUserName password:enteredPassword];
        }
    }
}

@end
