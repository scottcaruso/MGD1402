//
//  MainGameScene.h
//  MGD1402
//
//  Created by Scott Caruso on 2/3/14.
//  Copyright Scott Caruso 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "CCAnimation.h"
#import <Social/Social.h>
#import "LeaderboardsAndSignIn.h"

// -----------------------------------------------------------------------

/**
 *  The main scene
 */
@interface MainGameScene : CCScene <CCPhysicsCollisionDelegate,UIAlertViewDelegate>

// -----------------------------------------------------------------------

+ (MainGameScene *)scene;
- (id)init;
- (void)getHighScores;
-(void)updateHighScores:(float)rawScore efficiency:(float)efficiency;

// -----------------------------------------------------------------------
@end