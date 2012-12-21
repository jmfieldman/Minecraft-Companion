    //
//  CanaryViewController.m
//  MinecraftCompanion
//
//  Created by Jason Fieldman on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CanaryViewController.h"


double modulus(double a, double b)
{
	int result = (int)( a / b );
	return a - (double)( result ) * b;
}


@implementation CanaryViewController


- (id) init {
	if (self = [super init]) {
		
		self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 480)] autorelease];
		self.view.backgroundColor = [UIColor clearColor];
		
		landscape = [[LandscapeViewController alloc] init];
		landscape.view.center = CGPointMake(160, 240);
		[self.view addSubview:landscape.view];
		
		/* Time labels */
		timeLeftBlack = [[[UICustomLabel alloc] initWithFrame:CGRectMake(5, -17, 300, 60)] autorelease];
		timeLeftBlack.text = @"Time Left:";
		timeLeftBlack.customColor = [UIColor blackColor];
		timeLeftBlack.customFont = [FontHelper fontHelperWithName:@"font"];
		timeLeftBlack.customSize = 36;
		timeLeftBlack.shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.65];
		timeLeftBlack.shadowOffset = CGSizeMake(1, 1);
		timeLeftBlack.backgroundColor = [UIColor clearColor];
		[self.view addSubview:timeLeftBlack];
		
		timeLeftLabel = [[[UICustomLabel alloc] initWithFrame:CGRectMake(5, -17, 300, 60)] autorelease];
		timeLeftLabel.text = @"Time Left:";
		timeLeftLabel.customColor = [UIColor whiteColor];
		timeLeftLabel.customFont = [FontHelper fontHelperWithName:@"font"];
		timeLeftLabel.customSize = 36;
		timeLeftLabel.backgroundColor = [UIColor clearColor];
		[self.view addSubview:timeLeftLabel];
		
		/* Drag */
		twoFingerDrag = [[[TwoFingerDragCatcher alloc] initWithFrame:CGRectMake(0, 0, 480, 480)] autorelease];
		twoFingerDrag.dragDelegate = self;
		[self.view addSubview:twoFingerDrag];
		
		/* Quick buttons */
		clockButton = [UIButton buttonWithType:UIButtonTypeCustom];
		clockButton.frame = CGRectMake(-10, 410, 80, 80);
		clockButton.backgroundColor = [UIColor clearColor];
		[clockButton setImage:[UIImage imageNamed:@"clock.png"] forState:UIControlStateNormal];
		[clockButton addTarget:self action:@selector(handleClockClick:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:clockButton];
		
		qbHolder = [[[UIView alloc] initWithFrame:CGRectMake(0, 400, 320, 80)] autorelease];
		qbHolder.backgroundColor = [UIColor clearColor];
		qbHolder.layer.transform = CATransform3DMakeTranslation(0, 160, 0);
		[self.view addSubview:qbHolder];
		
		UIImageView *swipeMsg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"swipe_msg.png"]] autorelease];
		swipeMsg.frame = CGRectMake(0, -15, 320, 20);
		swipeMsg.backgroundColor = [UIColor clearColor];
		[qbHolder addSubview:swipeMsg];
		
		qbSunrise = [UIButton buttonWithType:UIButtonTypeCustom];
		qbSunrise.frame = CGRectMake(0, 0, 80, 80);
		qbSunrise.backgroundColor = [UIColor clearColor];
		[qbSunrise setImage:[UIImage imageNamed:@"qb_sunrise.png"] forState:UIControlStateNormal];
		[qbSunrise addTarget:self action:@selector(hitQuickButton:) forControlEvents:UIControlEventTouchUpInside];
		[qbHolder addSubview:qbSunrise];
		
		qbNoon = [UIButton buttonWithType:UIButtonTypeCustom];
		qbNoon.frame = CGRectMake(80, 0, 80, 80);
		qbNoon.backgroundColor = [UIColor clearColor];
		[qbNoon setImage:[UIImage imageNamed:@"qb_noon.png"] forState:UIControlStateNormal];
		[qbNoon addTarget:self action:@selector(hitQuickButton:) forControlEvents:UIControlEventTouchUpInside];
		[qbHolder addSubview:qbNoon];
		
		qbMoonrise = [UIButton buttonWithType:UIButtonTypeCustom];
		qbMoonrise.frame = CGRectMake(160, 0, 80, 80);
		qbMoonrise.backgroundColor = [UIColor clearColor];
		[qbMoonrise setImage:[UIImage imageNamed:@"qb_moonrise.png"] forState:UIControlStateNormal];
		[qbMoonrise addTarget:self action:@selector(hitQuickButton:) forControlEvents:UIControlEventTouchUpInside];
		[qbHolder addSubview:qbMoonrise];
		
		qbMidnight = [UIButton buttonWithType:UIButtonTypeCustom];
		qbMidnight.frame = CGRectMake(240, 0, 80, 80);
		qbMidnight.backgroundColor = [UIColor clearColor];
		[qbMidnight setImage:[UIImage imageNamed:@"qb_midnight.png"] forState:UIControlStateNormal];
		[qbMidnight addTarget:self action:@selector(hitQuickButton:) forControlEvents:UIControlEventTouchUpInside];
		[qbHolder addSubview:qbMidnight];
		
		/* Load anchor */
		PersistentDictionary *cycleDic = [PersistentDictionary dictionaryWithName:@"cycleDic"];
		if ([cycleDic.dictionary objectForKey:@"anchorRealTime"]) {
			NSNumber *anchorRealTimeNum  = [cycleDic.dictionary objectForKey:@"anchorRealTime"];
			NSNumber *anchorCycleTimeNum = [cycleDic.dictionary objectForKey:@"anchorCycleTime"];
			
			double timediff = CFAbsoluteTimeGetCurrent() - [anchorRealTimeNum doubleValue];
			if (timediff < 0 || timediff > MAX_ANCHOR_SAVE_TIME) {
				[self setAnchorToRealTime:CFAbsoluteTimeGetCurrent() forCycleTime:(MC_DAYTIME_START + MC_DAYTIME_DURATION/4) save:YES];
			} else {
				[self setAnchorToRealTime:[anchorRealTimeNum doubleValue] forCycleTime:[anchorCycleTimeNum doubleValue] save:NO];
			}
		} else {			
			[self setAnchorToRealTime:CFAbsoluteTimeGetCurrent() forCycleTime:(MC_DAYTIME_START + MC_DAYTIME_DURATION/4) save:YES];
		}
		
		[self updateCurrentCycleTimeBasedOnAnchorVsNow];
		[self updateSceneToCycleTime:currentCycleTime];
		
		[self startAutoCycleProgress];
	}
	return self;
}


