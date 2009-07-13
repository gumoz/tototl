//
//  IXTototlEnvironment.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 7/13/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IXTototlEnvironment : NSObject {

	id preferencesToolbarConfiguration;
}

@property (copy, readwrite) id preferencesToolbarConfiguration;
-(void)load;
@end
