//
//  ViewController.m
//  bubblepop
//
//  Created by Jason King on 9/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import "MainViewController.h"
#import "GameViewController.h"
#import "CountdownViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (IBAction)handleButtonClick:(id)sender {
    //Input validation
    if(self.txtName.text && self.txtName.text.length > 0) {
        [self performSegueWithIdentifier:@"countdownSegue" sender:self];
    } else {
        [self showAlert];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CountdownViewController *countdownViewController = [segue destinationViewController];
    countdownViewController.player = self.txtName.text;
}

/*
 * Shows an alert view if name is not entered
 */
- (void)showAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Name is empty"
                                                                             message:@"Please enter your name"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
