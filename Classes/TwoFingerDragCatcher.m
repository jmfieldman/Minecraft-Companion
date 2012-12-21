//
//  TwoFingerDragCatcher.m
//  MinecraftCompanion
//
//  Created by Jason Fieldman on 9/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwoFingerDragCatcher.h"


@implementation TwoFingerDragCatcher
@synthesize dragDelegate;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
		self.multipleTouchEnabled = YES;
    }
    return self;
}



- (void)dealloc {
	[dragDelegate autorelease];
    [super dealloc];
}


#pragma mark Touch Handlers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSArray *myTouches = [[event touchesForView:self] allObjects];
	int numTouches = [myTouches count];
	if (numTouches == 2) {
		CGPoint currentPoint1 = [[myTouches objectAtIndex:0] locationInView:self];
		CGPoint currentPoint2 = [[myTouches objectAtIndex:1] locationInView:self];
		
		lastDragPoint = CGPointMake((currentPoint1.x + currentPoint2.x)/2, (currentPoint1.y + currentPoint2.y)/2);
		
		[dragDelegate twoFingerDragStart];
	}		
	
	[dragDelegate oneFingerDown];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSArray *myTouches = [[event touchesForView:self] allObjects];
	int numTouches = [myTouches count];
	if (numTouches == 2) {
		CGPoint currentPoint1 = [[myTouches objectAtIndex:0] locationInView:self];
		CGPoint currentPoint2 = [[myTouches objectAtIndex:1] locationInView:self];

		CGPoint curPoint = CGPointMake((currentPoint1.x + currentPoint2.x)/2, (currentPoint1.y + currentPoint2.y)/2);
		CGSize offset = CGSizeMake(curPoint.x - lastDragPoint.x, curPoint.y - lastDragPoint.y);
		
		[dragDelegate acceptTwoFingerDragWithOffset:offset];
		
		lastDragPoint = curPoint;
	}	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSArray *myTouches = [[event touchesForView:self] allObjects];
	int numTouches = [myTouches count];
	if (numTouches == 2) {
		[dragDelegate twoFingerDragEnd];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	NSArray *myTouches = [[event touchesForView:self] allObjects];
	int numTouches = [myTouches count];
	if (numTouches == 2) {
		[dragDelegate twoFingerDragEnd];
	}
}


@end
