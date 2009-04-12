/* Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson */

/*
 - Bluetooth? Screen pixels? Dot pitch? Accelerometer? GPS disabled in Egypt (and others?). - @halm
*/

#import "UIDevice-hardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <mach/mach_host.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>

@implementation UIDevice (Hardware)

/*
 Platforms
 iPhone1,1 -> iPhone 1G
 iPhone1,2 -> iPhone 3G 
 iPod1,1   -> iPod touch 1G 
 iPod2,1   -> iPod touch 2G 
*/


#pragma mark sysctlbyname utils
- (NSString *) getSysInfoByName:(char *)typeSpecifier
{
	size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
	NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
	free(answer);
	return results;
}

- (NSString *) platform
{
	return [self getSysInfoByName:"hw.machine"];
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
	size_t size = sizeof(int);
	int results;
	int mib[2] = {CTL_HW, typeSpecifier};
	sysctl(mib, 2, &results, &size, NULL, 0);
	return results;
}

- (NSUInteger) cpuFrequency
{
	return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
	return [self getSysInfo:HW_BUS_FREQ];
}

- (NSUInteger) pageSize
{
	return [self getSysInfo:HW_PAGESIZE];
}

- (NSUInteger) totalMemory
{
	return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) userMemory
{
	return [self getSysInfo:HW_USERMEM];
}

- (NSUInteger) maxSocketBufferSize
{
	return [self getSysInfo:KIPC_MAXSOCKBUF];
}

#pragma mark platform type and name utils
- (int) platformType
{
	NSString *platform = [self platform];
	if ([platform isEqualToString:@"iPhone1,1"]) return UIDevice1GiPhone;
	if ([platform isEqualToString:@"iPhone1,2"]) return UIDevice3GiPhone;
	if ([platform isEqualToString:@"iPod1,1"])   return UIDevice1GiPod;
	if ([platform isEqualToString:@"iPod2,1"])   return UIDevice2GiPod;
	if ([platform hasPrefix:@"iPhone"]) return UIDeviceUnknowniPhone;
	if ([platform hasPrefix:@"iPod"]) return UIDeviceUnknowniPod;
	return UIDeviceUnknown;
}

- (NSString *) platformString
{
	switch ([self platformType])
	{
		case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
		case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
		case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
		
		case UIDevice1GiPod: return IPOD_1G_NAMESTRING;
		case UIDevice2GiPod: return IPOD_2G_NAMESTRING;
		case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;

		default: return nil;
	}
}

#pragma mark  platform capabilities
- (int) platformCapabilities
{
	switch ([self platformType])
	{
		case UIDevice1GiPhone: return UIDeviceBuiltInSpeaker | UIDeviceBuiltInCamera | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone | UIDeviceSupportsTelephony | UIDeviceSupportsVibration;
		case UIDevice3GiPhone: return UIDeviceSupportsGPS | UIDeviceBuiltInSpeaker | UIDeviceBuiltInCamera | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone | UIDeviceSupportsTelephony | UIDeviceSupportsVibration;
		case UIDeviceUnknowniPhone: return UIDeviceBuiltInSpeaker | UIDeviceBuiltInCamera | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone | UIDeviceSupportsTelephony | UIDeviceSupportsVibration;

		case UIDevice1GiPod: return 0;
		case UIDevice2GiPod: return UIDeviceBuiltInSpeaker | UIDeviceBuiltInMicrophone | UIDeviceSupportsExternalMicrophone;
		case UIDeviceUnknowniPod: return 0;
		
		default: return 0;
	}
}

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

#if ! defined(IFT_ETHER)
	#define IFT_ETHER 0x6	// Ethernet CSMACD
#endif

// Matt Brown's get WiFi IP addy solution
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

// Return the local Mac addy
// Courtesy of FreeBSD hackers email list
- (NSString *) macaddress
{
	int					mib[6];
	size_t				len;
	char				*buf;
	unsigned char		*ptr;
	struct if_msghdr	*ifm;
	struct sockaddr_dl	*sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		printf("Error: if_nametoindex error\n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 1\n");
		return NULL;
	}
	
	if ((buf = malloc(len)) == NULL) {
		printf("Could not allocate memory. error!\n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		printf("Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
	return [outstring uppercaseString];
}

@end
