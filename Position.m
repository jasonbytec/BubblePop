//
//  Point.m
//  bubblepop
//
//  Created by Jason King on 9/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import "Position.h"

@implementation Position

- (id)initWithX:(int)x andY:(int)y {
    if(self = [super init]) {
        self.x = x;
        self.y = y;
    }
    
    return self;
}

@end