- (void) updateCycleTest {
	static double cycleInc = 0;
	cycleInc += 16;
	cycleInc = modulus(cycleInc, MC_CYCLE_DURATION);
	
	[self updateCurrentCycleTimeBasedOnAnchorVsNow];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.05];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[self updateSceneToCycleTime:currentCycleTime];
	[UIView commitAnimations];
	[self performSelector:@selector(updateCycleTest) withObject:nil afterDelay:1];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
		
	if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) ) {
		landscape.view.center = CGPointMake(160, 240);
		//clockButton.frame     = CGRectMake(-10, 410, 80, 80);
		//qbHolder.frame        = CGRectMake(0, 400, 320, 80);
		clockButton.center      = CGPointMake(30, 450);
		qbHolder.center         = CGPointMake(160, 440);
	} else {
		landscape.view.center = CGPointMake(240, 160);
		//clockButton.frame     = CGRectMake(-10, 250, 80, 80);
		//qbHolder.frame        = CGRectMake(80, 240, 320, 80);
		clockButton.center      = CGPointMake(30, 290);
		qbHolder.center         = CGPointMake(160, 280);
	}
}


- (CycleTimestamp_t) timestampForCycleTime:(double)cycleTime {
	if (cycleTime < 0) cycleTime += (MC_CYCLE_DURATION * 1000);
	cycleTime = modulus(cycleTime, MC_CYCLE_DURATION);
	CycleTimestamp_t timestamp;
	
	if (cycleTime < MC_DAYTIME_START) {
		timestamp.phase = TOD_PHASE_SUNRISE;
		timestamp.progress = (float)cycleTime / MC_SUNRISE_DURATION;
	} else if (cycleTime < MC_SUNSET_START) {
		timestamp.phase = TOD_PHASE_DAY;
		timestamp.progress = ((float)cycleTime - MC_DAYTIME_START) / MC_DAYTIME_DURATION;
	} else if (cycleTime < MC_NIGHTTIME_START) {
		timestamp.phase = TOD_PHASE_SUNSET;
		timestamp.progress = ((float)cycleTime - MC_SUNSET_START) / MC_SUNSET_DURATION;
	} else {
		timestamp.phase = TOD_PHASE_NIGHT;
		timestamp.progress = ((float)cycleTime - MC_NIGHTTIME_START) / MC_NIGHTTIME_DURATION;
	}
		
	return timestamp;
}


