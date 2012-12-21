//
//  CanaryViewController.h
//  MinecraftCompanion
//
//  Created by Jason Fieldman on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LandscapeViewController.h"
#import "UICustomLabel.h"
#import "TwoFingerDragCatcher.h"

#define MC_SUNRISE_START      0.0
#define MC_SUNRISE_DURATION   90.0
#define MC_DAYTIME_START      (MC_SUNRISE_START + MC_SUNRISE_DURATION)
#define MC_DAYTIME_DURATION   (10*60.0)
#define MC_SUNSET_START       (MC_DAYTIME_START + MC_DAYTIME_DURATION)
#define MC_SUNSET_DURATION    90.0
#define MC_NIGHTTIME_START    (MC_SUNSET_START + MC_SUNSET_DURATION)
#define MC_NIGHTTIME_DURATION (7*60.0)
#define MC_CYCLE_DURATION     (MC_SUNRISE_DURATION + MC_DAYTIME_DURATION + MC_SUNSET_DURATION + MC_NIGHTTIME_DURATION)

#define MAX_ANCHOR_SAVE_TIME  (86400*1)

@interface CanaryViewController : UIViewController <TwoFingerDragDelegate> {
	LandscapeViewController *landscape;
	
	UICustomLabel *timeLeftLabel;
	UICustomLabel *timeLeftBlack;
	
	/* Quick buttons */
	UIView *qbHolder;
	UIButton *qbSunrise;
	UIButton *qbNoon;
	UIButton *qbMoonrise;
	UIButton *qbMidnight;
	
	UIButton *clockButton;
	
	/* MC daynight cycle */
	int currentCycleTime; /* 0 to MC_CYCLE_DURATION */
	int anchorRealTime;   /* UNIX timestamp of the cycle anchor */
	int anchorCycleTime;  /* What was the cycle time at the real anchor time? */
	
	/* Cycle timer */
	NSTimer *cycleTimer;
	
	/* Two finger drag */
	TwoFingerDragCatcher *twoFingerDrag;
}

- (CycleTimestamp_t) timestampForCycleTime:(double)cycleTime;
- (void) updateLandscapeToCycleTime:(double)cycleTime;

- (void) updateSceneToCycleTime:(double)cycleTime;

- (void) setAnchorToRealTime:(double)realTime forCycleTime:(double)cycleTime save:(BOOL)save;
- (void) updateCurrentCycleTimeBasedOnAnchorVsNow;

- (void) startAutoCycleProgress;
- (void) stopAutoCycleProgress;

@end
