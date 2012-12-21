//
//  LandscapeViewController.h
//  MinecraftCompanion
//
//  Created by Jason Fieldman on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandscapeViewController : UIViewController {
	
	UIImageView *bgStarsView;
	UIImageView *bgSkyView;
	UIImageView *bgGroundView;
	UIImageView *bgCloudView;
	UIImageView *bgBGroundView;
	UIImageView *bgBCloudView;
	
	UIImageView *sunImg;
	UIImageView *moonImg;
	UIView      *sunPivot;
	UIView      *moonPivot;
	
	/* Planetary angles, normalized to 0.0-1.0 being a full circle starting at west */
	double starAngle;
	double sunAngle;	
	double moonAngle;
	
	/* Time of day in the mc universe.  0 = sunrise, 0.25 = midday, 0.5 = sunset, 0.75 = midnight */
	double canaryTOD;
}


- (void) setStarsAngle:(double)normalizedAngle;
- (void) setSunAngle:(double)normalizedAngle;
- (void) setMoonAngle:(double)normalizedAngle;

- (void) setCanaryTOD:(double)canaryTOD;

/* Get the linear canary TOD from phase/prog (prog is 0-1) */
- (double) canarryTODForPhase:(PhaseOfDay_t)phase progress:(float)prog;

@end
