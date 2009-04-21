/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License for anything not specifically marked as developed by a third party.
 Zach Waugh and Apple's code excluded.
 Use at your own risk
 */

// TTD: Add async version of whatsmyip -- thanks rpetrich

#include <unistd.h>
#include <sys/sysctl.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <netinet/in.h>
#include <ifaddrs.h>

#import "UIDevice-Reachability.h"
#import "wwanconnect.h"

@implementation UIDevice (Reachability)

#pragma mark host and ip utils
- (NSString *) hostname
{
	char baseHostName[255];
	int success = gethostname(baseHostName, 255);
	if (success != 0) return nil;
	baseHostName[255] = '\0';
	
#if !TARGET_IPHONE_SIMULATOR
	return [NSString stringWithFormat:@"%s.local", baseHostName];
#else
	return [NSString stringWithFormat:@"%s", baseHostName];
#endif
}

// Direct from Apple. Thank you Apple
- (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address
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

- (NSString *) getIPAddressForHost: (NSString *) theHost
{
	struct hostent *host = gethostbyname([theHost UTF8String]);
	
    if (host == NULL) {
        herror("resolv");
		return NULL;
	}
	
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0])];
	return addressString;
}

#if ! defined(IFT_ETHER)
#define IFT_ETHER 0x6	// Ethernet CSMACD
#endif

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
				if ([name isEqualToString:@"en0"]) { // found the WiFi adapter
					return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
				}
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return nil;
}

// Return the local IP address
- (NSString *) localIPAddress
{
	struct hostent *host = gethostbyname([[self hostname] UTF8String]);
    if (host == NULL)
	{
        herror("resolv");
		return nil;
	}
    else {
        struct in_addr **list = (struct in_addr **)host->h_addr_list;
		return [NSString stringWithCString:inet_ntoa(*list[0])];
    }
	return nil;
}

// Yet another IP addy getter
// via http://zachwaugh.com/2009/03/programmatically-retrieving-ip-address-of-iphone/
- (NSString *)getWiFiIPAddress
{
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0)
	{
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL)
		{
			if(temp_addr->ifa_addr->sa_family == AF_INET)
			{
				// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
				{
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			
			temp_addr = temp_addr->ifa_next;
		}
	}
	
	// Free memory
	freeifaddrs(interfaces);
	
	return address;
}

- (NSString *) whatismyipdotcom
{
	NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://www.whatismyip.com/automation/n09230945.asp"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:1 error:&error];
	if (!ip) return [error localizedDescription];
	return ip;
}

- (BOOL) activeWLAN
{
	return ([self localWiFiIPAddress] != nil);
}

#pragma mark Forcing WWAN connection

MyStreamInfoPtr	myInfoPtr;

static void myClientCallback(void *refCon)
{
	int  *val = (int*)refCon;
	printf("myClientCallback entered - value from refCon is %d\n", *val);
}

- (void) forceWWAN
{
	int value = 0;
	myInfoPtr = (MyStreamInfoPtr) StartWWAN(myClientCallback, &value);
	if (myInfoPtr)	
	{
		printf("Started WWAN\n");
	}
	else
	{
		printf("Failed to start WWAN\n");
	}
}

- (void) shutdownWWAN
{
	if (myInfoPtr) StopWWAN((MyInfoRef) myInfoPtr);
}

/*
 - (BOOL) hostAvailable: (NSString *) theHost
 {
 
 NSString *addressString = [self getIPAddressForHost:theHost];
 if (!addressString) 
 {
 printf("Error recovering IP address from host name\n");
 return NO;
 }
 
 struct sockaddr_in address;
 BOOL gotAddress = [self addressFromString:addressString address:&address];
 
 if (!gotAddress)
 {
 printf("Error recovering sockaddr address from %s\n", [addressString UTF8String]);
 return NO;
 }
 
 SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
 SCNetworkReachabilityFlags flags;
 
 BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
 CFRelease(defaultRouteReachability);
 
 if (!didRetrieveFlags) 
 {
 printf("Error. Could not recover network reachability flags\n");
 return NO;
 }
 
 BOOL isReachable = flags & kSCNetworkFlagsReachable;
 return isReachable ? YES : NO;;
 }
 
 // Courtesy of Apple
 - (BOOL) connectedToNetwork
 {
 // Create zero addy
 struct sockaddr_in zeroAddress;
 bzero(&zeroAddress, sizeof(zeroAddress));
 zeroAddress.sin_len = sizeof(zeroAddress);
 zeroAddress.sin_family = AF_INET;
 
 // Recover reachability flags
 SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);	
 CFRelease(defaultRouteReachability);
 
 SCNetworkReachabilityFlags flags;
 
 BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
 if (!didRetrieveFlags) 
 {
 printf("Error. Could not recover network reachability flags\n");
 return 0;
 }
 
 BOOL isReachable = flags & kSCNetworkFlagsReachable;
 BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
 // BOOL isEDGE = flags & kSCNetworkReachabilityFlagsIsWWAN;
 return (isReachable && !needsConnection) ? YES : NO;
 }
 */


// Via Joachim Bean
/*
 - (BOOL)isDataSourceAvailable
 {
 static BOOL checkNetwork = YES;
 if (checkNetwork) {
 checkNetwork = NO;
 
 Boolean success;
 const char *host_name = "www.whatismyip.com";
 
 SCNetworkReachabilityRef reachability =
 SCNetworkReachabilityCreateWithName(NULL, host_name);
 SCNetworkReachabilityFlags flags;
 success = SCNetworkReachabilityGetFlags(reachability, &flags);
 _isDataSourceAvailable = success && (flags &
 kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
 
 //If there is no network connection
 if (!_isDataSourceAvailable) {
 UIAlertView *nonetwork = [[UIAlertView alloc] initWithTitle:@"No Network"
 
 message:@"You are not connected to the Internet."
 delegate:nil
 cancelButtonTitle:@"OK"
 otherButtonTitles:nil];
 
 [nonetwork show];
 } else {
 //Connection successful
 }
 }
 return _isDataSourceAvailable;
 }
 */

@end

#if SUPPORTS_UNDOCUMENTED_API
@implementation UIDevice (UIDevice_Undocumented_Reachability)
- (BOOL) networkAvailable
{
	// Unavailable has only one address: 127.0.0.1
	return !(([[[NSHost currentHost] addresses] count] == 1) && [[self localIPAddress] isEqualToString:@"127.0.0.1"]);
}

- (BOOL) activeWWAN
{
	return ([self networkAvailable] && ![self localWiFiIPAddress]);
}
@end
#endif  // SUPPORTS_UNDOCUMENTED_API
