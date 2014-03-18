//
//  LeaderboardsAndSignIn.m
//  MGD1402
//
//  Created by Scott Caruso on 3/17/14.
//  Copyright (c) 2014 Scott Caruso. All rights reserved.
//

#import "LeaderboardsAndSignIn.h"

@implementation LeaderboardsAndSignIn
{

}

-(id)init
{
    arrayOfHighScoreNames = [[NSMutableArray alloc] init];
    arrayOfHighScoreScores = [[NSMutableArray alloc] init];
    arrayOfBulletScores = [[NSMutableArray alloc] init];
    return self;
}

-(void)logUserIn:(NSString*)enteredName password:(NSString*)enteredPassword
{
    PFQuery *query = [PFQuery queryWithClassName:@"Leaderboards"];
    [query whereKey:@"playerName" equalTo:enteredName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSString *thisPassword = [object objectForKey:@"password"];
                if ([thisPassword isEqualToString:enteredPassword])
                {
                    //Success!
                } else
                {
                    //Failure!
                }
            }
        } else {
            //Throw up the Username not found error.
        }
    }];
}

//This will take the new high score, the user's efficiency rating for that high score, and the ParseID and push the new score to the cloud.
-(void)pushNewScoreToLeaderboard:(NSNumber*)highScore userID:(NSString*)parseID efficiency:(NSNumber*)efficiency
{
    PFQuery *query = [PFQuery queryWithClassName:@"Leaderboards"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:parseID block:^(PFObject *thisUser, NSError *error) {
        
        thisUser[@"high_score"] = highScore;
        thisUser[@"efficiency"] = efficiency;
        [thisUser saveInBackground];
    }];
}

-(void)createNewAccount:(NSString*)enteredName password:(NSString*)enteredPassword
{
    PFQuery *query = [PFQuery queryWithClassName:@"Leaderboards"];
    [query whereKey:@"playerName" equalTo:enteredName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // The username already exists! Throw up an appropriate alert message.
        } else
        {
            // Create the user account with the specified credentials.
        }
    }];
}

-(void)retrieveHighScores
{
    NSMutableArray *arrayOfData = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
    [query addDescendingOrder:@"score"];
    query.limit = 5;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Grab the user name, score, efficiency
            for (PFObject *object in objects) {
                NSString *thisName = [object objectForKey:@"user_name"];
                NSNumber *thisScore = [object objectForKey:@"high_score"];
                NSNumber *thisEfficiency = [object objectForKey:@"efficiency"];
                [arrayOfHighScoreNames addObject:thisName];
                [arrayOfHighScoreScores addObject:thisScore];
                [arrayOfBulletScores addObject:thisEfficiency];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


@end
