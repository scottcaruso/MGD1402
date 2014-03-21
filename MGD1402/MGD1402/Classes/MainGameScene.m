//
//  MainGameScene.m
//  MGD1402
//
//  Created by Scott Caruso on 2/3/14.
//  Copyright Scott Caruso 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "MainGameScene.h"
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - MainGameScene
// -----------------------------------------------------------------------

@implementation MainGameScene
{
    CCSprite *_hunter;
    CCSprite *_gator;
    CCSprite *_bullet;
    CCSprite *background;
    CCSprite *physicsWallForShore;
    CCSprite *pauseButton;
    CCPhysicsNode *_physics;
    CCAnimation *hitAnimation;
    NSMutableArray *arrayOfGatorSprites;
    NSMutableArray *arrayOfHitFrames;
    int scoreInt;
    int bulletsFired;
    bool gameOver;
    bool pauseState;
    CCLabelTTF *score;
    CCLabelTTF *bullets;
    CCLabelTTF *roundEnd;
    CCLabelTTF *nextRound;
    CGSize winSize;
    CGSize winSizeInPoints;
    NSString *ratioString;
    NSString *scoreString;
    bool areWeAGuest;
    NSString *currentUserID;
    NSString *currentUserName;
    NSNumber *topScore;
    NSNumber *userEfficiency;
    
    //These arrays hold the saved high score data.
    NSMutableArray *arrayOfHighScoreNames;
    NSMutableArray *arrayOfHighScoreScores;
    NSMutableArray *arrayOfBulletScores;
    
    int currentRound;
    int gatorsFired;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (MainGameScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (!self) return(nil);
    
    //Initialize some screen-wide variables.
    winSize = [[CCDirector sharedDirector] viewSizeInPixels];
    winSizeInPoints = [[CCDirector sharedDirector] viewSize];
    arrayOfGatorSprites = [[NSMutableArray alloc] init];
    
    scoreInt = 0; //Set default score
    bulletsFired = 0; //Set bullets fired
    gameOver = false;
    pauseState = false;
    currentRound = 1;
    gatorsFired = 0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    areWeAGuest = [defaults boolForKey:@"IsGuestUser"];
    currentUserID = [defaults objectForKey:@"CurrentUserID"];
    currentUserName = [defaults objectForKey:@"CurrentUser"];
    topScore = [defaults objectForKey:@"CurrentUserHighScore"];
    userEfficiency = [defaults objectForKey:@"CurrentUserEfficiency"];
    
    //Fetch the highscores for post-match.
    [self getHighScores];
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    //Enable background sound effect
    [[OALSimpleAudio sharedInstance] playBg:@"swamp.caf" loop:YES];
    
    //Schedule timer checks.
    [self schedule:@selector(tick:) interval:1.0];
    [self schedule:@selector(checkForEnd:) interval:0.1];
    
    //Select the correct background image
    if (winSize.height == 1536)
    {
        background = [CCSprite spriteWithImageNamed:@"swamp_background@2x~iPad.png"];
    } else
    {
        background = [CCSprite spriteWithImageNamed:@"swamp_background-568h@2x.png"];
    }
    background.positionType = CCPositionTypeNormalized;
    background.position = ccp(0.5f,0.5f);
    [self addChild:background];
    
    //Score display
    [self updateScore];
    [self updateBullets];
    
    _physics = [CCPhysicsNode node];
    _physics.gravity = ccp(0,0);
    _physics.debugDraw = NO; //Set to yes to see bounding boxes on objects
    _physics.collisionDelegate = self;
    [self addChild:_physics];
    
    _hunter = [CCSprite spriteWithImageNamed:@"hunter.png"];
    if (winSize.height == 1536)
    {
        [_hunter setScale:2.25f];
    }
    _hunter.position  = ccp(winSizeInPoints.width*.88,50);
    [self addChild:_hunter];
    
    pauseButton = [CCSprite spriteWithImageNamed:@"pause.png"];
    pauseButton.position = ccp(winSizeInPoints.width*.27,winSizeInPoints.height*.92);
    [self addChild:pauseButton];
    
    //Load the spritesheet for the hit animation.
    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"hit_text_sheet_default.png"];
    [self addChild:batchNode];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hit_text_sheet_default.plist"];
    
    //Gather the list of frames for the hit animation
    arrayOfHitFrames = [[NSMutableArray alloc] init];
    for (int x=0; x<=5; x++) {
        [arrayOfHitFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"hit%d.png",x]]];
    }
    hitAnimation = [CCAnimation animationWithSpriteFrames:arrayOfHitFrames delay:0.1f];
    
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Function of creating and "animating" the gators
// -----------------------------------------------------------------------

