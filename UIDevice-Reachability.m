/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License for anything not specifically marked as developed by a third party.
 Apple's code excluded.
 Use at your own risk
 */

#import <SystemConfiguration/SystemConfiguration.h>

#import <arpa/inet.h>
#import <netdb.h>
#import <net/if.h>
#import <ifaddrs.h>
#import <unistd.h>
#import <dlfcn.h>

#import "UIDevice-Reachability.h"
#import "wwanconnect.h"

@implementation UIDevice (Reachability)
SCNetworkConnectionFlags connectionFlags;
SCNetworkReachabilityRef reachability;

#pragma mark Class IP and Host Utilities 
// This IP Utilities are mostly inspired by or derived from Apple code. Thank you Apple.

+ (NSString *) stringFromAddress: (const struct sockaddr *) address
{
	if(address && address->sa_family == AF_INET) {
		const struct sockaddr_in* sin = (struct sockaddr_in*) address;
		return [NSString stringWithFormat:@"%@:%d", [NSString stringWithUTF8String:inet_ntoa(sin->sin_addr)], ntohs(sin->sin_port)];
	}
	
	return nil;
}

+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address
{
	if (!IPAddress || ![IPAddress length]) {
		return NO;
	}
	
	memset((char *) address, sizeof(struct sockaddr_in), 0);
	address->sin_family = AF_INET;
	address->sin_len = sizeof(struct sockaddr_in);
	
	int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
	if (conversionResult == 0) {
		NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
		return NO;
	}
	
	return YES;
}

- (NSString *) hostname
{
	char baseHostName[256]; // Thanks, Gunnar Larisch
	int success = gethostname(baseHostName, 255);
	if (success != 0) return nil;
	baseHostName[255] = '\0';
	
#if TARGET_IPHONE_SIMULATOR
 	return [NSString stringWithFormat:@"%s", baseHostName];
#else
	return [NSString stringWithFormat:@"%s.local", baseHostName];
#endif
}

- (NSString *) getIPAddressForHost: (NSString *) theHost
{
	struct hostent *host = gethostbyname([theHost UTF8String]);
    if (!host) {herror("resolv"); return NULL; }
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
	return addressString;
}

- (NSString *) localIPAddress
{
	struct hostent *host = gethostbyname([[self hostname] UTF8String]);
    if (!host) {herror("resolv"); return nil;}
    struct in_addr **list = (struct in_addr **)host->h_addr_list;
	return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
}

