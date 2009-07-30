/* GrowlController */

#import <Cocoa/Cocoa.h>
#import <Growl-WithInstaller/Growl.h>

@interface IXTototlGrowlController : NSObject <GrowlApplicationBridgeDelegate> {

}
- (void)growl:(NSString *)message withTitle:(NSString *)aTitle;
- (void)growl:(NSString *)message withTitle:(NSString *)aTitle isStycky:(BOOL)sticky;
- (void)growl:(NSString *)message withTitle:(NSString *)aTitle andIcon:(NSData *)aIcon;
- (void)growl:(NSString *)message withTitle:(NSString *)aTitle andIcon:(NSData *)aIcon isStycky:(BOOL)sticky;


/**
 * @name        Accessing the Shared Instance
 */

/**
 * @brief       The shared accounts controller 
 *              All interaction with accounts should be done through this controller.
 */
+ (IXTototlGrowlController *)sharedController;
@end
