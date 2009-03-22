//
//  BGImageTextField.h
//  
//
//  Created by BinaryGod on 2/21/09.
//  Copyright 2009 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BGImageTextFieldCell.h"

@interface BGImageTextField : NSTextField {

	NSTrackingArea *buttonTrackingArea;
	BOOL mouseDown;
	
	id myTarget;
	SEL myAction;

	NSString *buttonImage;
	NSString *alternateButtonImage;
	NSString *titleImage;
}

@property (retain) NSString *buttonImage;
@property (retain) NSString *alternateButtonImage;
@property (retain) NSString *titleImage;

//Button Action/Target
-(SEL)buttonAction;
-(void)setButtonAction:(SEL) newAction;
-(id)buttonTarget;
-(void)setButtonTarget:(id) newTarget;

//Rect Calculation
-(NSRect)calculateButtonFrame;
-(NSRect)calculateImageFrame;
-(NSRect)calculateTextFrame:(NSRect) rect;

-(NSImage *)resizeImage:(NSImage *) sourceImage;

@end
