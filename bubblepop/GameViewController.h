//
//  GameViewController.h
//  bubblepop
//
//  Created by Jason King on 9/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "math.h"

#import "RedBubble.h"
#import "PinkBubble.h"
#import "GreenBubble.h"
#import "BlueBubble.h"
#import "BlackBubble.h"
#import "Position.h"

@interface GameViewController : UIViewController

@property int gameTime;
@property int maxBubbles;
@property CGFloat screenWidth;
@property CGFloat screenHeight;
@property int timeRemaining;
@property NSTimer *gameTimer;
@property NSNumber *score;
@property Bubble *lastTapped;
@property NSString *player;
@property int highestScore;

@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblScore;
@property (weak, nonatomic) IBOutlet UILabel *lblHigh;

- (void)setHighScore;
- (void)gameStep:(NSTimer*) timer;
- (void)gameFinished;
- (void)saveScore;
- (void)bubbleTapped:(UIGestureRecognizer *)gesture;
- (void)createBubbles;
- (void)removeBubbles;
- (NSMutableArray *) getBubbles;
- (Position*)getValidPosition;
- (Bubble*)getBubbleWithPosition:(Position*) position;
- (Position*)getRandomPosition;
- (BOOL)circle:(Position *)p1 intersectsWith:(Position*)p2;


@end
