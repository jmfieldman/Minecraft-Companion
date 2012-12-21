    //
//  LandscapeViewController.m
//  MinecraftCompanion
//
//  Created by Jason Fieldman on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LandscapeViewController.h"


@implementation LandscapeViewController


- (id) init {
	if (self = [super init]) {
	
		self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 480)] autorelease];
		self.view.backgroundColor = [UIColor clearColor];
		
		/* Stars are in back */
		bgStarsView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_stars.png"]] autorelease];
		bgStarsView.backgroundColor = [UIColor clearColor];
		bgStarsView.center = CGPointMake(200, 40);
		[self.view addSubview:bgStarsView];
		
		/* Sky is next */
		bgSkyView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_sky.png"]] autorelease];
		bgSkyView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:bgSkyView];
		
		/* Then sun/moon */
		sunPivot = [[[UIView alloc] initWithFrame:CGRectMake(240, 270, 1, 1)] autorelease];
		sunPivot.backgroundColor = [UIColor clearColor];
		[self.view addSubview:sunPivot];
		
		sunImg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sun.png"]] autorelease];
		sunImg.center = CGPointMake(-140, 0);
		sunImg.backgroundColor = [UIColor clearColor];
		[sunPivot addSubview:sunImg];
		
		moonPivot = [[[UIView alloc] initWithFrame:CGRectMake(240, 270, 1, 1)] autorelease];
		moonPivot.backgroundColor = [UIColor clearColor];		
		[self.view addSubview:moonPivot];
		
		moonImg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moon.png"]] autorelease];
		moonImg.center = CGPointMake(-140, 0);
		moonImg.backgroundColor = [UIColor clearColor];
		[moonPivot addSubview:moonImg];
		
		/* Then ground */
		bgBGroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_groundblack.png"]] autorelease];
		bgBGroundView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:bgBGroundView];
		
		bgGroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_ground.png"]] autorelease];
		bgGroundView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:bgGroundView];
		
		/* Then clouds are in front */
		bgBCloudView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_cloudsblack.png"]] autorelease];
		bgBCloudView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:bgBCloudView];
		
		bgCloudView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_clouds.png"]] autorelease];
		bgCloudView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:bgCloudView];
		
		
		sunAngle = 0.0;
		moonAngle = 0.5;
		//[self performSelector:@selector(updatePlanetsTest) withObject:nil afterDelay:0.05];
		//[self performSelector:@selector(updateTODTest) withObject:nil afterDelay:0.05];
	}
	return self;
}


- (void)dealloc {
    [super dealloc];
}


- (void) updateTODTest {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.05];	
	[self setCanaryTOD:(canaryTOD + 0.0010)];
	[UIView commitAnimations];
	[self performSelector:@selector(updateTODTest) withObject:nil afterDelay:0.05];
}

- (void) updatePlanetsTest {
	sunAngle += 0.0005;
	moonAngle += 0.0005;
	starAngle += 0.0005;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self setSunAngle:sunAngle];
	[self setMoonAngle:moonAngle];
	[self setStarsAngle:starAngle];
	[UIView commitAnimations];
	[self performSelector:@selector(updatePlanetsTest) withObject:nil afterDelay:0.5];
}


- (void) setStarsAngle:(double)normalizedAngle {
	starAngle = normalizedAngle;
	double realAngle = normalizedAngle * 2 * M_PI;
	bgStarsView.layer.transform = CATransform3DMakeRotation(realAngle, 0, 0, -1);
}


- (void) setSunAngle:(double)normalizedAngle {
	sunAngle = normalizedAngle;
	double realAngle = normalizedAngle * 2 * M_PI;
	sunPivot.layer.transform = CATransform3DMakeRotation(realAngle, 0, 0, 1);
	sunImg.layer.transform   = CATransform3DMakeRotation(-realAngle, 0, 0, 1);
}


- (void) setMoonAngle:(double)normalizedAngle {
	moonAngle = normalizedAngle;
	double realAngle = normalizedAngle * 2 * M_PI;
	moonPivot.layer.transform = CATransform3DMakeRotation(realAngle, 0, 0, 1);
	moonImg.layer.transform   = CATransform3DMakeRotation(-realAngle, 0, 0, 1);	
}


