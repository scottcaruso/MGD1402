//
//  LeaderboardScene.m
//  MGD1402
//
//  Created by Scott Caruso on 3/20/14.
//  Copyright 2014 Scott Caruso. All rights reserved.
//

#import "LeaderboardScene.h"


@implementation LeaderboardScene
{
    NSString *placeholderName;
    NSString *placeholderScore;
    
    NSMutableArray *arrayOfHighScoreNames;
    NSMutableArray *arrayOfHighScoreScores;
    NSMutableArray *arrayOfBulletScores;

    NSInteger day;
    NSInteger month;
    NSInteger year;
    
}

+ (LeaderboardScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    arrayOfHighScoreNames = [[NSMutableArray alloc] init];
    arrayOfHighScoreScores = [[NSMutableArray alloc] init];
    arrayOfBulletScores = [[NSMutableArray alloc] init];
    
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
    
    [self retrieveHighScores:-10000000000000000];
    
    // Label - Title
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Global Leaderboard" fontName:@"Monaco" fontSize:25.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor blackColor];
    label.position = ccp(0.5f, 0.95f);
    [self addChild:label];
    
    // Main Menu
    CCButton *mainMenu = [CCButton buttonWithTitle:@"Return To Main" fontName:@"Verdana-Bold" fontSize:10.0f];
    mainMenu.positionType = CCPositionTypeNormalized;
    mainMenu.position = ccp(0.5f, 0.05f);
    mainMenu.color = [CCColor blackColor];
    [mainMenu setTarget:self selector:@selector(onReturnClicked:)];
    [self addChild:mainMenu];
    
    return self;
}