-(void)goGators
{
    _gator = [CCSprite spriteWithImageNamed:@"gator.png"];
    if (winSize.height == 1536)
    {
        [_gator setScale:2.25f];
    }
    // Determine where to spawn the monster along the Y axis
    int minY = _gator.contentSize.height + 250;
    int maxY = winSize.height;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY);
    _gator.position  = ccp(-50,actualY);
    _gator.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _gator.contentSize} cornerRadius:0];
    _gator.physicsBody.collisionGroup = @"gatorGroup";
    _gator.physicsBody.collisionType  = @"gatorCollision";
    [arrayOfGatorSprites addObject:_gator];
    [_physics addChild:_gator];
    [self moveGator:_gator yLoc:actualY roundNumber:currentRound];
    
}

-(void)moveGator:(CCSprite*)gator yLoc:(int)yLocation roundNumber:(int)round
{
    int minDuration = 6;
    int maxDuration = 7;
    if (round <= 5)
    {
        minDuration = minDuration - (round-1);
        maxDuration = maxDuration - (round-1);
    } else
    {
        minDuration = 1;
        maxDuration = 2;
    }
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:actualDuration position:ccp(winSizeInPoints.width*1.1, yLocation)];
    [gator runAction:[CCActionSequence actions:actionMove, nil, nil]];
}

// -----------------------------------------------------------------------
#pragma mark - Timer
// ----------------------------------------------------------------------

-(void)tick:(CCTime)dt
{
    if (gameOver == false)
    {
        if (gatorsFired == 1)
        {
            [self removeChild:roundEnd];
            [self removeChild:nextRound];
        }
        if (gatorsFired > 0 && gatorsFired < 10)
        {
            [self goGators];
        }
        if (gatorsFired < 10)
        {
            gatorsFired++;
        }
        if (gatorsFired >= 10 && arrayOfGatorSprites.count == 0)
        {
            [self doRoundEnd];
        }
    } else {
        // Reset button
        [self unschedule:@selector(tick:)];
    }
}

//Check if the game ending conditions have been met.
-(void)checkForEnd:(CCTime)dt
{
    if (arrayOfGatorSprites.count > 0)
    {
        for (CCSprite *thisGator in arrayOfGatorSprites)
        {
            if(thisGator.position.x > winSizeInPoints.width*.8f) {
                //Stop the timers
                [self unschedule:@selector(checkForEnd:)];
                [self unschedule:@selector(tick:)];
                //Set the game over variable
                gameOver = true;
                //Check to see if the score is a high score
                //float adjustedScore = (float)scoreInt * ((float)scoreInt/(float)bulletsFired);
                [self updateHighScores:(float)scoreInt efficiency:((float)scoreInt/(float)bulletsFired)];
                for (CCSprite *thisGator in arrayOfGatorSprites)
                {
                    if(thisGator.position.x > 0)
                    {
                        [thisGator removeFromParent];
                    }
                }
            }
        }
    }
}


// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    [super onEnter];
}

// -----------------------------------------------------------------------

- (void)onExit
{
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touches withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touches locationInNode:self];
    
    //Hunter rect
    CGRect rectHunt = CGRectMake(_hunter.position.x-(_hunter.contentSize.width/2), _hunter.position.y-(_hunter.contentSize.height/2), _hunter.contentSize.width, _hunter.contentSize.height);
    
    //Pause rect
    CGRect rectPause = CGRectMake(pauseButton.position.x-(pauseButton.contentSize.width/2), pauseButton.position.y-(pauseButton.contentSize.height/2), pauseButton.contentSize.width, pauseButton.contentSize.height);
    
    int     bulletX   =  0;
    int     bulletY   = _hunter.position.y;
    CGPoint targetPosition = ccp(bulletX,bulletY);
    
    if (CGRectContainsPoint(rectHunt, touchLoc)) {
        //Do nothing
    } else if (CGRectContainsPoint(rectPause, touchLoc))
    {
        if (pauseState == false)
        {
            for(CCSprite *sprite in [self children])
            {
                [[CCDirector sharedDirector] pause];
            }
            pauseState = true;
        } else
        {
            for(CCSprite *sprite in [self children])
            {
                [[CCDirector sharedDirector] resume];
            }
            pauseState = false;
        }
    } else {
        if (pauseState == false)
        {
            _bullet = [CCSprite spriteWithImageNamed:@"bullet.png"];
            _bullet.position  = ccp(winSizeInPoints.width*.78,bulletY);
            _bullet.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _bullet.contentSize} cornerRadius:0];
            _bullet.physicsBody.collisionGroup = @"bulletGroup";
            _bullet.physicsBody.collisionType = @"bulletCollision";
            [_physics addChild:_bullet];
            [[OALSimpleAudio sharedInstance] playEffect:@"shotgun.caf"];
            bulletsFired++;
            [bullets removeFromParent];
            [self updateBullets];
            CCActionMoveTo *actionMove   = [CCActionMoveTo actionWithDuration:1.5f position:targetPosition];
            CCActionRemove *actionRemove = [CCActionRemove action];
            [_bullet runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
        }
    }
}

