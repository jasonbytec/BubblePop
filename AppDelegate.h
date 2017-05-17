//
//  AppDelegate.h
//  bubblepop
//
//  Created by Jason King on 9/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

