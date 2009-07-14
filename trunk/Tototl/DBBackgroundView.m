//
//  DBBackgroundView.m
//  16 January 2007
//
//  Created by Dave Batton
//  http://www.Mere-Mortal-Software.com/
//
//  Documentation for this class is available here:
//  http://www.mere-mortal-software.com/blog/details.php?d=2007-01-17
//
//  Copyright 2007. Some rights reserved.
//  This work is licensed under a Creative Commons license:
//  http://creativecommons.org/licenses/by/2.5/
//


#import "DBBackgroundView.h"


@implementation DBBackgroundView


- (void) dealloc
{
	[self clearBackground];
	[super dealloc];
}




#pragma mark -
#pragma mark Configuration Methods


- (void)clearBackground
{	
	if (_backgroundColor)
		[_backgroundColor release], _backgroundColor = nil;
	if (_backgroundPatternColor)
		[_backgroundPatternColor release], _backgroundPatternColor = nil;
	if (_backgroundImage)
		[_backgroundImage release], _backgroundImage = nil;
	if (_backgroundGradient)
		[_backgroundGradient release], _backgroundGradient = nil;
			
	_gradientAngle = 90;
	_backgroundAlpha = 1.0;
	_backgroundImageAlpha = 1.0;
	_cornerRadius = 0;
}




- (void)setBackgroundColor:(NSColor *)aColor
{
	if (_backgroundColor)
		[_backgroundColor release], _backgroundColor = nil;

    if (aColor)
        _backgroundColor = [aColor retain];
}




- (void)setBackgroundPattern:(NSImage *)anImage;
{
	if (_backgroundPatternColor)
		[_backgroundPatternColor release], _backgroundPatternColor = nil;

	if (anImage)
		_backgroundPatternColor = [[NSColor colorWithPatternImage:anImage] retain];
}




- (void)setBackgroundGradient:(id)aGradient
{
	[self setBackgroundGradient:aGradient withAngle:90];
}




- (void)setBackgroundGradient:(id)aGradient withAngle:(float)anAngle
{
	if (_backgroundGradient)
		[_backgroundGradient release], _backgroundGradient = nil;
	
	if (aGradient)
		_backgroundGradient = [aGradient retain];
	
	_gradientAngle = anAngle;
}




- (void)setBackgroundAlpha:(float)anAlpha
{
	_backgroundAlpha = anAlpha;
	
		// If we let the alpha go to zero, then NSImage's -compositeToPoint:operation:fraction: method will draw it with an alpha of 1.0. We don't want that to happen, so we limit the bottom end to something slightly greater than zero.
	if (_backgroundAlpha == 0.0)
		_backgroundAlpha = 0.01;
}




- (void)setBackgroundImage:(NSImage *)anImage
{
	[self setBackgroundImage:anImage withAlpha:1.0];
}




- (void)setBackgroundImage:(NSImage *)anImage withAlpha:(float)anAlpha
{
	if (_backgroundImage)
		[_backgroundImage release], _backgroundImage = nil;
	
	if (anImage)
        _backgroundImage = [anImage retain];
	
	_backgroundImageAlpha = anAlpha;
	// If we let the alpha go to zero, then NSImage's -compositeToPoint:operation:fraction: method will draw it with an alpha of 1.0. We don't want that to happen, so we limit the bottom end to something slightly greater than zero.
	if (_backgroundImageAlpha == 0.0)
		_backgroundImageAlpha = 0.01;
}




- (void)setBackgroundCornerRadius:(float)aRadius
{
	_cornerRadius = aRadius;
}




#pragma mark -
#pragma mark Drawing Routines

- (void)drawRect:(NSRect)rect
{
	NSBezierPath *aPath = [self createBezierPathForRect:[self bounds]];
	[self drawColor:aPath];
	[self drawPattern:aPath];
	[self drawGradient:aPath];
	[self drawImage:aPath];
	
	(void)rect;  // To avoid the unused parameter warning.
}




- (NSBezierPath *)createBezierPathForRect:(NSRect)rect
{	
		// Make background aPath.
	NSRect bgRect = rect;
	float minX = NSMinX(bgRect);
	float midX = NSMidX(bgRect);
	float maxX = NSMaxX(bgRect);
	float minY = NSMinY(bgRect);
	float midY = NSMidY(bgRect);
	float maxY = NSMaxY(bgRect);
	
	NSBezierPath *bezierPath = [NSBezierPath bezierPath];
	
	// Bottom edge and bottom-right curve.
	[bezierPath moveToPoint:NSMakePoint(midX, minY)];
	[bezierPath appendBezierPathWithArcFromPoint:NSMakePoint(maxX, minY) 
												   toPoint:NSMakePoint(maxX, midY) 
													radius:_cornerRadius];
	
	// Right edge and top-right curve.
	[bezierPath appendBezierPathWithArcFromPoint:NSMakePoint(maxX, maxY) 
												   toPoint:NSMakePoint(midX, maxY) 
													radius:_cornerRadius];
	
	// Top edge and top-left curve.
	[bezierPath appendBezierPathWithArcFromPoint:NSMakePoint(minX, maxY) 
												   toPoint:NSMakePoint(minX, midY) 
													radius:_cornerRadius];
	
	// Left edge and bottom-left curve.
	[bezierPath appendBezierPathWithArcFromPoint:bgRect.origin 
												   toPoint:NSMakePoint(midX, minY) 
													radius:_cornerRadius];
	[bezierPath closePath];
	
	return bezierPath;
}




