#import "GrowlController.h"

	/*
	*		Define the name of our notification.
	*		------------------------------------
	*
	*		In this example we are (re-)using just one notification 'Name' over and over.
	*
	*		The different types of notifications your application sends are distinguished
	*		by their name.
	*
	*		This differentiation allows the user to customise which of your notification-types
	*		are enabled and also allows them to customise the notifications' appearances separately.
	*
	*/

#define QKPNotification	@"Tototl"

/*	Our Application Controller	*/
@implementation GrowlController

#pragma mark -
#pragma mark Initialisation & De-allocation

//	It's good to be alive...
- (id) init {
	if ((self = [super init])) {

		/*
		 *	Register ourselves as a Growl delegate for registration purposes
		 *	----------------------------------------------------------------
		 *
		 *	The GrowlApplicationBridge (GAB) is how your application communicates with Growl.
		 *
		 *	Using the Delegate Pattern, the GAB will call your delegate object when it needs
		 *	information.
		 */

		[GrowlApplicationBridge setGrowlDelegate:self];
	}
	return self;
}

//	Death comes to us all...
- (void) dealloc {
	[super dealloc];
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
#pragma unused(theApplication)
	return YES;
}

#pragma mark -
#pragma mark Growl Delegate Methods

/*
 *		Registration
 *		------------
 *
 *		When Growl starts, or in certain other situations, the GAB will ask the delegate
 *		for its registrationDictionary.
 *
 *		This dictionary gives Growl the complete list of notifications this application will ever send,
 *		and it also specifies which notifications should be enabled by default.
 *
 *		For most applications, these two arrays can be the same
 *		(if all sent notifications should be displayed by default).
 *
 *		The NSString objects in these arrays are the Notification names
 *
 *		The dictionary should have 2 key object pairs:
 *
 *			GROWL_NOTIFICATIONS_ALL
 *				An NSArray of all possible names of notifications.
 *			GROWL_NOTIFICATIONS_DEFAULT
 *				An NSArray of notifications enabled by default
 *				(either by name, or by index into the GROWL_NOTIFICATIONS_ALL array).
 */

- (NSDictionary *) registrationDictionaryForGrowl {
	NSArray *notifications = [NSArray arrayWithObjects:
		QKPNotification,
		nil];

	NSDictionary *regDict = [NSDictionary dictionaryWithObjectsAndKeys:
		@"Tototl", GROWL_APP_NAME,
		notifications, GROWL_NOTIFICATIONS_ALL,
		notifications, GROWL_NOTIFICATIONS_DEFAULT,
		nil];

	return regDict;
}

- (void) growlNotificationWasClicked:(id)clickContext {
	NSLog(@"Hey - the user clicked one of my notifications - the context is: %@", clickContext);
}

- (void) growlNotificationTimedOut:(id)clickContext {
	NSLog(@"Hey - nobody clicked one of my notifications - the context is: %@", clickContext);
}

#pragma mark -
#pragma mark InterfaceBuilder Actions
- (void) growl {
#pragma unused(sender)
	/*
	 *		Sending a notification.
	 *		-----------------------
	 *
	 *		Call the GrowlApplicationBridge's notifyWithTitle: method
	 *
	 *		To include an image - pass image NSData for the iconData pararmeter
	 *		Priority ranges from -2 (low) to +2 (emergency)
	 *		Sticky makes the notification stay on screen until clicked.
	 *			(Unless over-riden by the user in their preferences.)
	 *
	 *		clickContext will be passed back to the delegate method if the
	 *		user clicks the notification.  If can be anything you want.
	 */

	[GrowlApplicationBridge notifyWithTitle:title
								description:description
						   notificationName:QKPNotification
								   iconData: nil
								   priority:0
								   isSticky:NO
							   clickContext:title];
}
- (void)growl:(NSString *)message withTitle:(NSString *)aTitle
{
	[GrowlApplicationBridge notifyWithTitle:title
								description:message
						   notificationName:QKPNotification
								   iconData: nil
								   priority:0
								   isSticky:NO
							   clickContext:title];
}
- (void)growl:(NSString *)message withTitle:(NSString *)aTitle isSticky:(BOOL)sticky
{
	[GrowlApplicationBridge notifyWithTitle:title
								description:message
						   notificationName:QKPNotification
								   iconData: nil
								   priority:0
								   isSticky:sticky
							   clickContext:title];
	
}

- (void)growl:(NSString *)message withTitle:(NSString *)aTitle andIcon:(NSData *)aIcon
{
	[GrowlApplicationBridge notifyWithTitle:title
								description:message
						   notificationName:QKPNotification
								   iconData: aIcon
								   priority:0
								   isSticky:NO
							   clickContext:title];
	
}
- (void)growl:(NSString *)message withTitle:(NSString *)aTitle andIcon:(NSData *)aIcon isSticky:(BOOL)sticky
{
	[GrowlApplicationBridge notifyWithTitle:title
								description:message
						   notificationName:QKPNotification
								   iconData: aIcon
								   priority:0
								   isSticky:sticky
							   clickContext:title];
	
}
- (IBAction) growlIt:(id)sender {
	[self growl];
}

@end
