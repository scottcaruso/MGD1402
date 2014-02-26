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

    // Label - Title
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"High Scores" fontName:@"Monaco" fontSize:25.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor whiteColor];
    label.position = ccp(0.5f, 0.95f);
    [self addChild:label];
    
    // Label - Line One
    NSString *scoreStringOne = [[NSString alloc] initWithFormat:@"1. %@ -- %@",placeholderName,placeholderScore];
    CCLabelTTF *lineOne = [CCLabelTTF labelWithString:scoreStringOne fontName:@"Monaco" fontSize:10.0f];
    lineOne.positionType = CCPositionTypeNormalized;
    lineOne.color = [CCColor whiteColor];
    lineOne.position = ccp(0.5f, 0.7f);
    [self addChild:lineOne];
    
    // Label - Line Two
    NSString *scoreStringTwo = [[NSString alloc] initWithFormat:@"2. %@ -- %@",placeholderName,placeholderScore];
    CCLabelTTF *lineTwo = [CCLabelTTF labelWithString:scoreStringTwo fontName:@"Monaco" fontSize:10.0f];
    lineTwo.positionType = CCPositionTypeNormalized;
    lineTwo.color = [CCColor whiteColor];
    lineTwo.position = ccp(0.5f, 0.6f);
    [self addChild:lineTwo];
    
    // Label - Line Three
    NSString *scoreStringThree = [[NSString alloc] initWithFormat:@"3. %@ -- %@",placeholderName,placeholderScore];
    CCLabelTTF *lineThree = [CCLabelTTF labelWithString:scoreStringThree fontName:@"Monaco" fontSize:10.0f];
    lineThree.positionType = CCPositionTypeNormalized;
    lineThree.color = [CCColor whiteColor];
    lineThree.position = ccp(0.5f, 0.5f);
    [self addChild:lineThree];
    
    // Label - Line Four
    NSString *scoreStringFour = [[NSString alloc] initWithFormat:@"4. %@ -- %@",placeholderName,placeholderScore];
    CCLabelTTF *lineFour = [CCLabelTTF labelWithString:scoreStringFour fontName:@"Monaco" fontSize:10.0f];
    lineFour.positionType = CCPositionTypeNormalized;
    lineFour.color = [CCColor whiteColor];
    lineFour.position = ccp(0.5f, 0.4f);
    [self addChild:lineFour];
    
    // Label - Line Five
    NSString *scoreStringFive = [[NSString alloc] initWithFormat:@"5. %@ -- %@",placeholderName,placeholderScore];
    CCLabelTTF *lineFive = [CCLabelTTF labelWithString:scoreStringFive fontName:@"Monaco" fontSize:10.0f];
    lineFive.positionType = CCPositionTypeNormalized;
    lineFive.color = [CCColor whiteColor];
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

- (void)onReturnClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

@end
