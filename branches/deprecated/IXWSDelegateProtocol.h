//
//  IXWebService.m
//  IxayaWebServices
//
//  Created by Gustavo Moya on 4/23/08.
//  Copyright 2008 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol IXWSDelegate

- (void)response:(NSString *)response fromService:(id)service;

@end
