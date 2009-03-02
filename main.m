#import <UIKit/UIKit.h>
#import "UIDevice-hardware.h"

@interface TestBedController : UIViewController
@end

@implementation TestBedController
- (void) performAction
{
	CFShow([[UIDevice currentDevice] model]);
	printf("--\n");
	CFShow([[UIDevice currentDevice] platform]);
	printf("--\n");
	CFShow([[UIDevice currentDevice] platformString]);
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
