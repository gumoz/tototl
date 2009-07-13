//
//  TototlStatusItem.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 12/1/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@class AppController;
@interface TototlStatusItemView : NSView {
    __weak AppController *controller;
    BOOL clicked;

}
- (id)initWithFrame:(NSRect)frame controller:(AppController *)ctrlr;
- (void) handleSingleClick:(NSEvent *)inEvent;
- (void) handleDoubleClick:(NSEvent *)inEvent;
@end
