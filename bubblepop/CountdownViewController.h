//
//  CountdownViewController.h
//  bubblepop
//
//  Created by Nihal Sunthankar on 17/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property int countdown;
@property NSString *player;

- (void)count:(NSTimer*) timer;

@end
