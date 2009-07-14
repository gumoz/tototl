//
//  IXTototlFeedbackPreferenceViewController.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/14/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MBPreferencesController.h"

@interface IXTototlFeedbackPreferenceViewController : NSViewController <MBPreferencesModule> {
	
}
- (NSString *)identifier;
- (NSImage *)image;

@end
