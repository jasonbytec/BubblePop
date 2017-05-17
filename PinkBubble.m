//
//  PinkBubble.m
//  bubblepop
//
//  Created by Jason King on 9/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import "PinkBubble.h"

@implementation PinkBubble

- (id)initWithPosition:(Position*) position {
    if(self = [super init]) {
        self = [super initWithPosition:position andImageName:@"bubble_pink"];
        self.points = 2;
    }
    
    return self;
}



@end
