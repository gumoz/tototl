/* HelloGrowlController */

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>
//#import <Growl-WithInstaller/Growl.h>

@interface GrowlController : NSObject <GrowlApplicationBridgeDelegate>
{
	NSString *description;
    NSString *title;
}
- (IBAction)growlIt:(id)sender;
- (void)growl;
- (void)growl:(NSString *)message withTitle:(NSString *)aTitle;
- (void)growl:(NSString *)message withTitle:(NSString *)aTitle andIcon:(NSData *)aIcon;
- (void)growl:(NSString *)message withTitle:(NSString *)aTitle isSticky:(BOOL)sticky;
- (void)growl:(NSString *)message withTitle:(NSString *)aTitle andIcon:(NSData *)aIcon isSticky:(BOOL)sticky;
@end