//  -----------------------------------------------------------------------
#pragma mark - Collision
//  -----------------------------------------------------------------------

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair gatorCollision:(CCNode *)gator bulletCollision:(CCNode *)projectile {
    CGPoint collisionPoint = projectile.positionInPoints;
    [self onHitAnimation:collisionPoint];
    [gator removeFromParent];
    [projectile removeFromParent];
    scoreInt++;
    [score removeFromParent];
    [self updateScore];
    [arrayOfGatorSprites removeObject:gator];
    return YES;
}

- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGPoint retval = newPos;
    retval.x = winSizeInPoints.width*.88;
    return retval;
}

- (void)panForTranslation:(CGPoint)translation {
    if (_hunter) {
        CGPoint newPos = ccpAdd(_hunter.position, translation);
        _hunter.position = [self boundLayerPos:newPos];
    } else {
       //Do nothing
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    if (pauseState == false)
        {
        //Hunter rect
        CGRect rectHunt = CGRectMake(_hunter.position.x-(_hunter.contentSize.width/2), _hunter.position.y-(_hunter.contentSize.height/2), _hunter.contentSize.width, _hunter.contentSize.height);
        
        if (CGRectContainsPoint(rectHunt, touchLoc)) {
            
            CGPoint touchLocation = [self convertToNodeSpace:touch.locationInWorld];
            
            CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
            oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
            oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
            
            CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
            [self panForTranslation:translation];
        } else {
            //Do nothing
        }
    }
}

-(void)updateScore
{
    NSString *newScoreString = [[NSString alloc] initWithFormat:@"Score: %i",scoreInt];
    score = [CCLabelTTF labelWithString:newScoreString fontName:@"Verdana-Bold" fontSize:14.0f];
    score.positionType = CCPositionTypeNormalized;
    score.position = ccp(0.1f,0.95f);
    [self addChild:score];
}

-(void)updateBullets
{
    NSString *bulletString = [[NSString alloc] initWithFormat:@"Bullets: %i",bulletsFired];
    bullets = [CCLabelTTF labelWithString:bulletString fontName:@"Verdana-Bold" fontSize:14.0f];
    bullets.positionType = CCPositionTypeNormalized;
    bullets.position = ccp(0.1f,0.90f);
    [self addChild:bullets];
}

-(void)onHitAnimation:(CGPoint)location
{
    CCSprite *hit = [CCSprite spriteWithImageNamed:@"hit0.png"];
    hit.position = ccp(location.x,location.y);
    CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:hitAnimation];
    CCActionRemove *remove = [CCActionRemove action];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[animationAction,remove]];
    [hit runAction:sequence];
    [self addChild:hit];
}

//Perform end-of-round activities
-(void)doRoundEnd
{
    currentRound++;
    NSString *roundEndString = [[NSString alloc] initWithFormat:@"Round Over!"];
    NSString *nextRoundString = [[NSString alloc] initWithFormat:@"Prepare for Round %d",currentRound];
    roundEnd = [CCLabelTTF labelWithString:roundEndString fontName:@"Verdana-Bold" fontSize:14.0f];
    nextRound = [CCLabelTTF labelWithString:nextRoundString fontName:@"Verdana-Bold" fontSize:14.0f];
    roundEnd.positionType = CCPositionTypeNormalized;
    roundEnd.position = ccp(0.5f,0.55f);
    nextRound.positionType = CCPositionTypeNormalized;
    nextRound.position = ccp(0.5f,0.45f);
    [self addChild:roundEnd];
    [self addChild:nextRound];
    gatorsFired = 0;
}