- (void) setTimeLabelTextToCycleTime:(double)cycleTime {
	if (cycleTime < 0) cycleTime += (MC_CYCLE_DURATION * 1000);
	cycleTime = modulus(cycleTime, MC_CYCLE_DURATION);
	CycleTimestamp_t ts = [self timestampForCycleTime:cycleTime];
	
	int secondsRemain = 0;
	NSString *nextPhase = nil;
	
	switch (ts.phase) {
		case TOD_PHASE_SUNRISE:
			secondsRemain = (int)(MC_SUNRISE_DURATION - cycleTime);
			nextPhase = @"Daylight";
			break;
			
		case TOD_PHASE_DAY:
			secondsRemain = (int)(MC_DAYTIME_DURATION - (cycleTime - MC_DAYTIME_START));
			nextPhase = @"Sunset";
			break;
			
		case TOD_PHASE_SUNSET:
			secondsRemain = (int)(MC_SUNSET_DURATION - (cycleTime - MC_SUNSET_START));
			nextPhase = @"Nighttime";
			break;
			
		case TOD_PHASE_NIGHT:
			secondsRemain = (int)(MC_NIGHTTIME_DURATION - (cycleTime - MC_NIGHTTIME_START));
			nextPhase = @"Sunrise";
			break;
	}
	
	NSString *label = [NSString stringWithFormat:@"%@ in: %d:%02d", nextPhase, secondsRemain / 60, secondsRemain % 60];
	timeLeftLabel.text = label;
	timeLeftBlack.text = label;
}


- (void) updateLandscapeToCycleTime:(double)cycleTime {	
	CycleTimestamp_t ts = [self timestampForCycleTime:cycleTime];
	double canaryTOD = [landscape canarryTODForPhase:ts.phase progress:ts.progress];
	[landscape setCanaryTOD:canaryTOD];
}


- (void) updateSceneToCycleTime:(double)cycleTime {
	currentCycleTime = cycleTime;
	
	[self updateLandscapeToCycleTime:cycleTime];
	
	[self setTimeLabelTextToCycleTime:cycleTime];
	
	if (cycleTime < (MC_SUNRISE_DURATION*3/4) || cycleTime > (MC_SUNSET_START + (MC_SUNSET_DURATION/4))) {
		timeLeftLabel.alpha = 1;
	} else {
		timeLeftLabel.alpha = 0;
	}
}


- (void) setAnchorToRealTime:(double)realTime forCycleTime:(double)cycleTime save:(BOOL)save {
	anchorRealTime = realTime;
	anchorCycleTime = cycleTime;
	
	if (save) {
		PersistentDictionary *cycleDic = [PersistentDictionary dictionaryWithName:@"cycleDic"];
		[cycleDic.dictionary setObject:[NSNumber numberWithDouble:anchorRealTime]  forKey:@"anchorRealTime"];
		[cycleDic.dictionary setObject:[NSNumber numberWithDouble:anchorCycleTime] forKey:@"anchorCycleTime"];
		[cycleDic saveToFile];
	}
}


- (void) updateCurrentCycleTimeBasedOnAnchorVsNow {
	double nowtime = CFAbsoluteTimeGetCurrent();
	double timesinceanchor = nowtime - anchorRealTime;
	currentCycleTime = modulus( (timesinceanchor + anchorCycleTime) , MC_CYCLE_DURATION );
}


- (void) handleAutoCycleTimer:(NSTimer*)timer {
	[self updateCurrentCycleTimeBasedOnAnchorVsNow];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.05];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[self updateSceneToCycleTime:currentCycleTime];
	[UIView commitAnimations];
}


- (void) startAutoCycleProgress {
	[cycleTimer invalidate];
	cycleTimer = [NSTimer scheduledTimerWithTimeInterval:1.001 target:self selector:@selector(handleAutoCycleTimer:) userInfo:nil repeats:YES];
}