- (void)drawColor:(NSBezierPath *)aPath
{
	if (_backgroundColor) {
		NSColor *aColor = [_backgroundColor colorWithAlphaComponent:_backgroundAlpha];
		[aColor set];
		[aPath fill];	
	}
}




- (void)drawPattern:(NSBezierPath *)aPath
{
	if (_backgroundPatternColor) {
		if (_backgroundAlpha == 1.0) {
				// If there's no corner radius then we don't need to use the Bezier path, and we can save some memory and speed by just drawing the pattern directly into the view.

				// We're about to mess with the pattern phase. Save the current graphics state first so we can restore it.
			[[NSGraphicsContext currentContext] saveGraphicsState];
			
				// This little trick makes the background pattern appear to draw from the the top-left corner rather than from the bottom-left corner. This is visually important when the view resizes when the window is resized.
			[[NSGraphicsContext currentContext] setPatternPhase:NSMakePoint(0,[self frame].size.height)];
			
			[_backgroundPatternColor set];
			[aPath fill];

				// Restore the original graphics state.
			[[NSGraphicsContext currentContext] restoreGraphicsState];
}
		
		else {
				// If we need to use the Bezier path to clip the corners then we need to get fancy, which means creating an image of the pattern and drawing it just like we do the gradient and image backgrounds.
		
				// Create an image with the pattern at 100% opacity and without rounded corners.
			NSImage *patternImage = [[NSImage alloc] initWithSize:[self bounds].size];
			[patternImage lockFocus];
				// We mess with the pattern phase, just like we did above, but this time we don't need to save and restore the old one since we're not going to keep the image around after we're done with it.
			[[NSGraphicsContext currentContext] setPatternPhase:NSMakePoint(0,[self frame].size.height)];
			[_backgroundPatternColor set];
			NSRectFill([self bounds]);
			[patternImage unlockFocus];
			
				// Clip the corners and draw it in the window with the specified transparency. 
			[self drawImage:patternImage alpha:_backgroundAlpha clippingPath:aPath];
		}
	}
}




- (void)drawImage:(NSBezierPath *)aPath
{
	if (_backgroundImage) {
			// Clip it and draw it in the window.
		[self drawImage:_backgroundImage alpha:_backgroundImageAlpha clippingPath:aPath];
	}
}




- (void)drawGradient:(NSBezierPath *)aPath
{
	if (_backgroundGradient) {
			// Create an image with just the gradient.
		NSImage *gradientImage = [[NSImage alloc] initWithSize:[self bounds].size];
		[gradientImage lockFocus];
		[_backgroundGradient fillRect:[self bounds] angle:_gradientAngle];
		[gradientImage unlockFocus];
		
			// Clip it and draw it in the window. 
		[self drawImage:gradientImage alpha:_backgroundAlpha clippingPath:aPath];
	}
}




- (void)drawImage:(NSImage *)anImage alpha:(float)anAlpha clippingPath:(NSBezierPath *)aPath
{
		// If the image is not as big as the view, we need to stick it in the center of a new image that is.
	NSImage *foregroundImage;
	if (NSEqualSizes([anImage size],[aPath bounds].size))
		foregroundImage = anImage;
	else {
		foregroundImage = [[[NSImage alloc] initWithSize:[self bounds].size] autorelease];
		
			// Find the point at which to draw the image so it's centered.
		NSPoint backgroundCenter;
		backgroundCenter.x = [self bounds].size.width / 2;
		backgroundCenter.y = [self bounds].size.height / 2;
		
		NSPoint drawPoint = backgroundCenter;
		drawPoint.x -= [anImage size].width / 2;
		drawPoint.y -= [anImage size].height / 2;

		[foregroundImage lockFocus];
		[anImage compositeToPoint:drawPoint operation:NSCompositeSourceOver];
		[foregroundImage unlockFocus];
	}
	
		// Draw the Bezier path filled with 100% black.
	NSImage *clippedImage = [[NSImage alloc] initWithSize:[self bounds].size];
	[clippedImage lockFocus];
	[[NSColor blackColor] set];
	[aPath fill];
		
		// Draw the foreground image over it. Notice we're using NSCompositeSourceIn, so it uses the black we just drew as a mask.
	[foregroundImage compositeToPoint:[self bounds].origin operation:NSCompositeSourceIn];
	[clippedImage unlockFocus];
	
		// Draw the combined image into the view with the specified transparency.
	[clippedImage compositeToPoint:[self bounds].origin operation:NSCompositeSourceOver fraction:anAlpha];
}


@end
