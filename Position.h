//
//  Point.h
//  bubblepop
//
//  Created by Jason King on 9/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Position : NSObject

@property int x;
@property int y;

- (id)initWithX:(int)x andY:(int)y;

@end
