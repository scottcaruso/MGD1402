//
//  HighScoresScene.m
//  MGD1402
//
//  Created by Scott Caruso on 2/24/14.
//  Copyright 2014 Scott Caruso. All rights reserved.
//

#import "HighScoresScene.h"


// -----------------------------------------------------------------------
#pragma mark - Credits Scene
// -----------------------------------------------------------------------

@implementation HighScoresScene
{
    NSString *placeholderName;
    NSString *placeholderScore;
    
    NSMutableArray *arrayOfHighScoreNames;
    NSMutableArray *arrayOfHighScoreScores;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HighScoresScene *)scene
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
    
    [self getHighScores];

    // Label - Title
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"High Scores" fontName:@"Monaco" fontSize:25.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor blackColor];
    label.position = ccp(0.5f, 0.95f);
    [self addChild:label];
    
    // Label - Line One
    NSString *scoreStringOne = [[NSString alloc] initWithFormat:@"1. %@ -- %@",[arrayOfHighScoreNames objectAtIndex:0],[arrayOfHighScoreScores objectAtIndex:0]];
    CCLabelTTF *lineOne = [CCLabelTTF labelWithString:scoreStringOne fontName:@"Monaco" fontSize:10.0f];
    lineOne.positionType = CCPositionTypeNormalized;
    lineOne.color = [CCColor blackColor];
    lineOne.position = ccp(0.5f, 0.7f);
    [self addChild:lineOne];
    
    // Label - Line Two
    NSString *scoreStringTwo = [[NSString alloc] initWithFormat:@"2. %@ -- %@",[arrayOfHighScoreNames objectAtIndex:1],[arrayOfHighScoreScores objectAtIndex:1]];
    CCLabelTTF *lineTwo = [CCLabelTTF labelWithString:scoreStringTwo fontName:@"Monaco" fontSize:10.0f];
    lineTwo.positionType = CCPositionTypeNormalized;
    lineTwo.color = [CCColor blackColor];
    lineTwo.position = ccp(0.5f, 0.6f);
    [self addChild:lineTwo];
    
    // Label - Line Three
    NSString *scoreStringThree = [[NSString alloc] initWithFormat:@"3. %@ -- %@",[arrayOfHighScoreNames objectAtIndex:2],[arrayOfHighScoreScores objectAtIndex:2]];
    CCLabelTTF *lineThree = [CCLabelTTF labelWithString:scoreStringThree fontName:@"Monaco" fontSize:10.0f];
    lineThree.positionType = CCPositionTypeNormalized;
    lineThree.color = [CCColor blackColor];
    lineThree.position = ccp(0.5f, 0.5f);
    [self addChild:lineThree];
    
    // Label - Line Four
    NSString *scoreStringFour = [[NSString alloc] initWithFormat:@"4. %@ -- %@",[arrayOfHighScoreNames objectAtIndex:3],[arrayOfHighScoreScores objectAtIndex:3]];
    CCLabelTTF *lineFour = [CCLabelTTF labelWithString:scoreStringFour fontName:@"Monaco" fontSize:10.0f];
    lineFour.positionType = CCPositionTypeNormalized;
    lineFour.color = [CCColor blackColor];
    lineFour.position = ccp(0.5f, 0.4f);
    [self addChild:lineFour];
    
    // Label - Line Five
    NSString *scoreStringFive = [[NSString alloc] initWithFormat:@"5. %@ -- %@",[arrayOfHighScoreNames objectAtIndex:4],[arrayOfHighScoreScores objectAtIndex:4]];
    CCLabelTTF *lineFive = [CCLabelTTF labelWithString:scoreStringFive fontName:@"Monaco" fontSize:10.0f];
    lineFive.positionType = CCPositionTypeNormalized;
    lineFive.color = [CCColor blackColor];
    lineFive.position = ccp(0.5f, 0.3f);
    [self addChild:lineFive];
    
    // Main Menu
    CCButton *mainMenu = [CCButton buttonWithTitle:@"Return To Main" fontName:@"Verdana-Bold" fontSize:10.0f];
    mainMenu.positionType = CCPositionTypeNormalized;
    mainMenu.position = ccp(0.5f, 0.05f);
    [mainMenu setTarget:self selector:@selector(onReturnClicked:)];
    [self addChild:mainMenu];
    
    return self;
}

-(void)getHighScores
{
    arrayOfHighScoreNames = [[NSMutableArray alloc] init];
    arrayOfHighScoreScores = [[NSMutableArray alloc] init];
    NSUserDefaults *highScores = [NSUserDefaults standardUserDefaults];
    if ([highScores objectForKey:@"Names"] == nil)
    {
        [arrayOfHighScoreNames addObject:@"Scott"];
        [arrayOfHighScoreNames addObject:@"Doge"];
        [arrayOfHighScoreNames addObject:@"Kelly"];
        [arrayOfHighScoreNames addObject:@"Ben"];
        [arrayOfHighScoreNames addObject:@"Jess"];
        
        [arrayOfHighScoreScores addObject:@"50"];
        [arrayOfHighScoreScores addObject:@"40"];
        [arrayOfHighScoreScores addObject:@"30"];
        [arrayOfHighScoreScores addObject:@"20"];
        [arrayOfHighScoreScores addObject:@"10"];
    } else
    {
        arrayOfHighScoreNames = [highScores objectForKey:@"Names"];
        arrayOfHighScoreScores = [highScores objectForKey:@"Scores"];
    }
}

- (void)onReturnClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

@end