//THERE IS A KNOWN BUG HERE THAT IF THERE IS NO DATA IN PARSE, IT WILL COME UP AS NULL.
-(void)retrieveHighScores:(int)numberOfSeconds
{
    NSDate *dateQuery = [NSDate dateWithTimeInterval:numberOfSeconds sinceDate:[NSDate date]];
    PFQuery *query = [PFQuery queryWithClassName:@"Leaderboards"];
    [query whereKeyExists:@"user_name"];
    [query whereKey:@"createdAt" greaterThan:dateQuery];
    [query addDescendingOrder:@"high_score"];
    query.limit = 5;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Grab the user name, score, efficiency
            for (PFObject *object in objects) {
                NSString *thisName = [object objectForKey:@"user_name"];
                NSNumber *thisScore = [object objectForKey:@"high_score"];
                NSNumber *thisEfficiency = [object objectForKey:@"efficiency"];
                float convertedEfficiency = [thisEfficiency floatValue]*(float)100;
                NSNumberFormatter *formatter =  [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:kCFNumberFormatterDecimalStyle];
                [formatter setMaximumFractionDigits:1];
                NSString *ratioString = [formatter stringFromNumber:[NSNumber numberWithFloat:convertedEfficiency]];
                NSString *convertedString = [[NSString alloc] initWithFormat:@"%@%%",ratioString];
                [arrayOfHighScoreNames addObject:thisName];
                [arrayOfHighScoreScores addObject:thisScore];
                [arrayOfBulletScores addObject:convertedString];
            }
            
            // Label - Line One
            NSString *scoreStringOne = [[NSString alloc] initWithFormat:@"1. %@ -- %@ -- %@",[arrayOfHighScoreNames objectAtIndex:0],[arrayOfHighScoreScores objectAtIndex:0],[arrayOfBulletScores objectAtIndex:0]];
            CCLabelTTF *lineOne = [CCLabelTTF labelWithString:scoreStringOne fontName:@"Monaco" fontSize:10.0f];
            lineOne.positionType = CCPositionTypeNormalized;
            lineOne.color = [CCColor blackColor];
            lineOne.position = ccp(0.5f, 0.7f);
            [self addChild:lineOne];
            
            // Label - Line Two
            NSString *scoreStringTwo = [[NSString alloc] initWithFormat:@"2. %@ -- %@ -- %@",[arrayOfHighScoreNames objectAtIndex:1],[arrayOfHighScoreScores objectAtIndex:1],[arrayOfBulletScores objectAtIndex:1]];
            CCLabelTTF *lineTwo = [CCLabelTTF labelWithString:scoreStringTwo fontName:@"Monaco" fontSize:10.0f];
            lineTwo.positionType = CCPositionTypeNormalized;
            lineTwo.color = [CCColor blackColor];
            lineTwo.position = ccp(0.5f, 0.6f);
            [self addChild:lineTwo];
            
            // Label - Line Three
            NSString *scoreStringThree = [[NSString alloc] initWithFormat:@"3. %@ -- %@ -- %@",[arrayOfHighScoreNames objectAtIndex:2],[arrayOfHighScoreScores objectAtIndex:2],[arrayOfBulletScores objectAtIndex:2]];
            CCLabelTTF *lineThree = [CCLabelTTF labelWithString:scoreStringThree fontName:@"Monaco" fontSize:10.0f];
            lineThree.positionType = CCPositionTypeNormalized;
            lineThree.color = [CCColor blackColor];
            lineThree.position = ccp(0.5f, 0.5f);
            [self addChild:lineThree];
            
            // Label - Line Four
            NSString *scoreStringFour = [[NSString alloc] initWithFormat:@"4. %@ -- %@ -- %@",[arrayOfHighScoreNames objectAtIndex:3],[arrayOfHighScoreScores objectAtIndex:3],[arrayOfBulletScores objectAtIndex:3]];
            CCLabelTTF *lineFour = [CCLabelTTF labelWithString:scoreStringFour fontName:@"Monaco" fontSize:10.0f];
            lineFour.positionType = CCPositionTypeNormalized;
            lineFour.color = [CCColor blackColor];
            lineFour.position = ccp(0.5f, 0.4f);
            [self addChild:lineFour];
            
            // Label - Line Five
            NSString *scoreStringFive = [[NSString alloc] initWithFormat:@"5. %@ -- %@ -- %@",[arrayOfHighScoreNames objectAtIndex:4],[arrayOfHighScoreScores objectAtIndex:4],[arrayOfBulletScores objectAtIndex:4]];
            CCLabelTTF *lineFive = [CCLabelTTF labelWithString:scoreStringFive fontName:@"Monaco" fontSize:10.0f];
            lineFive.positionType = CCPositionTypeNormalized;
            lineFive.color = [CCColor blackColor];
            lineFive.position = ccp(0.5f, 0.3f);
            [self addChild:lineFive];
            
            // Overall Leaderboard
            CCButton *overallLeaders = [CCButton buttonWithTitle:@"Overall Leaders" fontName:@"Verdana-Bold" fontSize:16.0f];
            overallLeaders.positionType = CCPositionTypeNormalized;
            overallLeaders.position = ccp(0.2f, 0.75f);
            overallLeaders.color = [CCColor blackColor];
            [overallLeaders setTarget:self selector:@selector(onOverallClicked:)];
            [self addChild:overallLeaders];
            
            // Daily Leaderboard
            CCButton *dailyLeaders = [CCButton buttonWithTitle:@"Daily Leaders" fontName:@"Verdana-Bold" fontSize:16.0f];
            dailyLeaders.positionType = CCPositionTypeNormalized;
            dailyLeaders.position = ccp(0.2f, 0.5f);
            dailyLeaders.color = [CCColor blackColor];
            [dailyLeaders setTarget:self selector:@selector(onDailyClicked:)];
            [self addChild:dailyLeaders];
            
            // Monthly Leaderboard
            CCButton *monthlyLeaders = [CCButton buttonWithTitle:@"Monthly Leaders" fontName:@"Verdana-Bold" fontSize:16.0f];
            monthlyLeaders.positionType = CCPositionTypeNormalized;
            monthlyLeaders.position = ccp(0.2f, 0.25f);
            monthlyLeaders.color = [CCColor blackColor];
            [monthlyLeaders setTarget:self selector:@selector(onMonthlyClicked:)];
            [self addChild:monthlyLeaders];
            
            // Social connect
            CCButton *tweetOut = [CCButton buttonWithTitle:@"Social Connect" fontName:@"Verdana-Bold" fontSize:16.0f];
            tweetOut.positionType = CCPositionTypeNormalized;
            tweetOut.position = ccp(0.8f, 0.5f);
            tweetOut.color = [CCColor blackColor];
            [tweetOut setTarget:self selector:@selector(sendTweet:)];
            [self addChild:tweetOut];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//Twitter functions are broken. The code below throws up a linker error when active and I am unable to address it in the time provided.
-(void)sendTweet:(id)sender
 {
     UIAlertView *twitterBroken = [[UIAlertView alloc] initWithTitle:@"Disabled" message:@"Twitter integration is undergoing maintenance. Sorry for the inconvenience." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
     twitterBroken.alertViewStyle = UIAlertViewStyleDefault;
     [twitterBroken show];
     /*SLComposeViewController *postTweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
     NSString *userName = [arrayOfHighScoreNames objectAtIndex:0];
     NSString *userScore = [arrayOfHighScoreScores objectAtIndex:0];

     if (postTweet != nil)
     {
         NSString *tweet= [NSString stringWithFormat:@"%@ has the highest score on Gator Gallery at %@. Can you beat that? #GottaGetDatGator",userName,userScore];
         [postTweet setInitialText:tweet];
         [[CCDirector sharedDirector] presentViewController:postTweet animated:true completion:nil];
     }*/
 }

-(void)onOverallClicked:(id)sender
{
    [self retrieveHighScores:-10000000000000000];
}

-(void)onMonthlyClicked:(id)sender
{
    [self retrieveHighScores:-2592000];
}

-(void)onDailyClicked:(id)sender
{
    [self retrieveHighScores:-86400];
}

- (void)onReturnClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

@end
