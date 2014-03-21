//
//  LeaderboardsAndSignIn.h
//  MGD1402
//
//  Created by Scott Caruso on 3/17/14.
//  Copyright (c) 2014 Scott Caruso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "IntroScene.h"



@interface LeaderboardsAndSignIn : NSObject <UIAlertViewDelegate>
{

}

@property (nonatomic) NSMutableArray *arrayOfHighScoreNames;
@property (nonatomic) NSMutableArray *arrayOfHighScoreScores;
@property (nonatomic) NSMutableArray *arrayOfBulletScores;

-(void)logUserIn:(NSString*)enteredName password:(NSString*)enteredPassword;
-(void)pushNewScoreToLeaderboard:(NSNumber*)highScore userID:(NSString*)parseID efficiency:(NSNumber*)efficiency;
-(void)createNewAccount:(NSString*)enteredName password:(NSString*)enteredPassword;


@end
