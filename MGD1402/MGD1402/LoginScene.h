//
//  LoginScene.h
//  MGD1402
//
//  Created by Scott Caruso on 3/19/14.
//  Copyright 2014 Scott Caruso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "LeaderboardsAndSignIn.h"

@interface LoginScene : CCScene <UIAlertViewDelegate> {
    
}

+ (LoginScene *)scene;
- (id)init;

@end
