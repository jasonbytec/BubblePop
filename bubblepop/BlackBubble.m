//
//  BlackBubble.m
//  bubblepop
//
//  Created by Jason King on 9/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import "BlackBubble.h"

@implementation BlackBubble

- (id)initWithPosition:(Position*) position {
    if(self = [super init]) {
        self = [super initWithPosition:position andImageName:@"bubble_black"];
        self.points = 10;
    }
    
    return self;
}

@end