//Retrieve list of High Scores
-(void)getHighScores
{
    arrayOfHighScoreNames = [[NSMutableArray alloc] init];
    arrayOfHighScoreScores = [[NSMutableArray alloc] init];
    arrayOfBulletScores = [[NSMutableArray alloc] init];
    NSUserDefaults *highScores = [NSUserDefaults standardUserDefaults];
    //If no high scores exist, populate with dummy data, otherwise, retrieve them.
    if ([highScores objectForKey:@"Names"] == nil)
    {
        [arrayOfHighScoreNames addObject:@"Scott"];
        [arrayOfHighScoreNames addObject:@"Doge"];
        [arrayOfHighScoreNames addObject:@"Kelly"];
        [arrayOfHighScoreNames addObject:@"Ben"];
        [arrayOfHighScoreNames addObject:@"Jess"];
        
        [arrayOfHighScoreScores addObject:@"50"];
        [arrayOfHighScoreScores addObject:@"40"];
        [arrayOfHighScoreScores addObject:@"30"];
        [arrayOfHighScoreScores addObject:@"20"];
        [arrayOfHighScoreScores addObject:@"10"];
        
        [arrayOfBulletScores addObject:@"90%"];
        [arrayOfBulletScores addObject:@"80%"];
        [arrayOfBulletScores addObject:@"70%"];
        [arrayOfBulletScores addObject:@"60%"];
        [arrayOfBulletScores addObject:@"50%"];
    } else
    {
        arrayOfHighScoreNames = [highScores objectForKey:@"Names"];
        arrayOfHighScoreScores = [highScores objectForKey:@"Scores"];
        arrayOfBulletScores = [highScores objectForKey:@"BulletScores"];
    }
}

//Check if the new score is a high score, then update accordingly.
/*-(void)updateHighScores:(float)newScore
{
    for (int x = [arrayOfHighScoreNames count]; x >= 1; x--)
    {
        float adjustedRatio = ((float)scoreInt/(float)bulletsFired)*(float)100;
        NSNumberFormatter *formatter =  [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:kCFNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:1];
        ratioString = [formatter stringFromNumber:[NSNumber numberWithFloat:adjustedRatio]];
        //Compare the current score to each high score in the list.
        NSString *thisScoreValue = [arrayOfHighScoreScores objectAtIndex:x-1];
        float thisScore = [thisScoreValue floatValue];
        scoreString = [formatter stringFromNumber:[NSNumber numberWithFloat:newScore]];
        if (newScore > thisScore)
        {
            //Check again
        } else
        {
            //If wee're on the first check, no high score was reached. Therefore, we kill it.
            if (x == [arrayOfHighScoreNames count])
            {
                NSString *alertString = [[NSString alloc] initWithFormat:@"Your score of %@ and an efficiency of %@%% did not register a high score.",scoreString,ratioString];
                UIAlertView *noHighScore = [[UIAlertView alloc] initWithTitle:@"Too Bad!" message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [noHighScore show];
                break;
            } else
            {
                UIAlertView *newHighScore = [[UIAlertView alloc] initWithTitle:@"High Score!" message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
                newHighScore.alertViewStyle = UIAlertViewStylePlainTextInput;
                [[newHighScore textFieldAtIndex:0] setPlaceholder:@"Enter a name!"];
                newHighScore.tag = x; //This tag tells the alertView function where to insert the new high score.
                [newHighScore show];
                break;
            }
        }
    }
}*/

