//
//  IXFeedbackController.h
//  Tototl
//
//  Created by Gustavo Moya Ortiz on 2/15/09.
//  Copyright 2009 Ixaya. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IXFeedbackController : NSObject {

	IBOutlet NSTextField *nameField;
	IBOutlet NSTextField *emailField;
	IBOutlet NSComboBox *categoryField;
	IBOutlet NSTextField *feedbackField;
	IBOutlet NSButton *contactCheck;
}
-(IBAction)sendFeedback:(id)sender;
@end
