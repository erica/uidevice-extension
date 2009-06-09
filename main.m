#import <UIKit/UIKit.h>
#import "UIDevice-Hardware.h"
#import "UIDevice-Reachability.h"
#import "UIDevice-IOKitExtensions.h"
#import "UIApplication-Proximity.h"

/*
 Things to add: WiFi scanning, Cell Tower scanning, Bluetooth?
 Add hasBluetooth for device capabilities in some way? Different bluetooth types?
*/

@interface TestBedController : UIViewController
@end

@implementation TestBedController
- (void) performAction
{
	// Some core device info
	CFShow([[UIDevice currentDevice] model]);
	CFShow([[UIDevice currentDevice] platformString]);
	// CFShow([[UIDevice currentDevice] platform]);
	
	NSLog(@"CPU Freq %d", [[UIDevice currentDevice] cpuFrequency]);
	NSLog(@"Bus Freq %d", [[UIDevice currentDevice] busFrequency]);
	NSLog(@"Tot. Mem %d", [[UIDevice currentDevice] totalMemory]);
	NSLog(@"User Mem %d", [[UIDevice currentDevice] userMemory]);

#if SUPPORTS_IOKIT_EXTENSIONS
	// Show IOKit 
	CFShow([[UIDevice currentDevice] imei]);
	CFShow([[UIDevice currentDevice] serialnumber]);
	CFShow([[UIDevice currentDevice] backlightlevel]);
#endif
	
	// Perform some connectivity checks
	printf("hostname: ");
	CFShow([[UIDevice currentDevice] hostname]);
	
#if SUPPORTS_UNDOCUMENTED_API
	printf("Names: ");
	CFShow([[NSHost currentHost] names]);
	CFShow([[NSHost currentHost] name]);
#endif
	
	printf("localipaddy: ");
	CFShow([[UIDevice currentDevice] localIPAddress]);	
	printf("localWifiIPAddy: ");
	CFShow([[UIDevice currentDevice] localWiFiIPAddress]);
	
#if SUPPORTS_UNDOCUMENTED_API
	printf("current host addys: ");
	CFShow([[NSHost currentHost] addresses]);
	
	printf("current host addy: ");
	CFShow([[NSHost currentHost] address]);
#endif
	
	// Need to put this into an asynch solution
	// printf("whatismyipdotcom: ");
	// CFShow([[UIDevice currentDevice] whatismyipdotcom]);
	
	printf("macaddy: ");
	CFShow([[UIDevice currentDevice] macaddress]);
	/*
	[(UITextView *)self.view setText:[NSString stringWithFormat:@"Hostname: %@\nIP: %@\nMy IP: %@",
									  [[UIDevice currentDevice] hostname],
									  [[UIDevice currentDevice] localIPAddress],
									  [[UIDevice currentDevice] whatismyipdotcom]
									  ]];
	
	printf("Has WLAN: %s\n", [[UIDevice currentDevice] activeWLAN] ? "Yes" : "No");
	
#if SUPPORTS_UNDOCUMENTED_API
	printf("Has WWAN: %s\n", [[UIDevice currentDevice] activeWWAN] ? "Yes" : "No");
#endif
	 */
}

- (void)loadView
{
	UITextView *contentView = [[UITextView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.editable = NO;
	contentView.font = [UIFont systemFontOfSize:20.0f];
	self.view = contentView;
	contentView.backgroundColor = [UIColor whiteColor];
    [contentView release];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Action" 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(performAction)] autorelease];
	[self performSelector:@selector(performAction) withObject:nil afterDelay:0.5f];
}
@end

#if SUPPORTS_UNDOCUMENTED_APPLICATION_PROXIMITY
@interface TestBedAppDelegate : NSObject <UIApplicationDelegate, ProximityDelegate>
@end
@implementation TestBedAppDelegate

- (void) proximityStateDidChange: (NSNumber *) newSetting
{
	BOOL isOn = [newSetting boolValue];
	printf("Proximity sensor triggered: %s\n", isOn ? "on" : "off");
}

- (void)applicationDidFinishLaunching:(ProximityApplication *)application {	
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[TestBedController alloc] init]];
	[window addSubview:nav.view];
	[window makeKeyAndVisible];
	
	[UIDevice currentDevice].proximityMonitoringEnabled = YES; 
	application.proximityClient = self;
}
@end

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, @"ProximityApplication", @"TestBedAppDelegate");
	[pool release];
	return retVal;
}

#else

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@end
@implementation TestBedAppDelegate
- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[TestBedController alloc] init]];
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
#endif