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

    self.score = @0;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setDimensions];
}

- (void)setDimensions {
    CGRect gameRect = self.gameView.bounds;
    self.screenWidth = gameRect.size.width;
    self.screenHeight = gameRect.size.height;
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

    self.lblTime.text = [NSString stringWithFormat:@"Time Left\n%ld", (long)self.timeRemaining];
    [self removeBubbles];
    [self createBubbles];

    self.timeRemaining--;
}

- (void)gameFinished {
    [self.gameTimer invalidate];
    [self saveScore];
    [self performSegueWithIdentifier:@"finishSegue" sender:self];
}
/*
 * Save score to core data
 */
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
/*
 * Handles a bubble tap. Removes the bubble from the screen and updates the score
 */
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

/*
 * Creates bubbles on the screen
 */
- (void)createBubbles {
    
    int bubblesToCreate = arc4random_uniform((uint32_t) (self.maxBubbles - [self getBubbles].count));
    for(int i = 0; i < bubblesToCreate; i ++) {
        Position *position = [self getValidPosition];
        Bubble *bubble = [self getBubbleWithPosition:position];

        [self.gameView addSubview:bubble];

        bubble.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
        [UIView animateWithDuration:ANIMATION_TIME delay:0 options: UIViewAnimationOptionCurveEaseOut
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

/*
 * Removes a random number of bubbles
 */
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

/*
 * Tries to find a valid position for the bubble to land
 */
- (Position*)getValidPosition {

    BOOL foundPosition = NO;
    Position *randomPosition;
    NSMutableArray *bubbles = [self getBubbles];
    while(!foundPosition) {
        randomPosition = [self getRandomPosition];

        // If there are no bubbles, the position is immediately valid
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
/*
 * Loops through the subviews and gets the bubbles
 */
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

/*
 * Checks whether two bubbles intersect using their positions and the distance formula
 */
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

/*
 * Handles rotations
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
        [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

        } completion:^(id<UIViewControllerTransitionCoordinatorContext> context){
            [self setDimensions];
        }];
}

/*
 * Randomly selects a bubble color
 */
- (Bubble*)getBubbleWithPosition:(Position*) position {

    //Gets a random number between 1 and a 100 and chooses the bubble colour based on it.
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

/*
 * Gets the core data context
 */
- (NSManagedObjectContext *)managedObjectContext {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSPersistentContainer *container = [delegate persistentContainer];
    return [container viewContext];
}

@end
