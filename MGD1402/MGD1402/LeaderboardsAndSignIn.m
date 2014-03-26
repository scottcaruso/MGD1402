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

@synthesize arrayOfHighScoreNames,arrayOfHighScoreScores,arrayOfBulletScores;

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
    [query whereKey:@"user_name" equalTo:enteredName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSString *thisPassword = [object objectForKey:@"password"];
                NSNumber *thisScore = [object objectForKey:@"high_score"];
                NSNumber *thisEfficiency = [object objectForKey:@"efficiency"];
                bool achievementOneStatus = [object objectForKey:@"achievement_one"];
                bool achievementTwoStatus = [object objectForKey:@"achievement_two"];
                bool achievementThreeStatus = [object objectForKey:@"achievement_three"];
                bool achievementFourStatus = [object objectForKey:@"achievement_four"];
                bool achievementFiveStatus = [object objectForKey:@"achievement_five"];
                bool achievementSixStatus = [object objectForKey:@"achievement_six"];
                if ([thisPassword isEqualToString:enteredPassword])
                {
                    //Success!
                    NSUserDefaults *highScores = [NSUserDefaults standardUserDefaults];
                    [highScores setBool:NO forKey:@"IsGuestUser"];
                    [highScores setValue:object.objectId forKey:@"CurrentUserID"];
                    [highScores setValue:enteredName forKey:@"CurrentUser"];
                    [highScores setValue:thisScore forKey:@"CurrentUserHighScore"];
                    [highScores setValue:thisEfficiency forKey:@"CurrentUserEfficiency"];
                    [highScores setBool:achievementOneStatus forKey:@"AchievementOneStatus"];
                    [highScores setBool:achievementTwoStatus forKey:@"AchievementTwoStatus"];
                    [highScores setBool:achievementThreeStatus forKey:@"AchievementThreeStatus"];
                    [highScores setBool:achievementFourStatus forKey:@"AchievementFourStatus"];
                    [highScores setBool:achievementFiveStatus forKey:@"AchievementFiveStatus"];
                    [highScores setBool:achievementSixStatus forKey:@"AchievementSixStatus"];
                    [highScores synchronize];
                    UIAlertView *successfulLogin = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Login successful!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    successfulLogin.alertViewStyle = UIAlertViewStyleDefault;
                    successfulLogin.tag = 7;
                    [successfulLogin show];
                } else
                {
                    UIAlertView *incorrectEntry = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your username or password is incorrect. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    incorrectEntry.alertViewStyle = UIAlertViewStyleDefault;
                    incorrectEntry.tag = 5;
                    [incorrectEntry show];
                }
            }
        } else {
            UIAlertView *incorrectEntry = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your username or password is incorrect. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            incorrectEntry.alertViewStyle = UIAlertViewStyleDefault;
            incorrectEntry.tag = 5;
            [incorrectEntry show];
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
    [query whereKey:@"user_name" equalTo:enteredName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            if (objects.count == 0)
            {
                // Create the user account with the specified credentials.
                NSNumber *defaultNumber = [[NSNumber alloc] initWithInt:0];
                PFObject *newUser = [PFObject objectWithClassName:@"Leaderboards"];
                newUser[@"user_name"] = enteredName;
                newUser[@"password"] = enteredPassword;
                newUser[@"high_score"] = defaultNumber;
                newUser[@"efficiency"] = defaultNumber;
                newUser[@"achievement_one"] = [NSNumber numberWithBool:NO];
                newUser[@"achievement_two"] = [NSNumber numberWithBool:NO];
                newUser[@"achievement_three"] = [NSNumber numberWithBool:NO];
                newUser[@"achievement_four"] = [NSNumber numberWithBool:NO];
                newUser[@"achievement_five"] = [NSNumber numberWithBool:NO];
                newUser[@"achievement_six"] = [NSNumber numberWithBool:NO];
                [newUser saveInBackground];
                UIAlertView *successfullyCreated = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Username successfully created! Please log in." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                successfullyCreated.alertViewStyle = UIAlertViewStyleDefault;
                successfullyCreated.tag = 8;
                [successfullyCreated show];
            } else
            {
                UIAlertView *usernameExists = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Selected username already exists. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                usernameExists.alertViewStyle = UIAlertViewStyleDefault;
                usernameExists.tag = 6;
                [usernameExists show];
            }
            // The username already exists! Throw up an appropriate alert message.
        } else
        {
            UIAlertView *usernameExists = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error retrieiving username information." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            usernameExists.alertViewStyle = UIAlertViewStyleDefault;
            usernameExists.tag = 6;
            [usernameExists show];
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5)
    {
        NSLog(@"Incorrect Username/Password entry.");
    }
    if (alertView.tag == 6)
    {
        NSLog(@"Attempted to create a username that already exists.");
    }
    if (alertView.tag == 7)
    {
        [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                                   withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
    }
}
@end
