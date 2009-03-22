//
//  IXFadePanel.m
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 2/16/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import "IXFadePanel.h"


@implementation IXFadePanel
- (BOOL)windowShouldClose:(id)sender
{
    timer = [[NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(fade) userInfo:nil repeats:YES] retain];
	NSLog(@"start fading");
    return NO;
}
- (void)fade
{
    if ([self alphaValue] > 0.0) {
        // If window is still partially opaque, reduce its opacity.
        [self setAlphaValue:[self alphaValue] - 0.2];
    } else {
        // Otherwise, if window is completely transparent, destroy the timer and close the window.
		[self endTimer];
        [self close];
        
        // Make the window fully opaque again for next time.
        [self setAlphaValue:1.0];
    }
}
-(void)endTimer{
	[timer invalidate];
	[timer release];
	timer = nil;
	
}
@end
