/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "UIDevice-Hardware.h"


#define IFPGA_NAMESTRING				@"iFPGA"

#define IPHONE_1G_NAMESTRING			@"iPhone 1G"
#define IPHONE_3G_NAMESTRING			@"iPhone 3G"
#define IPHONE_3GS_NAMESTRING			@"iPhone 3GS" 
#define IPHONE_4_GSM_NAMESTRING         @"iPhone 4 (GSM)"
#define IPHONE_4_CDMA_NAMESTRING        @"iPhone 4 (CDMA)"
#define IPHONE_5_NAMESTRING				@"iPhone 5"
#define IPHONE_UNKNOWN_NAMESTRING		@"Unknown iPhone"

#define IPOD_1G_NAMESTRING				@"iPod touch 1G"
#define IPOD_2G_NAMESTRING				@"iPod touch 2G"
#define IPOD_3G_NAMESTRING				@"iPod touch 3G"
#define IPOD_4G_NAMESTRING				@"iPod touch 4G"
#define IPOD_UNKNOWN_NAMESTRING			@"Unknown iPod"

#define IPAD_1G_NAMESTRING				@"iPad 1G"
#define IPAD_2G_WIFI_NAMESTRING			@"iPad 2G (WiFi)"
#define IPAD_2G_3G_GSM_NAMESTRING		@"iPad 2G (3G GSM)"
#define IPAD_2G_3G_CDMA_NAMESTRING		@"iPad 2G (3G CDMA)"
#define IPAD_UNKNOWN_NAMESTRING			@"Unknown iPad"

#define APPLETV_2G_NAMESTRING			@"Apple TV 2G"

#define IPOD_FAMILY_UNKNOWN_DEVICE			@"Unknown iOS device"

#define IPHONE_SIMULATOR_NAMESTRING			@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPHONE_NAMESTRING	@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPAD_NAMESTRING	@"iPad Simulator"

@implementation UIDevice (Hardware)

/*
 Platforms
 
 iFPGA ->		??

 iPhone1,1 ->	iPhone 1G
 iPhone1,2 ->	iPhone 3G
 iPhone2,1 ->	iPhone 3GS
 iPhone3,1 ->	iPhone 4/AT&T (GSM)
 iPhone3,2 ->	??iPhone 4/Unknown
 iPhone3,3 ->	iPhone 4/Verizon Wireless (CDMA)
 iPhone4,1 ->	??iPhone 5

 iPod1,1   -> iPod touch 1G 
 iPod2,1   -> iPod touch 2G 
 iPod2,2   -> ??iPod touch 2.5G
 iPod3,1   -> iPod touch 3G
 iPod4,1   -> iPod touch 4G
 iPod5,1   -> ??iPod touch 5G
 
 iPad1,1   -> iPad 1G, WiFi
 iPad1,?   -> iPad 1G, 3G <- needs 3G owner to test
 iPad2,1   -> iPad 2G, WiFi
 iPad2,2   -> iPad 2G, 3G GSM
 iPad2,3   -> iPad 2G, 3G CDMA
 
 AppleTV2,1 -> AppleTV 2

 i386, x86_64 -> iPhone Simulator
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


// Thanks, Atomicbird
- (NSString *) hwmodel
{
	return [self getSysInfoByName:"hw.model"];
}

#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
	size_t size = sizeof(int);
	int results;
	int mib[2] = {CTL_HW, typeSpecifier};
	sysctl(mib, 2, &results, &size, NULL, 0);
	return (NSUInteger) results;
}

- (NSUInteger) cpuFrequency
{
	return [self getSysInfo:HW_CPU_FREQ];
}

- (NSUInteger) busFrequency
{
	return [self getSysInfo:HW_BUS_FREQ];
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

#pragma mark file system -- Thanks Joachim Bean!
- (NSNumber *) totalDiskSpace
{
	NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
	NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark platform type and name utils
- (NSUInteger) platformType
{
	NSString *platform = [self platform];
	
	if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;

	if ([platform isEqualToString:@"iPhone1,1"])    return UIDeviceIPhone1G;
	if ([platform isEqualToString:@"iPhone1,2"])    return UIDeviceIPhone3G;
	if ([platform hasPrefix:@"iPhone2"])            return UIDeviceIPhone3GS;
	if ([platform isEqualToString:@"iPhone3,1"])    return UIDeviceIPhone4_GSM;
	if ([platform isEqualToString:@"iPhone3,3"])    return UIDeviceIPhone4_CDMA;
	if ([platform hasPrefix:@"iPhone4"])            return UIDeviceIPhone5;
	
	if ([platform isEqualToString:@"iPod1,1"])      return UIDeviceIPod1G;
	if ([platform isEqualToString:@"iPod2,1"])      return UIDeviceIPod2G;
	if ([platform isEqualToString:@"iPod3,1"])      return UIDeviceIPod3G;
	if ([platform isEqualToString:@"iPod4,1"])      return UIDeviceIPod4G;

	/*
	 TODO: MISSING A SOLUTION HERE TO DIFFERENTIATE iPAD 1 and iPAD 1 3G.... SORRY!
	 */
	if ([platform isEqualToString:@"iPad1,1"])      return UIDeviceIPad1;
	if ([platform isEqualToString:@"iPad2,1"])      return UIDeviceIPad2_WiFi;
	if ([platform isEqualToString:@"iPad2,2"])      return UIDeviceIPad2_3G_GSM;
	if ([platform isEqualToString:@"iPad2,3"])      return UIDeviceIPad2_3G_CDMA;

	if ([platform isEqualToString:@"AppleTV2,1"])   return UIDeviceAppleTV2;

	if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknownIPhone;
	if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknownIPod;
	if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknownIPad;
	
	if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"]) // thanks Jordan Breeding
	{
		if ([[UIScreen mainScreen] bounds].size.width < 768)
			return UIDeviceSimulatorIPhone;
		else 
			return UIDeviceSimulatorIPad;

		return UIDeviceUnknownSimulator;
	}

	return UIDeviceUnknown;
}

