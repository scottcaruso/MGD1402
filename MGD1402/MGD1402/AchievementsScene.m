//
//  AchievementsScene.m
//  MGD1402
//
//  Created by Scott Caruso on 3/25/14.
//  Copyright 2014 Scott Caruso. All rights reserved.
//

#import "AchievementsScene.h"


@implementation AchievementsScene
{
    bool achievementOneStatus;
    bool achievementTwoStatus;
    bool achievementThreeStatus;
    bool achievementFourStatus;
    bool achievementFiveStatus;
    bool achievementSixStatus;
    bool isGuest;
    
    NSString *oneStatusString;
    NSString *twoStatusString;
    NSString *threeStatusString;
    NSString *fourStatusString;
    NSString *fiveStatusString;
    NSString *sixStatusString;
}

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    isGuest = [defaults boolForKey:@"IsGuestUser"];
    achievementOneStatus = [defaults boolForKey:@"AchievementOneStatus"];
    achievementTwoStatus = [defaults boolForKey:@"AchievementTwoStatus"];
    achievementThreeStatus = [defaults boolForKey:@"AchievementThreeStatus"];
    achievementFourStatus = [defaults boolForKey:@"AchievementFourStatus"];
    achievementFiveStatus = [defaults boolForKey:@"AchievementFiveStatus"];
    achievementSixStatus = [defaults boolForKey:@"AchievementSixStatus"];
    
    oneStatusString = @"Locked";
    twoStatusString = @"Locked";
    threeStatusString = @"Locked";
    fourStatusString = @"Locked";
    fiveStatusString = @"Locked";
    sixStatusString = @"Locked";
    
    if (isGuest == true)
    {
        oneStatusString = @"N/A";
        twoStatusString = @"N/A";
        threeStatusString = @"N/A";
        fourStatusString = @"N/A";
        fiveStatusString = @"N/A";
        sixStatusString = @"N/A";
        UIAlertView *guestUser = [[UIAlertView alloc] initWithTitle:@"Guest" message:@"Guests cannot unlock achievements. Please sign in to view status." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        guestUser.alertViewStyle = UIAlertViewStyleDefault;
        [guestUser show];
    } else
    {
        if (achievementOneStatus == true)
        {
            oneStatusString = @"Unlocked";
        }
        if (achievementTwoStatus == true)
        {
            twoStatusString = @"Unlocked";
        }
        if (achievementThreeStatus == true)
        {
            threeStatusString = @"Unlocked";
        }
        if (achievementFourStatus == true)
        {
            fourStatusString = @"Unlocked";
        }
        if (achievementFiveStatus == true)
        {
            fiveStatusString = @"Unlocked";
        }
        if (achievementSixStatus == true)
        {
            sixStatusString = @"Unlocked";
        }
    }
    
    
    
    
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
    
    // Achievement 1 Status
    CCLabelTTF *achievementOneLabel = [CCLabelTTF labelWithString:oneStatusString fontName:@"Verdana-Bold" fontSize:10.0f];
    achievementOneLabel.positionType = CCPositionTypeNormalized;
    achievementOneLabel.position = ccp(0.75f, 0.7f);
    achievementOneLabel.color = [CCColor blackColor];
    [self addChild:achievementOneLabel];
    
    // Achievement 2 Status
    CCLabelTTF *achievementTwoLabel = [CCLabelTTF labelWithString:twoStatusString fontName:@"Verdana-Bold" fontSize:10.0f];
    achievementTwoLabel.positionType = CCPositionTypeNormalized;
    achievementTwoLabel.position = ccp(0.75f, 0.6f);
    achievementTwoLabel.color = [CCColor blackColor];
    [self addChild:achievementTwoLabel];
    
    // Achievement 3 Status
    CCLabelTTF *achievementThreeLabel = [CCLabelTTF labelWithString:threeStatusString fontName:@"Verdana-Bold" fontSize:10.0f];
    achievementThreeLabel.positionType = CCPositionTypeNormalized;
    achievementThreeLabel.position = ccp(0.75f, 0.5f);
    achievementThreeLabel.color = [CCColor blackColor];
    [self addChild:achievementThreeLabel];
    
    // Achievement 4 Status
    CCLabelTTF *achievementFourLabel = [CCLabelTTF labelWithString:fourStatusString fontName:@"Verdana-Bold" fontSize:10.0f];
    achievementFourLabel.positionType = CCPositionTypeNormalized;
    achievementFourLabel.position = ccp(0.75f, 0.4f);
    achievementFourLabel.color = [CCColor blackColor];
    [self addChild:achievementFourLabel];
    
    // Achievement 5 Status
    CCLabelTTF *achievementFiveLabel = [CCLabelTTF labelWithString:fiveStatusString fontName:@"Verdana-Bold" fontSize:10.0f];
    achievementFiveLabel.positionType = CCPositionTypeNormalized;
    achievementFiveLabel.position = ccp(0.75f, 0.3f);
    achievementFiveLabel.color = [CCColor blackColor];
    [self addChild:achievementFiveLabel];
    
    // Achievement 6 Status
    CCLabelTTF *achievementSixLabel = [CCLabelTTF labelWithString:sixStatusString fontName:@"Verdana-Bold" fontSize:10.0f];
    achievementSixLabel.positionType = CCPositionTypeNormalized;
    achievementSixLabel.position = ccp(0.75f, 0.2f);
    achievementSixLabel.color = [CCColor blackColor];
    [self addChild:achievementSixLabel];
    
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
