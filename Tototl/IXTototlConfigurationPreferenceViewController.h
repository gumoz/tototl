//
//  IXTototlConfigurationPreferenceViewController.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/14/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MBPreferencesController.h"

@interface IXTototlConfigurationPreferenceViewController : NSViewController <MBPreferencesModule> {

}
- (NSString *)identifier;
- (NSImage *)image;

@end
