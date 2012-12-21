//
//  UIDarkenedImageView.m
//  MinecraftCompanion
//
//  Created by Jason Fieldman on 9/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIDarkenedImageView.h"


@implementation UIDarkenedImageView
@synthesize originalImage;
@synthesize lightness;

- (id) initWithImage:(UIImage*)image {
	if (self = [super initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)]) {
		originalImage = [image retain];
		lightness = 1;
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	CGContextRef c = UIGraphicsGetCurrentContext();
	
	CGRect bnds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	
	/* Draw the image into the transparent context */
	[originalImage drawInRect:bnds];
	
	/* This makes the black draw only on alpha'd pixels */	
	CGContextSetBlendMode(c, kCGBlendModeSourceIn);
	
	CGContextSetRGBFillColor(c, 0, 0, 0, 1);
	CGContextFillRect(c, bnds);	
	
	/* Now draw the original over the black, with alpha */
	[originalImage drawInRect:bnds blendMode:kCGBlendModeNormal alpha:lightness];
}


- (void) setOriginalImage:(UIImage *)image {
	[originalImage autorelease];
	originalImage = [image retain];
	//[self setNeedsDisplay];
}


- (void) setLightness:(float)light {
	lightness = light;
	//[self setNeedsDisplay];
}


- (void)dealloc {
	[originalImage autorelease];
    [super dealloc];
}


@end
