/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "UIDevice-Reachability.h"
#import "UIDevice-IOKitExtensions.h"
#import "UIDevice-Hardware.h"
#import "UIDevice-Capabilities.h"
#import "UIDevice-Orientation.h"

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
	
	NSLog(@"%@", outstring);
	
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
	[[UIDevice currentDevice] scanCapabilities];
	
	// [self doLog:@"Adjusted Orientation Angle: %f\n", [[UIDevice currentDevice] orientationAngleRelativeToOrientation:UIDeviceOrientationLandscapeLeft]];
	
	// TESTING REACHABILITY
	/*
	[self doLog:@"Host Name: %@", [[UIDevice currentDevice] hostname]];
	[self doLog:@"Local IP Addy: %@", [[UIDevice currentDevice] localIPAddress]];
	[self doLog:@"  Google IP Addy: %@", [[UIDevice currentDevice] getIPAddressForHost:@"www.google.com"]];
	[self doLog:@"  Amazon IP Addy: %@", [[UIDevice currentDevice] getIPAddressForHost:@"www.amazon.com"]];
	[self doLog:@"Local WiFI Addy: %@", [[UIDevice currentDevice] localWiFiIPAddress]];
	if ([[UIDevice currentDevice] networkAvailable])
		[self doLog:@"What is My IP: %@", [[UIDevice currentDevice] whatismyipdotcom]];
	 */
	
	// TESTING IOKIT
	/*
	[self doLog:[[UIDevice currentDevice] imei]];
	[self doLog:[[UIDevice currentDevice] serialnumber]];
	 */
	
	// TESTING DEVICE HARDWARE
	[self doLog:@"Platform: %@", [[UIDevice currentDevice] platform]];
	[self doLog:@"Platform String: %@", [[UIDevice currentDevice] platformString]];

	/*
	[self doLog:@"Device is%@ portrait", [UIDevice currentDevice].isPortrait ? @"" : @" not"];
	[self doLog:@"Orientation: %@", [UIDevice currentDevice].orientationString];
	[self doLog:@"Platform: %@", [[UIDevice currentDevice] platform]];
	[self doLog:@"Platform String: %@", [[UIDevice currentDevice] platformString]];
	[self doLog:@"Platform Code: %@", [[UIDevice currentDevice] platformCode]];
	[self doLog:@"CPU Freq: %d\nBus Freq: %@\nTotal Memory: %@\nUser Memory: %@", CFN([[UIDevice currentDevice] cpuFrequency]), CFN([[UIDevice currentDevice] busFrequency]), CFN([[UIDevice currentDevice] totalMemory]), CFN([[UIDevice currentDevice] userMemory])];
	[self doLog:@"Mac addy: %@", [[UIDevice currentDevice] macaddress]];
	 */
}

- (void) viewDidLoad
{
	self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Action", @selector(action:));
	if ([[[UIDevice currentDevice] platformString] hasPrefix:@"iPad"])
	{
		UIImageView *imgView = (UIImageView *)[self.view viewWithTag:999];
		imgView.frame = [[UIScreen mainScreen] applicationFrame];
		imgView.image = [UIImage imageNamed:([[UIDevice currentDevice] isLandscape]) ? @"Default-Landscape.png" : @"Default-Portrait.png"];
	}
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