- (NSString *) platformString
{
	switch ([self platformType])
	{
		case UIDeviceIPhone1G:      return IPHONE_1G_NAMESTRING;
		case UIDeviceIPhone3G:      return IPHONE_3G_NAMESTRING;
		case UIDeviceIPhone3GS:     return IPHONE_3GS_NAMESTRING;
		case UIDeviceIPhone4_GSM:   return IPHONE_4_GSM_NAMESTRING;
		case UIDeviceIPhone4_CDMA:  return IPHONE_4_CDMA_NAMESTRING;
		case UIDeviceIPhone5:       return IPHONE_5_NAMESTRING;
		
		case UIDeviceIPod1G:        return IPOD_1G_NAMESTRING;
		case UIDeviceIPod2G:        return IPOD_2G_NAMESTRING;
		case UIDeviceIPod3G:        return IPOD_3G_NAMESTRING;
		case UIDeviceIPod4G:        return IPOD_4G_NAMESTRING;

		case UIDeviceIPad1:         return IPAD_1G_NAMESTRING;
		case UIDeviceIPad2_WiFi:    return IPAD_2G_WIFI_NAMESTRING;
		case UIDeviceIPad2_3G_GSM:  return IPAD_2G_3G_GSM_NAMESTRING;
		case UIDeviceIPad2_3G_CDMA: return IPAD_2G_3G_CDMA_NAMESTRING;
			
		case UIDeviceAppleTV2:      return APPLETV_2G_NAMESTRING;
			
		case UIDeviceSimulatorIPhone:   return IPHONE_SIMULATOR_IPHONE_NAMESTRING;
		case UIDeviceSimulatorIPad:     return IPHONE_SIMULATOR_IPAD_NAMESTRING;

        case UIDeviceUnknownIPhone:     return IPHONE_UNKNOWN_NAMESTRING;
		case UIDeviceUnknownIPod:       return IPOD_UNKNOWN_NAMESTRING;
		case UIDeviceUnknownIPad:       return IPAD_UNKNOWN_NAMESTRING;
        case UIDeviceUnknownSimulator:  return IPHONE_SIMULATOR_NAMESTRING;

		case UIDeviceIFPGA:             return IFPGA_NAMESTRING;
			
		default: return IPOD_FAMILY_UNKNOWN_DEVICE;
	}
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
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

	NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
	return [outstring uppercaseString];
}

- (NSString *) platformCode
{
	switch ([self platformType])
	{
		case UIDeviceIPhone1G:      return @"M68";
		case UIDeviceIPhone3G:      return @"N82";
		case UIDeviceIPhone3GS:     return @"N88";
		case UIDeviceIPhone4_GSM:   return @"N89";
		case UIDeviceIPhone4_CDMA:  return @"N92";
		case UIDeviceIPhone5:       return IPHONE_UNKNOWN_NAMESTRING;
			
		case UIDeviceIPod1G:        return @"N45";
		case UIDeviceIPod2G:        return @"N72";
		case UIDeviceIPod3G:        return @"N18";
		case UIDeviceIPod4G:        return @"N80";

		case UIDeviceIPad1:         return @"K48";
		case UIDeviceIPad2_WiFi:    return @"K93";
		case UIDeviceIPad2_3G_GSM:  return @"K94";
		case UIDeviceIPad2_3G_CDMA: return @"K95";

		case UIDeviceAppleTV2:      return @"K66";

		case UIDeviceUnknownIPhone:     return IPHONE_UNKNOWN_NAMESTRING;
		case UIDeviceUnknownIPod:       return IPOD_UNKNOWN_NAMESTRING;
		case UIDeviceUnknownIPad:       return IPAD_UNKNOWN_NAMESTRING;
		case UIDeviceUnknownSimulator:  return IPHONE_SIMULATOR_NAMESTRING;

		default: return IPOD_FAMILY_UNKNOWN_DEVICE;
	}
}

// Illicit Bluetooth check -- cannot be used in App Store
/* 
Class  btclass = NSClassFromString(@"GKBluetoothSupport");
if ([btclass respondsToSelector:@selector(bluetoothStatus)])
{
	printf("BTStatus %d\n", ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0);
	bluetooth = ((int)[btclass performSelector:@selector(bluetoothStatus)] & 1) != 0;
	printf("Bluetooth %s enabled\n", bluetooth ? "is" : "isn't");
}
*/

@end