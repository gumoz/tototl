//
//  TototlStatusItemViewController.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 12/1/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AppController;
@interface TototlStatusItemViewController : NSViewController {

	NSStatusItem *statusItem;
	NSNumber *connection;
	BOOL clicked;
	__weak AppController *controller;
}
@property (retain, readwrite) 	NSStatusItem *statusItem;
@property (copy, readwrite) 		NSNumber *connection;
@property (retain, readwrite)  AppController *controller;
@end
