//
//  TwoFingerDragCatcher.h
//  MinecraftCompanion
//
//  Created by Jason Fieldman on 9/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TwoFingerDragDelegate <NSObject>
- (void) twoFingerDragStart;
- (void) acceptTwoFingerDragWithOffset:(CGSize)offset;
- (void) twoFingerDragEnd;

- (void) oneFingerDown;
@end



@interface TwoFingerDragCatcher : UIView {
	/* Drag info */
	id<TwoFingerDragDelegate> dragDelegate;
	CGPoint lastDragPoint;
}


@property (nonatomic, retain) id<TwoFingerDragDelegate> dragDelegate;



@end
