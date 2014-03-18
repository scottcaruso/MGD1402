//
//  LeaderboardsAndSignIn.h
//  MGD1402
//
//  Created by Scott Caruso on 3/17/14.
//  Copyright (c) 2014 Scott Caruso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface LeaderboardsAndSignIn : NSObject
{
    NSMutableArray *arrayOfHighScoreNames;
    NSMutableArray *arrayOfHighScoreScores;
    NSMutableArray *arrayOfBulletScores;
}

@end