-(void)updateHighScores:(float)rawScore efficiency:(float)efficiency
{
    if (areWeAGuest == true)
    {
        UIAlertView *gameOverAlert = [[UIAlertView alloc] initWithTitle:@"Game Over!" message:@"Create and log in with an account next time to register high scores!" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
        gameOverAlert.alertViewStyle = UIAlertViewStyleDefault;
        gameOverAlert.tag = 8; //This tag tells the alertView function where to insert the new high score.
        [gameOverAlert show];
    } else
    {
        if (rawScore > [topScore floatValue])
        {
            NSNumber *newHighScore = [[NSNumber alloc] initWithFloat:rawScore];
            NSNumber *newEfficiency = [[NSNumber alloc] initWithFloat:efficiency];
            LeaderboardsAndSignIn *leaders = [[LeaderboardsAndSignIn alloc] init];
            [leaders pushNewScoreToLeaderboard:newHighScore userID:currentUserID efficiency:newEfficiency];
            for (int x = [arrayOfHighScoreNames count]; x >= 1; x--)
            {
                float adjustedScore = rawScore*efficiency;
                float adjustedRatio = ((float)scoreInt/(float)bulletsFired)*(float)100;
                NSNumberFormatter *formatter =  [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:kCFNumberFormatterDecimalStyle];
                [formatter setMaximumFractionDigits:1];
                ratioString = [formatter stringFromNumber:[NSNumber numberWithFloat:adjustedRatio]];
                //Compare the current score to each high score in the list.
                NSString *thisScoreValue = [arrayOfHighScoreScores objectAtIndex:x-1];
                float thisScore = [thisScoreValue floatValue];
                scoreString = [formatter stringFromNumber:[NSNumber numberWithFloat:adjustedScore]];
                if (adjustedScore > thisScore)
                {
                    //Check again
                } else
                {
                    //If we're on the first check, no high score was reached. Therefore, we kill it.
                    if (x == [arrayOfHighScoreNames count])
                    {
                      break;
                    } else
                    {
                        NSString *userName = currentUserName;
                        NSString *newScore = scoreString;
                        NSString *ratioStringWithPercent = [[NSString alloc] initWithFormat:@"%@%%",ratioString];
                        NSNumber *formattedScore = [[NSNumber alloc] initWithFloat:rawScore];
                        int whereToInsert = x;
                        [arrayOfHighScoreNames insertObject:userName atIndex:whereToInsert];
                        [arrayOfHighScoreScores insertObject:newScore atIndex:whereToInsert];
                        [arrayOfBulletScores insertObject:ratioStringWithPercent atIndex:whereToInsert];
                        [arrayOfHighScoreNames removeLastObject];
                        [arrayOfHighScoreScores removeLastObject];
                        [arrayOfBulletScores removeLastObject];
                        NSUserDefaults *highScores = [NSUserDefaults standardUserDefaults];
                        [highScores setObject:arrayOfHighScoreNames forKey:@"Names"];
                        [highScores setObject:arrayOfHighScoreScores forKey:@"Scores"];
                        [highScores setObject:arrayOfBulletScores forKey:@"BulletScores"];
                        [highScores setObject:formattedScore forKey:@"CurrentUserHighScore"];
                        [highScores synchronize];
                        break;
                    }
                }
            }
            UIAlertView *gameOverAlert = [[UIAlertView alloc] initWithTitle:@"High Score!" message:@"You've set a new personal best! Congratulations!" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
            gameOverAlert.alertViewStyle = UIAlertViewStyleDefault;
            [gameOverAlert show];
        } else
        {
            for (int x = [arrayOfHighScoreNames count]; x >= 1; x--)
            {
                float adjustedScore = rawScore*efficiency;
                float adjustedRatio = ((float)scoreInt/(float)bulletsFired)*(float)100;
                NSNumberFormatter *formatter =  [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:kCFNumberFormatterDecimalStyle];
                [formatter setMaximumFractionDigits:1];
                ratioString = [formatter stringFromNumber:[NSNumber numberWithFloat:adjustedRatio]];
                //Compare the current score to each high score in the list.
                NSString *thisScoreValue = [arrayOfHighScoreScores objectAtIndex:x-1];
                float thisScore = [thisScoreValue floatValue];
                scoreString = [formatter stringFromNumber:[NSNumber numberWithFloat:adjustedScore]];
                if (adjustedScore > thisScore)
                {
                    //Check again
                } else
                {
                    //If we're on the first check, no high score was reached. Therefore, we kill it.
                    if (x == [arrayOfHighScoreNames count])
                    {
                        UIAlertView *gameOverAlert = [[UIAlertView alloc] initWithTitle:@"Game Over!" message:@"You did not register a high score this round. Please try again." delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
                        gameOverAlert.alertViewStyle = UIAlertViewStyleDefault;
                        gameOverAlert.tag = 8; //This tag tells the alertView function where to insert the new high score.
                        [gameOverAlert show];
                        break;
                    } else
                    {
                        UIAlertView *gameOverAlert = [[UIAlertView alloc] initWithTitle:@"High Score!" message:@"You've reached the high scores list! Congratulations!" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
                        gameOverAlert.alertViewStyle = UIAlertViewStyleDefault;
                        [gameOverAlert show];
                        break;
                    }
                }
            }

        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Return to main menu, regardless of which pop-up you get.
        [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                                   withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

// -----------------------------------------------------------------------
@end