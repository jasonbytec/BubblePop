//
//  ScoreViewController.h
//  bubblepop
//
//  Created by Nihal Sunthankar on 17/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnNewGame;
@property NSArray *scores;
@end
