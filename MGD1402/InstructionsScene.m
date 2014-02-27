//
//  InstructionsScene.m
//  MGD1402
//
//  Created by Scott Caruso on 2/24/14.
//  Copyright 2014 Scott Caruso. All rights reserved.
//

#import "InstructionsScene.h"


// -----------------------------------------------------------------------
#pragma mark - Instructions Scene
// -----------------------------------------------------------------------

@implementation InstructionsScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (InstructionsScene *)scene
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
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Instructions" fontName:@"Monaco" fontSize:25.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor blackColor];
    label.position = ccp(0.5f, 0.95f);
    [self addChild:label];
    
    // Label - Instructions line one
    CCLabelTTF *lineOne = [CCLabelTTF labelWithString:@"Gators will come from the left side of the screen at varying speeds and in varying positions." fontName:@"Monaco" fontSize:10.0f];
    lineOne.positionType = CCPositionTypeNormalized;
    lineOne.color = [CCColor blackColor];
    lineOne.position = ccp(0.5f, 0.7f);
    [self addChild:lineOne];
    
    // Label - Instructions line two
    CCLabelTTF *lineTwo = [CCLabelTTF labelWithString:@"Drag the hunter up and down the shoreline to position him for a shot." fontName:@"Monaco" fontSize:10.0f];
    lineTwo.positionType = CCPositionTypeNormalized;
    lineTwo.color = [CCColor blackColor];
    lineTwo.position = ccp(0.5f, 0.6f);
    [self addChild:lineTwo];
    
    // Label - Instructions line three
    CCLabelTTF *lineThree = [CCLabelTTF labelWithString:@"Tap anywhere else on the screen to fire a bullet." fontName:@"Monaco" fontSize:10.0f];
    lineThree.positionType = CCPositionTypeNormalized;
    lineThree.color = [CCColor blackColor];
    lineThree.position = ccp(0.5f, 0.5f);
    [self addChild:lineThree];
    
    // Label - Instructions line four
    CCLabelTTF *lineFour = [CCLabelTTF labelWithString:@"Tap the pause button to pause the game. Tap it again to unpause." fontName:@"Monaco" fontSize:10.0f];
    lineFour.positionType = CCPositionTypeNormalized;
    lineFour.color = [CCColor blackColor];
    lineFour.position = ccp(0.5f, 0.4f);
    [self addChild:lineFour];
    
    // Label - Instructions line five
    CCLabelTTF *lineFive = [CCLabelTTF labelWithString:@"Try to get on the high scores list!" fontName:@"Monaco" fontSize:10.0f];
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

// -----------------------------------------------------------------------
#pragma mark - Button Callback
// -----------------------------------------------------------------------

- (void)onReturnClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

@end
