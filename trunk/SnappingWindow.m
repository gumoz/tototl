//
//  SnappingWindow.m
//  SnappingWindow
//
//  Created by Matt Gemmell on Sun Jan 19 2003.
//  Use however you like.
//

#import "SnappingWindow.h"

@implementation SnappingWindow


/* init and dealloc */

- (id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    /* Enforce borderless window; allows us to handle dragging ourselves */
    self = [super initWithContentRect:contentRect
                            styleMask:NSBorderlessWindowMask
                              backing:bufferingType defer:flag];
    /* NOTE: a side-effect of using NSBorderlessWindowMask is that the window has NO TITLEBAR.
        This is necessary in order to implement snapping *during* dragging, instead of *after* dragging. */
    
    /* Register to receive notification NSWindowDidMoveNotification.
        Better than setting delegate to self, since we can still have a separate delegate. */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowMoved:)
                                                 name:NSWindowDidMoveNotification
                                               object:self];

    [self setHasShadow:YES];
    
    [self setSnapsToEdges:YES];
    [self setSnapTolerance:50.0];
    [self setPadding:0.0];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSWindowDidMoveNotification
                                                  object:self];
    [super dealloc];
}


/* Mouse event handlers */
/* Since we don't have a titlebar, we handle window-dragging ourselves. */

- (void)mouseDown:(NSEvent *)theEvent
{
    dragStartLocation = [theEvent locationInWindow];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if([theEvent type] == NSLeftMouseDragged) {
        NSPoint origin;
        NSPoint newLocation;

        origin = [self frame].origin;
        newLocation = [theEvent locationInWindow];

        /* Insert custom logic here to only move window if drag occurs within a certain area,
            like a custom titlebar NSView. See comment below for an example. */
        
        /*
        if (!NSPointInRect(dragStartLocation, [yourCustomTitlebarView frame])) {
            return;
        }
         */
        
        [self setFrameOrigin:
            NSMakePoint(origin.x + newLocation.x - dragStartLocation.x,
                        origin.y + newLocation.y - dragStartLocation.y)];
    }
}


/* Notification handlers */

- (void)windowMoved:(id)notification
{
    /* Get some useful values */
    NSRect myFrame = [self frame];
    NSPoint aPoint = myFrame.origin;
    float windowX = myFrame.origin.x;
    float windowY = myFrame.origin.y;
    float windowW = myFrame.size.width;
    float windowH = myFrame.size.height;

    NSRect myScreenFrame = [[self screen] frame];
    float screenW = myScreenFrame.size.width;
    float screenH = myScreenFrame.size.height;
    float menuHeight = [NSMenuView menuBarHeight];
    
    /* Don't snap if Option/Alt key is held down during drag.
        Feel free to comment out the "return;" line below if you want to always snap. */
    if ([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask) {
        return;
    }
    
    if ([self snapsToEdges] && (snapping == NO)) {
        snapping = YES; /* so we don't keep getting NSWindowDidMoveNotifications whilst we are snapping the window */
        
        /* Bottom of the screen */
        if (windowY < snapTolerance)
            [self springCoordinate:&(aPoint.y) to:0 + padding inPoint:&aPoint];
        
        /* Left hand side of the screen */
        if (windowX < snapTolerance)
            [self springCoordinate:&(aPoint.x) to:0 + padding inPoint:&aPoint];
        
        /* Right hand side of the screen */
        if (screenW - (windowW + windowX) < snapTolerance)
            [self springCoordinate:&(aPoint.x) to:(screenW - windowW) - padding inPoint:&aPoint];
        
        /* Top of the screen */
        if (screenH - menuHeight - (windowH + windowY) < snapTolerance)
            [self springCoordinate:&(aPoint.y) to:(screenH - menuHeight - windowH) - padding inPoint:&aPoint];
        
        /* Add your custom logic here to deal with snapping to other edges,
            such as the edges of other windows. */
        
        /* Suggestion for custom logic to deal with snapping to other windows:
            1. Get a list of your app's windows, other than this one.
            2. Ignore any that aren't of a type you want this window to snap to.
            3. Loop through them like this:
            3-1. Get the window's frame.
            3-2. Expand its frame by snapTolerance, using NSInsetRect(theWindowFrame, -snapTolerance, -snapTolerance).
            3-3. Check to see if this window's frame intersects with the expanded frame, using NSIntersectsRect()
            3-4. If so, do appropriate snapping.
            4. Optionally, continue looping through all other windows and do appropriate snapping similarly. */
        
        snapping = NO;
    }
}

/* Helper methods  */

- (void)springCoordinate:(float *)start to:(float)dest inPoint:(NSPoint *)pt
{
    *start = dest;
    [self setFrameOrigin:*pt];
}

/* Accessor methods */

- (BOOL)snapsToEdges
{
    return snapsToEdges;
}

- (void)setSnapsToEdges:(BOOL)flag
{
    snapsToEdges = flag;
}

- (float)snapTolerance
{
    return snapTolerance;
}

- (void)setSnapTolerance:(float)tolerance
{
    snapTolerance = tolerance;
}

- (float)padding
{
    return padding;
}

- (void)setPadding:(float)newPadding
{
    padding = newPadding;
}

@end
