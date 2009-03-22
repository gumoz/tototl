//
//  IXFadePanel.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 2/16/09.
//  Copyright 2009 Ixaya. All rights reserved.
//
// code by Matt

#import <Cocoa/Cocoa.h>


@interface IXFadePanel : NSPanel {

    NSTimer *timer;
}
-(void)endTimer;

@end
