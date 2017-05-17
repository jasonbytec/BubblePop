//
//  GameViewController.m
//  bubblepop
//
//  Created by Jason King on 9/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import "GameViewController.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface GameViewController ()


@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect gameRect = self.gameView.bounds;
    self.screenWidth = gameRect.size.width;
    self.screenHeight = gameRect.size.height;

    [self setHighScore];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.timeRemaining = [defaults integerForKey:@"time"];
    self.maxBubbles = [defaults integerForKey:@"bubbles"];

    self.lblScore.text = [NSString stringWithFormat:@"Score\n0"];
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self
                                                       selector:@selector(gameStep:)
                                                    userInfo:nil repeats:YES];

    [self.gameTimer fire];
}

- (void)setHighScore {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Scores"];
    NSArray *scores = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] copy];

    self.highestScore = 0;

    for(NSManagedObject *scoreObject in scores) {
        int score = [[scoreObject valueForKey:@"score"] intValue];
        if(score > self.highestScore) {
            self.highestScore = score;
        }
    }

    self.lblHigh.text = [NSString stringWithFormat:@"High Score\n%d", self.highestScore];
}

- (void)gameStep:(NSTimer*) timer {
    if(self.timeRemaining == 0) {
        [self gameFinished];
        return;
    }

    self.lblTime.text = [NSString stringWithFormat:@"Time Left\n%d", self.timeRemaining];
    [self removeBubbles];
    [self createBubbles];

    self.timeRemaining--;
}

- (void)gameFinished {
    [self.gameTimer invalidate];
    [self saveScore];
    [self performSegueWithIdentifier:@"finishSegue" sender:self];
}

- (void)saveScore {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *score = [NSEntityDescription insertNewObjectForEntityForName:@"Scores" inManagedObjectContext:context];
    [score setValue:self.player forKey:@"player"];
    [score setValue:self.score forKey:@"score"];

    NSError *error = nil;

    if(![context save:&error]) {
        NSLog(@"Error Saving. %@ %@", error, [error localizedDescription]);
    } else {
        NSLog(@"Save Successful");
    }
}

- (void)bubbleTapped:(UIGestureRecognizer *)gesture {
    Bubble *bubble = (Bubble *) gesture.view;

    double points;
    if(self.lastTapped != nil && self.lastTapped.points == bubble.points) {
       points = bubble.points * 1.5;
    } else {
        points = bubble.points;
    }

    self.score = @([self.score floatValue] + round(points));

    self.lblScore.text = [NSString stringWithFormat:@"Score\n%@", self.score];

    NSNumber *highestScore = @(self.highestScore);
    if([self.score doubleValue] > [highestScore doubleValue]) {
        self.lblHigh.text = [NSString stringWithFormat:@"High Score\n%@", self.score];
    }

    self.lastTapped = bubble;

    [UIView animateWithDuration:ANIMATION_TIME delay: 0 options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         bubble.transform = CGAffineTransformScale(self.gameView.transform, 2, 2);
                         bubble.alpha = 0;
                     } completion:^(BOOL finished) {

                [bubble removeFromSuperview];
            }];
}


- (void)createBubbles {
    
    int bubblesToCreate = arc4random_uniform((uint32_t) (self.maxBubbles - [self getBubbles].count));
    for(int i = 0; i < bubblesToCreate; i ++) {
        Position *position = [self getValidPosition];
        Bubble *bubble = [self getBubbleWithPosition:position];

        [self.gameView addSubview:bubble];

        bubble.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
        [UIView animateWithDuration:ANIMATION_TIME delay: 0 options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             bubble.transform = CGAffineTransformScale(self.gameView.transform, 1, 1);
                         } completion:nil];
        [bubble setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                        action:@selector(bubbleTapped:)];
        tap.numberOfTapsRequired = 1;
        [bubble addGestureRecognizer:tap];
    }
}

- (void)removeBubbles {
    uint bubblesToRemove = arc4random_uniform((uint32_t) [self getBubbles].count);
    
    for(int i = 0; i < bubblesToRemove; i ++) {
        NSUInteger indexToRemove = arc4random_uniform((uint32_t) [self getBubbles].count);

        Bubble *bubble = [self getBubbles][indexToRemove];

        [UIView animateWithDuration:ANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             bubble.transform = CGAffineTransformScale(self.gameView.transform, 0.01, 0.01);
                         } completion:^(BOOL finished) {

                    [bubble removeFromSuperview];
                }];
    }
}

- (Position*)getValidPosition {

    BOOL foundPosition = NO;
    Position *randomPosition;
    NSMutableArray *bubbles = [self getBubbles];
    while(!foundPosition) {
        randomPosition = [self getRandomPosition];

        if(bubbles.count == 0) {
            return randomPosition;
        }
        
        BOOL intersection = NO;
        
        for(Bubble *bubble in bubbles) {
            if([self circle:bubble.position intersectsWith:randomPosition]) {
                intersection = YES;
                break;
            }
        }
        
        foundPosition = !intersection;
    }
    
    return randomPosition;
    
}

- (NSMutableArray *) getBubbles {
    NSMutableArray *bubbles = [[NSMutableArray alloc] init];
    for(UIView * v in self.gameView.subviews) {
        if([v isKindOfClass:Bubble.class])
        {
            [bubbles addObject:v];
        }
    }
    return bubbles;
}

- (BOOL)circle:(Position *)p1 intersectsWith:(Position*)p2 {
    
    double distance = sqrt(pow((p2.x + BUBBLE_RADIUS) - (p1.x + BUBBLE_RADIUS), 2)
                           + pow((p2.y + BUBBLE_RADIUS) - (p1.y + BUBBLE_RADIUS), 2));
    return distance < (BUBBLE_RADIUS * 2) + BUBBLE_PADDING;
}

- (Position*)getRandomPosition {
    int x = arc4random_uniform((uint32_t) (self.screenWidth - BUBBLE_RADIUS * 2));
    int y = arc4random_uniform((uint32_t) (self.screenHeight - BUBBLE_RADIUS * 2));
    
    return [[Position alloc] initWithX:x andY:y];
}


- (Bubble*)getBubbleWithPosition:(Position*) position {
    int random = arc4random_uniform(100);
    
    if(random < 40) {
        return [[RedBubble alloc] initWithPosition:position];
    }
    
    if(40 <= random && random < 70) {
        return [[PinkBubble alloc] initWithPosition:position];
    }
    
    if(70 <= random && random < 85) {
        return [[GreenBubble alloc] initWithPosition:position];
    }
    
    if(85 <= random && random < 95) {
        return [[BlueBubble alloc] initWithPosition:position];
    }
    
    return [[BlackBubble alloc] initWithPosition:position];
}

- (NSManagedObjectContext *)managedObjectContext {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSPersistentContainer *container = [delegate persistentContainer];
    return [container viewContext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
