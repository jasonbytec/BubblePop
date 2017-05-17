//
//  RedBubble.m
//  bubblepop
//
//  Created by Jason King on 9/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import "RedBubble.h"

@implementation RedBubble

- (id)initWithPosition:(Position*) position {
    if(self = [super init]) {
        self = [super initWithPosition:position andImageName:@"bubble_red"];
        self.points = 1;
    }
    
    return self;
}

@end
