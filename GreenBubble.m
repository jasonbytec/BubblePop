//
//  GreenBubble.m
//  bubblepop
//
//  Created by Jason King on 9/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import "GreenBubble.h"

@implementation GreenBubble

- (id)initWithPosition:(Position*) position {
    if(self = [super init]) {
        self = [super initWithPosition:position andImageName:@"bubble_green"];
        self.points = 5;
    }
    
    return self;
}

@end
