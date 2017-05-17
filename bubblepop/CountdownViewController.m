//
//  CountdownViewController.m
//  bubblepop
//
//  Created by Nihal Sunthankar on 17/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import "CountdownViewController.h"
#import "GameViewController.h"

@interface CountdownViewController ()

@end

@implementation CountdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countdown = 3;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self
                                   selector:@selector(count:)
                                   userInfo:nil repeats:YES];
}

- (void)count:(NSTimer*) timer {
    self.countdown--;

    
    if(self.countdown == 0) {
        [self performSegueWithIdentifier:@"startSegue" sender:self];
        [timer invalidate];
    } else {
        self.lblNumber.text = [NSString stringWithFormat:@"%d", self.countdown];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GameViewController *gameViewController = [segue destinationViewController];
    gameViewController.player = self.player;
}

@end
