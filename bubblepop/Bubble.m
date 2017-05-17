//
//  Bubble.m
//  bubblepop
//
//  Created by Jason King on 9/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import "Bubble.h"
#import "Constants.h"

@implementation Bubble

- (id)initWithPosition:(Position *)position andImageName:(NSString *)imageName {
    if(self = [super init]) {
        self.position = position;
        self.image = [UIImage imageNamed:imageName];
        self.frame = CGRectMake(position.x, position.y, BUBBLE_RADIUS * 2, BUBBLE_RADIUS * 2);
    }

    return self;
}

@end
