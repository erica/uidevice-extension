#import <UIKit/UIKit.h>
#import "UIDevice-hardware.h"

@interface TestBedController : UIViewController
@end

@implementation TestBedController
- (void) performAction
{
	CFShow([[UIDevice currentDevice] model]);
	// CFShow([[UIDevice currentDevice] platform]);
	CFShow([[UIDevice currentDevice] platformString]);
	// NSLog(@"%d", [[UIDevice currentDevice] cpuFrequency]);
	// NSLog(@"%d", [[UIDevice currentDevice] busFrequency]);
	// NSLog(@"%d", [[UIDevice currentDevice] pageSize]);
	// NSLog(@"%d", [[UIDevice currentDevice] totalMemory]);
	// NSLog(@"%d", [[UIDevice currentDevice] userMemory]);
	// NSLog(@"%d", [[UIDevice currentDevice] maxSocketBufferSize]);
	CFShow([[UIDevice currentDevice] hostname]);
	CFShow([[UIDevice currentDevice] localIPAddress]);	
	CFShow([[UIDevice currentDevice] localWiFiIPAddress]);
	CFShow([[UIDevice currentDevice] macaddress]);
}

- (void)loadView
{
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view = contentView;
	contentView.backgroundColor = [UIColor whiteColor];
    [contentView release];

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Action" 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(performAction)] autorelease];
}
@end


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