// Matt Brown's get WiFi IP addy solution
// Author gave permission to use in Cookbook under cookbook license
// http://mattbsoftware.blogspot.com/2009/04/how-to-get-ip-address-of-iphone-os-v221.html
- (NSString *) localWiFiIPAddress
{
	BOOL success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
	
	success = getifaddrs(&addrs) == 0;
	if (success) {
		cursor = addrs;
		while (cursor != NULL) {
			// the second test keeps from picking up the loopback address
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) 
			{
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
					return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return nil;
}

- (NSString *) whatismyipdotcom
{
	NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://www.whatismyip.com/automation/n09230945.asp"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:1 error:&error];
	return ip ? ip : [error localizedDescription];
}

- (BOOL) hostAvailable: (NSString *) theHost
{
	
    NSString *addressString = [self getIPAddressForHost:theHost];
    if (!addressString)
    {
        printf("Error recovering IP address from host name\n");
        return NO;
    }
	
    struct sockaddr_in address;
    BOOL gotAddress = [UIDevice addressFromString:addressString address:&address];
	
    if (!gotAddress)
    {
		printf("Error recovering sockaddr address from %s\n", [addressString UTF8String]);
        return NO;
    }
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
    SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags =SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    return isReachable ? YES : NO;;
}

#pragma mark Checking Connections

- (void) pingReachabilityInternal
{
	if (!reachability)
	{
		BOOL ignoresAdHocWiFi = NO;
		struct sockaddr_in ipAddress;
		bzero(&ipAddress, sizeof(ipAddress));
		ipAddress.sin_len = sizeof(ipAddress);
		ipAddress.sin_family = AF_INET;
		ipAddress.sin_addr.s_addr = htonl(ignoresAdHocWiFi ? INADDR_ANY : IN_LINKLOCALNETNUM);

		/* Can also create zero addy
		 struct sockaddr_in zeroAddress;
		 bzero(&zeroAddress, sizeof(zeroAddress));
		 zeroAddress.sin_len = sizeof(zeroAddress);
		 zeroAddress.sin_family = AF_INET; */
		
		reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (struct sockaddr *)&ipAddress);
		CFRetain(reachability);
	}
	
	// Recover reachability flags
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(reachability, &connectionFlags);
	if (!didRetrieveFlags) printf("Error. Could not recover network reachability flags\n");
}

- (BOOL) networkAvailable
{
	[self pingReachabilityInternal];
	BOOL isReachable = ((connectionFlags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((connectionFlags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

- (BOOL) activeWWAN
{
	if (![self networkAvailable]) return NO;
	return ((connectionFlags & kSCNetworkReachabilityFlagsIsWWAN) != 0);
}

- (BOOL) activeWLAN
{
	return ([[UIDevice currentDevice] localWiFiIPAddress] != nil);
}


#pragma mark WiFi Check and Alert
- (void) privateShowAlert: (id) formatstring,...
{
	va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	id outstring = [[[NSString alloc] initWithFormat:formatstring arguments:arglist] autorelease];
	va_end(arglist);
	
    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:outstring message:nil delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil] autorelease];
	[av show];
}

- (BOOL) performWiFiCheck
{
	if (![self networkAvailable] || ![self activeWLAN])
	{
		[self performSelector:@selector(privateShowAlert:) withObject:@"This application requires WiFi. Please enable WiFi in Settings and run this application again." afterDelay:0.5f];
		return NO;
	}
	return YES;
}

#pragma mark Forcing WWAN connection. Courtesy of Apple. Thank you Apple.
MyStreamInfoPtr	myInfoPtr;
static void myClientCallback(void *refCon)
{
	int  *val = (int*)refCon;
	printf("myClientCallback entered - value from refCon is %d\n", *val);
}

- (BOOL) forceWWAN
{
	int value = 0;
	myInfoPtr = (MyStreamInfoPtr) StartWWAN(myClientCallback, &value);
	NSLog(@"%@", myInfoPtr ? @"Started WWAN" : @"Failed to start WWAN");
	return (!(myInfoPtr == NULL));
}

- (void) shutdownWWAN
{
	if (myInfoPtr) StopWWAN((MyInfoRef) myInfoPtr);
}

#pragma mark Monitoring reachability
static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkConnectionFlags flags, void* info)
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	[(id)info performSelector:@selector(reachabilityChanged)];
	[pool release];
}

- (BOOL) scheduleReachabilityWatcher: (id) watcher
{
	if (![watcher conformsToProtocol:@protocol(ReachabilityWatcher)]) 
	{
		NSLog(@"Watcher must conform to ReachabilityWatcher protocol. Cannot continue.");
		return NO;
	}
	
	[self pingReachabilityInternal];

	SCNetworkReachabilityContext context = {0, watcher, NULL, NULL, NULL};
	if(SCNetworkReachabilitySetCallback(reachability, ReachabilityCallback, &context)) 
	{
		if(!SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), kCFRunLoopCommonModes)) 
		{
			NSLog(@"Error: Could not schedule reachability");
			SCNetworkReachabilitySetCallback(reachability, NULL, NULL);
			return NO;
		}
	} 
	else 
	{
		NSLog(@"Error: Could not set reachability callback");
		return NO;
	}
	
	return YES;
}

- (void) unscheduleReachabilityWatcher
{
	SCNetworkReachabilitySetCallback(reachability, NULL, NULL);
	if (SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetCurrent(), kCFRunLoopCommonModes))
		NSLog(@"Unscheduled reachability");
	else
		NSLog(@"Error: Could not unschedule reachability");
	
	CFRelease(reachability);
	reachability = nil;
}

#ifdef SUPPORTS_UNDOCUMENTED_API
#define SBSERVPATH  "/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices"
#define UIKITPATH "/System/Library/Framework/UIKit.framework/UIKit"

// Don't use this code in real life, boys and girls. It is not App Store friendly.
// It is, however, really nice for testing callbacks
+ (void) setAPMode: (BOOL) yorn
{
	mach_port_t *thePort;
	void *uikit = dlopen(UIKITPATH, RTLD_LAZY);
	int (*SBSSpringBoardServerPort)() = dlsym(uikit, "SBSSpringBoardServerPort");
	thePort = (mach_port_t *)SBSSpringBoardServerPort(); 
	dlclose(uikit);
	
	// Link to SBSetAirplaneModeEnabled
	void *sbserv = dlopen(SBSERVPATH, RTLD_LAZY);
	int (*setAPMode)(mach_port_t* port, BOOL yorn) = dlsym(sbserv, "SBSetAirplaneModeEnabled");
	setAPMode(thePort, yorn);
	dlclose(sbserv);
}

// This uses the NSHost class illicitly
+ (BOOL) networkAvailableByNSHost
{
	// Unavailable has only one address: 127.0.0.1
	return !(([[[NSHost currentHost] addresses] count] == 1) && 
			 [[[UIDevice currentDevice] localIPAddress] isEqualToString:@"127.0.0.1"]);
}
#endif
@end