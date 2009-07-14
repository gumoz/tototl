//
//  IXTototlEditTwitterAccountWindowController.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/13/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IXTototlEditAccountWindowController.h"

@interface IXTototlEditTwitterAccountWindowController : IXTototlEditAccountWindowController {

	NSArray *deliveryMethods;
}
@property (copy, readwrite) NSArray *deliveryMethods;
-(IBAction)setLocation:(id)sender;
@end
