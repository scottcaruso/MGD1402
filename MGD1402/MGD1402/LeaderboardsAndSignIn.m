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
-(void)pushNewScoreToLeaderboard:(NSString*)highScore userID:(NSString*)parseID efficiency:(NSString*)efficiency
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



@end
