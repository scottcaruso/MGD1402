//
//  AchievementsScene.m
//  MGD1402
//
//  Created by Scott Caruso on 3/25/14.
//  Copyright 2014 Scott Caruso. All rights reserved.
//

#import "AchievementsScene.h"


@implementation AchievementsScene

+ (AchievementsScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
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
    
    
    // Label - Title
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Achievements" fontName:@"Monaco" fontSize:25.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor blackColor];
    label.position = ccp(0.5f, 0.95f);
    [self addChild:label];
    
    //Instructions
    CCLabelTTF *instructionsText = [CCLabelTTF labelWithString:@"Click on an achievement name to get more details." fontName:@"Monaco" fontSize:8.0f];
    instructionsText.positionType = CCPositionTypeNormalized;
    instructionsText.color = [CCColor blackColor];
    instructionsText.position = ccp(0.5f, 0.88f);
    [self addChild:instructionsText];
    
    //Achievements Header
    CCLabelTTF *achievementsColumn = [CCLabelTTF labelWithString:@"Achievement Name" fontName:@"Monaco" fontSize:14.0f];
    achievementsColumn.positionType = CCPositionTypeNormalized;
    achievementsColumn.color = [CCColor blackColor];
    achievementsColumn.position = ccp(0.25f, 0.8f);
    [self addChild:achievementsColumn];
    
    
    // Achievement 1
    CCButton *achievementOne = [CCButton buttonWithTitle:@"Junior Ranger" fontName:@"Verdana-Bold" fontSize:10.0f];
    achievementOne.positionType = CCPositionTypeNormalized;
    achievementOne.position = ccp(0.25f, 0.7f);
    achievementOne.color = [CCColor blackColor];
    [achievementOne setTarget:self selector:@selector(onButtonClicked:)];
    [self addChild:achievementOne];
    
    // Achievement 2
    CCButton *achievementTwo = [CCButton buttonWithTitle:@"Game Hunter" fontName:@"Verdana-Bold" fontSize:10.0f];
    achievementTwo.positionType = CCPositionTypeNormalized;
    achievementTwo.position = ccp(0.25f, 0.6f);
    achievementTwo.color = [CCColor blackColor];
    [achievementTwo setTarget:self selector:@selector(onButtonClicked:)];
    [self addChild:achievementTwo];
    
    // Achievement 3
    CCButton *achievementThree = [CCButton buttonWithTitle:@"Gator Bane" fontName:@"Verdana-Bold" fontSize:10.0f];
    achievementThree.positionType = CCPositionTypeNormalized;
    achievementThree.position = ccp(0.25f, 0.5f);
    achievementThree.color = [CCColor blackColor];
    [achievementThree setTarget:self selector:@selector(onButtonClicked:)];
    [self addChild:achievementThree];
    
    // Achievement 4
    CCButton *achievementFour = [CCButton buttonWithTitle:@"King of all Gators" fontName:@"Verdana-Bold" fontSize:10.0f];
    achievementFour.positionType = CCPositionTypeNormalized;
    achievementFour.position = ccp(0.25f, 0.4f);
    achievementFour.color = [CCColor blackColor];
    [achievementFour setTarget:self selector:@selector(onButtonClicked:)];
    [self addChild:achievementFour];
    
    // Achievement 5
    CCButton *achievementFive = [CCButton buttonWithTitle:@"Deadeye" fontName:@"Verdana-Bold" fontSize:10.0f];
    achievementFive.positionType = CCPositionTypeNormalized;
    achievementFive.position = ccp(0.25f, 0.3f);
    achievementFive.color = [CCColor blackColor];
    [achievementFive setTarget:self selector:@selector(onButtonClicked:)];
    [self addChild:achievementFive];
    
    // Achievement 6
    CCButton *achievementSix = [CCButton buttonWithTitle:@"Crikey!" fontName:@"Verdana-Bold" fontSize:10.0f];
    achievementSix.positionType = CCPositionTypeNormalized;
    achievementSix.position = ccp(0.25f, 0.2f);
    achievementSix.color = [CCColor blackColor];
    [achievementSix setTarget:self selector:@selector(onButtonClicked:)];
    [self addChild:achievementSix];
    
    //Status Header
    CCLabelTTF *statusColumn = [CCLabelTTF labelWithString:@"Status" fontName:@"Monaco" fontSize:14.0f];
    statusColumn.positionType = CCPositionTypeNormalized;
    statusColumn.color = [CCColor blackColor];
    statusColumn.position = ccp(0.75f, 0.8f);
    [self addChild:statusColumn];
    
    
    // Main Menu
    CCButton *mainMenu = [CCButton buttonWithTitle:@"Return To Main" fontName:@"Verdana-Bold" fontSize:10.0f];
    mainMenu.positionType = CCPositionTypeNormalized;
    mainMenu.position = ccp(0.5f, 0.05f);
    mainMenu.color = [CCColor blackColor];
    [mainMenu setTarget:self selector:@selector(onReturnClicked:)];
    [self addChild:mainMenu];
    
    return self;
}

- (void)onReturnClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onButtonClicked:(id)sender
{
    CCButton *thisButton = sender;
    NSString *thisButtonTitle = thisButton.title;
    NSString *alertText = [[NSString alloc] init];
    if ([thisButtonTitle isEqualToString:@"Junior Ranger"])
    {
        alertText = @"Shoot a total of 50 gators in your lifetime.";
    } else if ([thisButtonTitle isEqualToString:@"Game Hunter"])
    {
        alertText = @"Shoot a total of 200 gators in your lifetime.";
    } else if ([thisButtonTitle isEqualToString:@"Gator Bane"])
    {
        alertText = @"Shoot a total of 500 gators in your lifetime.";
    } else if ([thisButtonTitle isEqualToString:@"King of all Gators"])
    {
        alertText = @"Reach the top spot on your local leaderboard.";
    } else if ([thisButtonTitle isEqualToString:@"Deadeye"])
    {
        alertText = @"Complete a round with 100% efficiency and a minimum of 36 gators shot.";
    } else if ([thisButtonTitle isEqualToString:@"Crikey!"])
    {
        alertText = @"Complete a game without shooting a single gator.";
    }
    UIAlertView *achievementDetail = [[UIAlertView alloc] initWithTitle:@"Details" message:alertText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    achievementDetail.alertViewStyle = UIAlertViewStyleDefault;
    [achievementDetail show];
}

@end
