//
//  BlueBubble.m
//  bubblepop
//
//  Created by Jason King on 9/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import "BlueBubble.h"

@implementation BlueBubble

- (id)initWithPosition:(Position*) position {
    if(self = [super init]) {
        self = [super initWithPosition:position andImageName:@"bubble_blue"];
        self.points = 8;
    }
    
    return self;
}

@end