- (void) stopAutoCycleProgress {
	[cycleTimer invalidate];
	cycleTimer = nil;
}



- (void) quickSkipToCycleTime:(NSNumber*)targetCycleTimeNum {
	double targetCycleTime = [targetCycleTimeNum doubleValue];
	
	/* Stop auto timer */
	[self stopAutoCycleProgress];
	
	/* Animate to time */
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.8];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[self updateSceneToCycleTime:targetCycleTime];
	[UIView commitAnimations];
	
	/* And reset the anchor */
	[self setAnchorToRealTime:CFAbsoluteTimeGetCurrent() forCycleTime:targetCycleTime save:YES];
	
	/* And start up the timer after the animation */
	[self performSelector:@selector(startAutoCycleProgress) withObject:nil afterDelay:0.05];
}


- (void) hitQuickButton:(id)sender {
	int targetCycleTime = 0;
	
	static double targetSunrise  = MC_DAYTIME_START;
	static double targetNoon     = MC_DAYTIME_START + (MC_DAYTIME_DURATION/2);
	static double targetMoonrise = MC_NIGHTTIME_START;
	static double targetMidnight = MC_NIGHTTIME_START + (MC_NIGHTTIME_DURATION/2);
		
	double targetArray[4] = { targetSunrise, targetNoon, targetMoonrise, targetMidnight };
	int targetPhase = 3;
	
		 if (sender == qbSunrise)  { targetCycleTime = targetSunrise;      targetPhase = 0; }
	else if (sender == qbNoon)     { targetCycleTime = targetNoon;         targetPhase = 1; }
	else if (sender == qbMoonrise) { targetCycleTime = targetMoonrise;     targetPhase = 2; }
	else if (sender == qbMidnight) { targetCycleTime = targetMidnight;     targetPhase = 3; }
	
	int currentPhase = 3;
	if (currentCycleTime >= targetSunrise  && currentCycleTime < targetNoon)     currentPhase = 0;
	if (currentCycleTime >= targetNoon     && currentCycleTime < targetMoonrise) currentPhase = 1;
	if (currentCycleTime >= targetMoonrise && currentCycleTime < targetMidnight) currentPhase = 2;
	
	
	if (abs(targetPhase - currentPhase) != 2) {
		[self quickSkipToCycleTime:[NSNumber numberWithDouble:targetCycleTime]];
	} else {
		[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
		
		double firstTime = targetArray[ (currentPhase+1) % 4 ];
		[self quickSkipToCycleTime:[NSNumber numberWithDouble:firstTime]];
		
		double secondTime = targetArray[ (currentPhase+2) % 4 ];
		[self performSelector:@selector(quickSkipToCycleTime:) withObject:[NSNumber numberWithDouble:secondTime] afterDelay:0.8];
		
		[[UIApplication sharedApplication] performSelector:@selector(endIgnoringInteractionEvents) withObject:nil afterDelay:1.2];
	}
	
}


- (void) animateQuickButtons:(BOOL)show {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	
	CATransform3D qbXform = show    ? CATransform3DIdentity : CATransform3DMakeTranslation(0, 160, 0);
	CATransform3D cbXform = (!show) ? CATransform3DIdentity : CATransform3DMakeTranslation(0, 160, 0);
	
	qbHolder.layer.transform    = qbXform;
	clockButton.layer.transform = cbXform;
	
	[UIView commitAnimations];
}


- (void) handleClockClick:(id)sender {
	[self animateQuickButtons:YES];
}


- (void)dealloc {
	[landscape autorelease];
    [super dealloc];
}


#pragma mark TwoFingerDragDelegate methods

- (void) acceptTwoFingerDragWithOffset:(CGSize)offset {
	//NSLog(@"drag ->");
	currentCycleTime += offset.width * 2;
	[self updateSceneToCycleTime:currentCycleTime];
}

- (void) twoFingerDragStart {
	//NSLog(@"drag start");
	[self stopAutoCycleProgress];	
}

- (void) twoFingerDragEnd {
	//NSLog(@"drag end");
	[self setAnchorToRealTime:CFAbsoluteTimeGetCurrent() forCycleTime:currentCycleTime save:YES];
	[self startAutoCycleProgress];
}

- (void) oneFingerDown {
	[self animateQuickButtons:NO];
}



@end
