//
//  CreditsScene.m
//  MGD1402
//
//  Created by Scott Caruso on 2/24/14.
//  Copyright 2014 Scott Caruso. All rights reserved.
//

#import "CreditsScene.h"


// -----------------------------------------------------------------------
#pragma mark - Credits Scene
// -----------------------------------------------------------------------

@implementation CreditsScene
{
    NSMutableArray *arrayOfLines;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (CreditsScene *)scene
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
    
    arrayOfLines = [[NSMutableArray alloc] init];
    
    // Label - Title
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Credits" fontName:@"Monaco" fontSize:25.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor blackColor];
    [arrayOfLines addObject:label];
    
    // Label - Credits line one
    CCLabelTTF *lineOne = [CCLabelTTF labelWithString:@"Copyright 2014. All Rights Reserved." fontName:@"Monaco" fontSize:10.0f];
    lineOne.positionType = CCPositionTypeNormalized;
    lineOne.color = [CCColor blackColor];
    [arrayOfLines addObject:lineOne];
    
    // Label - Credits line two
    CCLabelTTF *lineTwo = [CCLabelTTF labelWithString:@"Engineering" fontName:@"Monaco" fontSize:14.0f];
    lineTwo.positionType = CCPositionTypeNormalized;
    lineTwo.color = [CCColor blackColor];
    [arrayOfLines addObject:lineTwo];
    
    // Label - Credits line three
    CCLabelTTF *lineThree = [CCLabelTTF labelWithString:@"Lead Programmer - Scott Caruso" fontName:@"Monaco" fontSize:10.0f];
    lineThree.positionType = CCPositionTypeNormalized;
    lineThree.color = [CCColor blackColor];
    [arrayOfLines addObject:lineThree];
    
    // Label - Credits line four
    CCLabelTTF *lineFour = [CCLabelTTF labelWithString:@"Design" fontName:@"Monaco" fontSize:14.0f];
    lineFour.positionType = CCPositionTypeNormalized;
    lineFour.color = [CCColor blackColor];
    [arrayOfLines addObject:lineFour];
    
    // Label - Credits line five
    CCLabelTTF *lineFive = [CCLabelTTF labelWithString:@"Lead Designer - Scott Caruso" fontName:@"Monaco" fontSize:10.0f];
    lineFive.positionType = CCPositionTypeNormalized;
    lineFive.color = [CCColor blackColor];
    [arrayOfLines addObject:lineFive];
    
    // Label - Credits line six
    CCLabelTTF *lineSix = [CCLabelTTF labelWithString:@"Art" fontName:@"Monaco" fontSize:14.0f];
    lineSix.positionType = CCPositionTypeNormalized;
    lineSix.color = [CCColor blackColor];
    [arrayOfLines addObject:lineSix];
    
    // Label - Credits line seven
    CCLabelTTF *lineSeven = [CCLabelTTF labelWithString:@"Alligator courtesy of frankthedm of enworld.org. http://img374.imageshack.us/img374/4184/whatacroccz4.png" fontName:@"Monaco" fontSize:10.0f];
    lineSeven.positionType = CCPositionTypeNormalized;
    lineSeven.color = [CCColor blackColor];
    [arrayOfLines addObject:lineSeven];
    
    // Label - Credits line eight
    CCLabelTTF *lineEight = [CCLabelTTF labelWithString:@"Hunter adapted from designs by malfore at http://malifore.deviantart.com/art/Hunter-Sprite-Sheet-359619593" fontName:@"Monaco" fontSize:10.0f];
    lineEight.positionType = CCPositionTypeNormalized;
    lineEight.color = [CCColor blackColor];
    [arrayOfLines addObject:lineEight];
    
    // Label - Credits line nine
    CCLabelTTF *lineNine = [CCLabelTTF labelWithString:@"Bullet created by Scott Caruso." fontName:@"Monaco" fontSize:10.0f];
    lineNine.positionType = CCPositionTypeNormalized;
    lineNine.color = [CCColor blackColor];
    [arrayOfLines addObject:lineNine];
    
    
    // Label - Credits line ten
    CCLabelTTF *lineTen = [CCLabelTTF labelWithString:@"Swamp created by Scott Caruso." fontName:@"Monaco" fontSize:10.0f];
    lineTen.positionType = CCPositionTypeNormalized;
    lineTen.color = [CCColor blackColor];
    [arrayOfLines addObject:lineTen];
    
    // Label - Credits line eleven
    CCLabelTTF *lineEleven = [CCLabelTTF labelWithString:@"Audio" fontName:@"Monaco" fontSize:14.0f];
    lineEleven.positionType = CCPositionTypeNormalized;
    lineEleven.color = [CCColor blackColor];
    [arrayOfLines addObject:lineEleven];
    
    // Label - Credits line twelve
    CCLabelTTF *lineTwelve = [CCLabelTTF labelWithString:@"Swamp ambience courtesy of LokiF. http://opengameart.org/content/swamp-environment-audio" fontName:@"Monaco" fontSize:10.0f];
    lineTwelve.positionType = CCPositionTypeNormalized;
    lineTwelve.color = [CCColor blackColor];
    [arrayOfLines addObject:lineTwelve];
    
    // Label - Credits line thirteen
    CCLabelTTF *lineThirteen = [CCLabelTTF labelWithString:@"Shotgun courtesy of Mike Koenig. Soundbible.com." fontName:@"Monaco" fontSize:10.0f];
    lineThirteen.positionType = CCPositionTypeNormalized;
    lineThirteen.color = [CCColor blackColor];
    [arrayOfLines addObject:lineThirteen];
    
    for (int x = 0; x < [arrayOfLines count]; x++)
    {
        CCLabelTTF *thisLabel = [arrayOfLines objectAtIndex:x];
        CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:11 position:ccp(0.5f, 2.0f)];
        thisLabel.position= ccp(0.5f, -0.1f);
        float delayDuration = x*0.5f;
        CCActionDelay *delay = [CCActionDelay actionWithDuration:delayDuration];
        [self addChild:thisLabel];
        [thisLabel runAction:[CCActionSequence actionWithArray:@[delay,actionMove]]];
    }
    
    /*
    [lineTwo runAction:actionMove];
    [lineThree runAction:actionMove];
    [lineFour runAction:actionMove];
    [lineFive runAction:actionMove];
    [lineSix runAction:actionMove];
    [lineSeven runAction:actionMove];
    [lineEight runAction:actionMove];
    [lineNine runAction:actionMove];
    [lineTen runAction:actionMove];
    [lineEleven runAction:actionMove];
    [lineTwelve runAction:actionMove];
    [lineThirteen runAction:actionMove];*/

    
    // Main Menu
    CCButton *mainMenu = [CCButton buttonWithTitle:@"Return To Main" fontName:@"Verdana-Bold" fontSize:10.0f];
    mainMenu.positionType = CCPositionTypeNormalized;
    mainMenu.position = ccp(0.1f, 0.95f);
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
