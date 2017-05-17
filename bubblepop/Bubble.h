//
//  Bubble.h
//  bubblepop
//
//  Created by Jason King on 9/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Position.h"

@interface Bubble : UIImageView

@property Position* position;
@property int points;
- (id)initWithPosition:(Position *)position andImageName:(NSString *)imageName;
@end