#define TOD_SUNRISE_STARTS  0.0
#define TOD_SUNRISE_ENDS    0.05
#define TOD_SUNRISE_LENGTH  (TOD_SUNRISE_ENDS - TOD_SUNRISE_STARTS)
#define TOD_MIDDAY          0.274
#define TOD_DAYLENGTH       (TOD_SUNSET_STARTS - TOD_SUNRISE_ENDS)
#define TOD_EXTDAYLEN       (TOD_SUNSET_ENDS - TOD_SUNRISE_STARTS)
#define TOD_SUNSET_STARTS   0.50
#define TOD_SUNSET_ENDS     0.55
#define TOD_SUNSET_LENGTH   (TOD_SUNSET_ENDS - TOD_SUNSET_STARTS)
#define TOD_MIDNIGHT        0.774
#define TOD_NIGHTLENGTH     (1.0 - TOD_SUNSET_ENDS)

#define GROUND_ALPHA_NIGHT  0.2
#define GROUND_ALPHA_DAY    1.0
#define GROUND_ALPHA_DIFF   (GROUND_ALPHA_DAY - GROUND_ALPHA_NIGHT)
#define CLOUDS_ALPHA_NIGHT  0.15
#define CLOUDS_ALPHA_DAY    1.0
#define CLOUDS_ALPHA_DIFF   (CLOUDS_ALPHA_DAY - CLOUDS_ALPHA_NIGHT)
#define SKY_ALPHA_NIGHT     0.0
#define SKY_ALPHA_DAY       1.0
#define SKY_ALPHA_DIFF      (SKY_ALPHA_DAY - SKY_ALPHA_NIGHT)

#define SET_REST_ANGLE      0.575
#define RISE_REST_ANGLE     0.95
#define RISE_REST_ANGLE_NEG (RISE_REST_ANGLE - 1)
#define SUN_ARC_LENGTH      (SET_REST_ANGLE - RISE_REST_ANGLE_NEG)

#define M_SET_REST_ANGLE      0.53
#define M_RISE_REST_ANGLE     0.99
#define M_RISE_REST_ANGLE_NEG (M_RISE_REST_ANGLE - 1)
#define M_SUN_ARC_LENGTH      (M_SET_REST_ANGLE - M_RISE_REST_ANGLE_NEG)

#define STARS_APPEAR        (TOD_SUNSET_STARTS + 0.02)
#define STARS_APPEAR_RAMP   0.03

#define STARS_LEAVE         0.0
#define STARS_LEAVE_RAMP    0.03



