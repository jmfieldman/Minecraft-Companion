//
//  MinecraftCompanionAppDelegate.h
//  MinecraftCompanion
//
//  Created by Jason Fieldman on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CanaryViewController.h"

@interface MinecraftCompanionAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	CanaryViewController *canaryView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

