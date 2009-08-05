/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "UIDevice-Reachability.h"
#import "UIDevice-IOKitExtensions.h"
#import "UIDevice-Hardware.h"
#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]
#define CFN(X) [self commasForNumber:X]

@interface TestBedViewController : UIViewController
{
	NSMutableString *log;
	IBOutlet UITextView *textView;
}
@property (retain) NSMutableString *log;
@property (retain) UITextView *textView;
@end

@implementation TestBedViewController
@synthesize log;
@synthesize textView;

- (void) doLog: (NSString *) formatstring, ...
{
	va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	NSString *outstring = [[[NSString alloc] initWithFormat:formatstring arguments:arglist] autorelease];
	va_end(arglist);
	[self.log appendString:outstring];
	[self.log appendString:@"\n"];
	self.textView.text = self.log;
}

- (NSString *) commasForNumber: (long long) num
{
	if (num < 1000) return [NSString stringWithFormat:@"%d", num];
	return	[[self commasForNumber:num/1000] stringByAppendingFormat:@",%03d", (num % 1000)];
}

- (void) action: (UIBarButtonItem *) bbi
{
	self.log = [NSMutableString string];
	
	// TESTING REACHABILITY
	/*
	[self doLog:@"Host Name: %@", [UIDevice hostname]];
	[self doLog:@"Local IP Addy: %@", [UIDevice localIPAddress]];
	[self doLog:@"  Google IP Addy: %@", [UIDevice getIPAddressForHost:@"www.google.com"]];
	[self doLog:@"  Amazon IP Addy: %@", [UIDevice getIPAddressForHost:@"www.amazon.com"]];
	[self doLog:@"Local WiFI Addy: %@", [UIDevice localWiFiIPAddress]];
	if ([UIDevice networkAvailable])
		[self doLog:@"What is My IP: %@", [UIDevice whatismyipdotcom]];
	 */
	
	// TESTING IOKIT
	/*
	[self doLog:[UIDevice imei]];
	[self doLog:[UIDevice serialnumber]];
	 */
	
	// TESTING DEVICE HARDWARE
	[self doLog:@"Device is%@ portrait", [UIDevice currentDevice].isPortrait ? @"" : @" not"];
	[self doLog:@"Orientation: %@", [UIDevice currentDevice].orientationString];
	[self doLog:@"Platform: %@", [UIDevice platform]];
	[self doLog:@"Platform String: %@", [UIDevice platformString]];
	[self doLog:@"Platform Code: %@", [UIDevice platformCode]];
	[self doLog:@"CPU Freq: %d\nBus Freq: %@\nTotal Memory: %@\nUser Memory: %@", CFN([UIDevice cpuFrequency]), CFN([UIDevice busFrequency]), CFN([UIDevice totalMemory]), CFN([UIDevice userMemory])];
	[self doLog:@"Mac addy: %@", [UIDevice macaddress]];
}

- (void) viewDidLoad
{
	self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Action", @selector(action:));
}
@end

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@end

@implementation TestBedAppDelegate
- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[TestBedViewController alloc] init]];
	[window addSubview:nav.view];
	[window makeKeyAndVisible];
}
@end

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
	[pool release];
	return retVal;
}
