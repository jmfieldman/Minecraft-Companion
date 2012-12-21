//
//  UIDarkenedImageView.h
//  MinecraftCompanion
//
//  Created by Jason Fieldman on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIDarkenedImageView : UIView {
	UIImage *originalImage;
	float lightness;
}

@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, assign) float lightness;

- (id) initWithImage:(UIImage*)image;

@end