/* Time of day in the mc universe.  0 = sunrise, 0.25 = midday, 0.5 = sunset, 0.75 = midnight */
- (void) setCanaryTOD:(double)newCanaryTOD {
	/* This should normalize it to 0.0-1.0 */
	if (newCanaryTOD < 0) newCanaryTOD = newCanaryTOD + 1000;
	canaryTOD = newCanaryTOD - (int)newCanaryTOD;
	
	
	/* Sun position */
	//[self setSunAngle:canaryTOD - 0.02];
	if (canaryTOD > TOD_SUNSET_ENDS && canaryTOD <= TOD_MIDNIGHT) {
		/* Sun is setting, so let's shove it just under the east horizon */
		[self setSunAngle:SET_REST_ANGLE];
	} else if (canaryTOD > TOD_MIDNIGHT) {
		/* It's past midnight, so the sun is getting ready to rise just under the west horizon */
		[self setSunAngle:RISE_REST_ANGLE];
	} else {
		/* Otherwise we're after sunrise starts and before sunset end.. so daytime */
		float prog = (canaryTOD - TOD_SUNRISE_STARTS) / TOD_EXTDAYLEN;
		
		double ang = RISE_REST_ANGLE_NEG + (prog * SUN_ARC_LENGTH);
		[self setSunAngle:ang];
	}

	
	/* Moon position */
	if (canaryTOD <= TOD_MIDDAY) {
		/* Moon is setting, so let's shove it just under the east horizon */
		[self setMoonAngle:M_SET_REST_ANGLE];
	} else if (canaryTOD <= TOD_SUNSET_ENDS) {
		/* It's past midday, so the moon is getting ready to rise just under the west horizon */
		[self setMoonAngle:M_RISE_REST_ANGLE];
	} else {
		/* Otherwise we're after sunset starts and before sunrise.. so nighttime */
		float prog = (canaryTOD - TOD_SUNSET_ENDS) / TOD_NIGHTLENGTH;
		
		double ang = M_RISE_REST_ANGLE_NEG + (prog * M_SUN_ARC_LENGTH);
		[self setMoonAngle:ang];
	}
	
	
	/* Seems ok to position the stars at aritrary angle same speed as rotation */
	[self setStarsAngle:canaryTOD];
	
	/* Ground darkness */
	if (canaryTOD < TOD_SUNRISE_ENDS) {
		/* Waking up */
		float prog = (canaryTOD / TOD_SUNRISE_LENGTH);
		prog *= prog;
		bgGroundView.alpha = prog * GROUND_ALPHA_DIFF + GROUND_ALPHA_NIGHT;
	} else if (canaryTOD > TOD_SUNSET_ENDS) {
		/* night time */
		bgGroundView.alpha = GROUND_ALPHA_NIGHT;
	} else if (canaryTOD > TOD_SUNSET_STARTS) {
		/* Sunset */
		float prog = (1 - ((canaryTOD - TOD_SUNSET_STARTS) / TOD_SUNSET_LENGTH)) ;
		prog *= prog;
		bgGroundView.alpha = prog * GROUND_ALPHA_DIFF + GROUND_ALPHA_NIGHT;
	} else {
		bgGroundView.alpha = GROUND_ALPHA_DAY;
	}
	
	
	/* Sky darkness */
	if (canaryTOD < TOD_SUNRISE_ENDS) {
		/* Waking up */
		float prog = (canaryTOD / TOD_SUNRISE_LENGTH);
		prog *= prog;
		bgSkyView.alpha = prog * SKY_ALPHA_DIFF + SKY_ALPHA_NIGHT;
	} else if (canaryTOD > TOD_SUNSET_ENDS) {
		/* night time */
		bgSkyView.alpha = SKY_ALPHA_NIGHT;
	} else if (canaryTOD > TOD_SUNSET_STARTS) {
		/* Sunset */
		float prog = (1 - ((canaryTOD - TOD_SUNSET_STARTS) / TOD_SUNSET_LENGTH)) ;
		prog *= prog;
		bgSkyView.alpha = prog * SKY_ALPHA_DIFF + SKY_ALPHA_NIGHT;
	} else {
		bgSkyView.alpha = SKY_ALPHA_DAY;
	}
	
	
	/* Cloud darkness */
	if (canaryTOD < TOD_SUNRISE_ENDS) {
		/* Waking up */
		float prog = (canaryTOD / TOD_SUNRISE_LENGTH);
		prog *= prog;
		bgCloudView.alpha = prog * CLOUDS_ALPHA_DIFF + CLOUDS_ALPHA_NIGHT;
	} else if (canaryTOD > TOD_SUNSET_ENDS) {
		/* night time */
		bgCloudView.alpha = CLOUDS_ALPHA_NIGHT;
	} else if (canaryTOD > TOD_SUNSET_STARTS) {
		/* Sunset */
		float prog = (1 - ((canaryTOD - TOD_SUNSET_STARTS) / TOD_SUNSET_LENGTH)) ;
		prog *= prog;
		bgCloudView.alpha = prog * CLOUDS_ALPHA_DIFF + CLOUDS_ALPHA_NIGHT;
	} else {
		bgCloudView.alpha = CLOUDS_ALPHA_DAY;
	}
	
	/* Stars darkness */
	if (canaryTOD >= STARS_APPEAR) {
		/* night time */
		bgStarsView.alpha = (canaryTOD - STARS_APPEAR) / STARS_APPEAR_RAMP;
	} else {
		/* day time */
		float r = (canaryTOD / STARS_LEAVE_RAMP);
		if (r > 1) r = 1;
		bgStarsView.alpha = 1 - r;
	}
}



- (double) canarryTODForPhase:(PhaseOfDay_t)phase progress:(float)prog {
	double cTOD = 0;
	
	switch (phase) {
		case TOD_PHASE_SUNRISE:
			cTOD = TOD_SUNRISE_STARTS + (prog * TOD_SUNRISE_LENGTH);
			break;
			
		case TOD_PHASE_DAY:
			cTOD = TOD_SUNRISE_ENDS + (prog * TOD_DAYLENGTH);
			break;
			
		case TOD_PHASE_SUNSET:
			cTOD = TOD_SUNSET_STARTS + (prog * TOD_SUNSET_LENGTH);
			break;
			
		case TOD_PHASE_NIGHT:
			cTOD = TOD_SUNSET_ENDS + (prog * TOD_NIGHTLENGTH);
			break;

	}
	
	return cTOD;	
}



@end
