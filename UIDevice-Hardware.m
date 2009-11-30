/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

// Thanks to Emanuele Vulcano, Kevin Ballard/Eridius, Ryandjohnson, Matt Brown, etc.
// TTD:  - Bluetooth?  Screen pixels? Dot pitch? Accelerometer? GPS enabled/disabled

#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UIDevice-Hardware.h"

@implementation UIDevice (Hardware)

/*
 Platforms
 
 iFPGA ->		??
 iProd0,1 ->	??
 iProd1,1 ->	??

 iPhone1,1 ->	iPhone 1G
 iPhone1,2 ->	iPhone 3G
 iPhone2,1 ->	iPhone 3GS
 iPhone 3,1 ->	iPhone 4G
 
 iPod1,1   -> iPod touch 1G 
 iPod2,1   -> iPod touch 2G 
 iPod2,2   -> iPod touch 2.5G
 iPod3,1   -> iPod touch 3G
 
 i386 -> iPhone Simulator
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
	NSDictionary *fattributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath:NSHomeDirectory()];
	return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
	NSDictionary *fattributes = [[NSFileManager defaultManager] fileSystemAttributesAtPath:NSHomeDirectory()];
	return [fattributes objectForKey:NSFileSystemFreeSize];
}

#pragma mark platform type and name utils
- (NSUInteger) platformType
{
	NSString *platform = [self platform];
	// if ([platform isEqualToString:@"XX"])			return UIDeviceUnknown;
	
	if ([platform isEqualToString:@"iFPGA"])		return UIDeviceIFPGA;
	if ([platform isEqualToString:@"iProd0,1"])		return UIDeviceiProd1G;
	if ([platform isEqualToString:@"iProd1,1"])		return UIDeviceiProd2G;

	if ([platform isEqualToString:@"iPhone1,1"])	return UIDevice1GiPhone;
	if ([platform isEqualToString:@"iPhone1,2"])	return UIDevice3GiPhone;
	if ([platform isEqualToString:@"iPhone2,1"])	return UIDevice3GSiPhone;
	if ([platform isEqualToString:@"iPhone3,1"])	return UIDevice4GiPhone;
	
	if ([platform isEqualToString:@"iPod1,1"])   return UIDevice1GiPod;
	if ([platform isEqualToString:@"iPod2,1"])   return UIDevice2GiPod;
	if ([platform isEqualToString:@"iPod2,2"])   return UIDevice2GPlusiPod;
	if ([platform isEqualToString:@"iPod3,1"])   return UIDevice3GiPod;
	if ([platform isEqualToString:@"iPod4,1"])   return UIDevice4GiPod;
	
	if ([platform hasPrefix:@"iPhone"]) return UIDeviceUnknowniPhone;
	if ([platform hasPrefix:@"iPod"]) return UIDeviceUnknowniPod;
	
	if ([platform hasSuffix:@"86"]) return UIDeviceiPhoneSimulator;
	return UIDeviceUnknown;
}

- (NSString *) platformString
{
	switch ([self platformType])
	{
		case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
		case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
		case UIDevice3GSiPhone:	return IPHONE_3GS_NAMESTRING;
		case UIDevice4GiPhone:	return IPHONE_4G_NAMESTRING;
		case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
		
		case UIDevice1GiPod: return IPOD_1G_NAMESTRING;
		case UIDevice2GiPod: return IPOD_2G_NAMESTRING;
		case UIDevice3GiPod: return IPOD_3G_NAMESTRING;
		case UIDevice4GiPod: return IPOD_4G_NAMESTRING;
		case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
			
		case UIDeviceiPhoneSimulator: return IPHONE_SIMULATOR_NAMESTRING;
			
		case UIDeviceiProd1G: return IPROD_1G_NAMESTRING;
		case UIDeviceiProd2G: return IPROD_2G_NAMESTRING;
		case UIDeviceIFPGA: return IFPGA_NAMESTRING;

		default: return IPOD_FAMILY_UNKNOWN_DEVICE;
	}
}

#pragma mark  platform capabilities
- (NSUInteger) platformCapabilities
{
	switch ([self platformType])
	{
		case UIDevice1GiPhone: 
			return 
			(UIDeviceSupportsTelephony  |
			 UIDeviceSupportsSMS  |
			 UIDeviceSupportsStillCamera  |
			 // UIDeviceSupportsAutofocusCamera |
			 // UIDeviceSupportsVideoCamera  |
			 UIDeviceSupportsWifi  |
			 UIDeviceSupportsAccelerometer  |
			 UIDeviceSupportsLocationServices  |
			 // UIDeviceSupportsGPS  |
			 // UIDeviceSupportsMagnetometer  |
			 UIDeviceSupportsBuiltInMicrophone  |
			 UIDeviceSupportsExternalMicrophone  |
			 UIDeviceSupportsOPENGLES1_1  |
			 // UIDeviceSupportsOPENGLES2  |
			 UIDeviceBuiltInSpeaker  |
			 UIDeviceSupportsVibration  |
			 UIDeviceBuiltInProximitySensor  |
			 // UIDeviceSupportsAccessibility  |
			 // UIDeviceSupportsVoiceOver |
			 // UIDeviceSupportsVoiceControl |
			 // UIDeviceSupportsPeerToPeer |
			 // UIDeviceSupportsARMV7 |
			 UIDeviceSupportsBrightnessSensor |
			 UIDeviceSupportsEncodeAAC |
			 UIDeviceSupportBluetooth | // M68.plist says YES for this
			 // UIDeviceSupportNike |
			 // UIDeviceSupportPiezoClicker |
			 UIDeviceSupportVolumeButtons
			 );
			
		case UIDevice3GiPhone: 
			return
			(UIDeviceSupportsTelephony  |
			 UIDeviceSupportsSMS  |
			 UIDeviceSupportsStillCamera  |
			 // UIDeviceSupportsAutofocusCamera |
			 // UIDeviceSupportsVideoCamera  |
			 UIDeviceSupportsWifi  |
			 UIDeviceSupportsAccelerometer  |
			 UIDeviceSupportsLocationServices  |
			 UIDeviceSupportsGPS  |
			 // UIDeviceSupportsMagnetometer  |
			 UIDeviceSupportsBuiltInMicrophone  |
			 UIDeviceSupportsExternalMicrophone  |
			 UIDeviceSupportsOPENGLES1_1  |
			 // UIDeviceSupportsOPENGLES2  |
			 UIDeviceBuiltInSpeaker  |
			 UIDeviceSupportsVibration  |
			 UIDeviceBuiltInProximitySensor  |
			 // UIDeviceSupportsAccessibility  |
			 // UIDeviceSupportsVoiceOver |
			 // UIDeviceSupportsVoiceControl |
			 UIDeviceSupportsPeerToPeer |
			 // UIDeviceSupportsARMV7 |
			 UIDeviceSupportsBrightnessSensor |
			 UIDeviceSupportsEncodeAAC |
			 UIDeviceSupportBluetooth |
			 UIDeviceSupportNike |
			 // UIDeviceSupportPiezoClicker |
			 UIDeviceSupportVolumeButtons
			 );
			
		case UIDevice3GSiPhone: 
			return
			(UIDeviceSupportsTelephony  |
			 UIDeviceSupportsSMS  |
			 UIDeviceSupportsStillCamera  |
			 UIDeviceSupportsAutofocusCamera |
			 UIDeviceSupportsVideoCamera  |
			 UIDeviceSupportsWifi  |
			 UIDeviceSupportsAccelerometer  |
			 UIDeviceSupportsLocationServices  |
			 UIDeviceSupportsGPS  |
			 UIDeviceSupportsMagnetometer  |
			 UIDeviceSupportsBuiltInMicrophone  |
			 UIDeviceSupportsExternalMicrophone  |
			 UIDeviceSupportsOPENGLES1_1  |
			 UIDeviceSupportsOPENGLES2  |
			 UIDeviceBuiltInSpeaker  |
			 UIDeviceSupportsVibration  |
			 UIDeviceBuiltInProximitySensor  |
			 UIDeviceSupportsAccessibility  |
			 UIDeviceSupportsVoiceOver |
			 UIDeviceSupportsVoiceControl |
			 UIDeviceSupportsPeerToPeer |
			 UIDeviceSupportsARMV7 |
			 UIDeviceSupportsBrightnessSensor |
			 UIDeviceSupportsEncodeAAC |
			 UIDeviceSupportBluetooth |
			 UIDeviceSupportNike |
			 // UIDeviceSupportPiezoClicker |
			 UIDeviceSupportVolumeButtons
			 );			
		case UIDeviceUnknowniPhone: return 0;
			
		case UIDevice1GiPod: 
			return
			(// UIDeviceSupportsTelephony  |
			 // UIDeviceSupportsSMS  |
			 // UIDeviceSupportsStillCamera  |
			 // UIDeviceSupportsAutofocusCamera |
			 // UIDeviceSupportsVideoCamera  |
			 UIDeviceSupportsWifi  |
			 UIDeviceSupportsAccelerometer  |
			 UIDeviceSupportsLocationServices  |
			 // UIDeviceSupportsGPS  |
			 // UIDeviceSupportsMagnetometer  |
			 // UIDeviceSupportsBuiltInMicrophone  |
			 UIDeviceSupportsExternalMicrophone  |
			 UIDeviceSupportsOPENGLES1_1  |
			 // UIDeviceSupportsOPENGLES2  |
			 // UIDeviceBuiltInSpeaker  |
			 // UIDeviceSupportsVibration  |
			 // UIDeviceBuiltInProximitySensor  |
			 // UIDeviceSupportsAccessibility  |
			 // UIDeviceSupportsVoiceOver |
			 // UIDeviceSupportsVoiceControl |
			 UIDeviceSupportsBrightnessSensor |
			 // UIDeviceSupportsEncodeAAC |
			 // UIDeviceSupportBluetooth |
			 // UIDeviceSupportNike |
			 UIDeviceSupportPiezoClicker |
			 // UIDeviceSupportVolumeButtons
			 );
			
		case UIDevice2GiPod: 
		case UIDevice2GPlusiPod:
			return
			(// UIDeviceSupportsTelephony  |
			 // UIDeviceSupportsSMS  |
			 // UIDeviceSupportsStillCamera  |
			 // UIDeviceSupportsAutofocusCamera |
			 // UIDeviceSupportsVideoCamera  |
			 UIDeviceSupportsWifi  |
			 UIDeviceSupportsAccelerometer  |
			 UIDeviceSupportsLocationServices  |
			 // UIDeviceSupportsGPS  |
			 // UIDeviceSupportsMagnetometer  |
			 // UIDeviceSupportsBuiltInMicrophone  |
			 UIDeviceSupportsExternalMicrophone  |
			 UIDeviceSupportsOPENGLES1_1  |
			 // UIDeviceSupportsOPENGLES2  |
			 UIDeviceBuiltInSpeaker  |
			 // UIDeviceSupportsVibration  |
			 // UIDeviceBuiltInProximitySensor  |
			 // UIDeviceSupportsAccessibility  |
			 // UIDeviceSupportsVoiceOver |
			 // UIDeviceSupportsVoiceControl |
			 UIDeviceSupportsPeerToPeer |
			 // UIDeviceSupportsARMV7 |
			 UIDeviceSupportsBrightnessSensor |
			UIDeviceSupportsEncodeAAC |
			UIDeviceSupportBluetooth |
			UIDeviceSupportNike |
			// UIDeviceSupportPiezoClicker |
			UIDeviceSupportVolumeButtons
			 );
			
			
		case UIDevice3GiPod: 
			return
			(// UIDeviceSupportsTelephony  |
			 // UIDeviceSupportsSMS  |
			 // UIDeviceSupportsStillCamera  |
			 // UIDeviceSupportsAutofocusCamera |
			 // UIDeviceSupportsVideoCamera  |
			 UIDeviceSupportsWifi  |
			 UIDeviceSupportsAccelerometer  |
			 UIDeviceSupportsLocationServices  |
			 // UIDeviceSupportsGPS  |
			 // UIDeviceSupportsMagnetometer  |
			 // UIDeviceSupportsBuiltInMicrophone  |
			 UIDeviceSupportsExternalMicrophone  |
			 UIDeviceSupportsOPENGLES1_1  |
			 UIDeviceSupportsOPENGLES2  |
			 UIDeviceBuiltInSpeaker  |
			 // UIDeviceSupportsVibration  |
			 // UIDeviceBuiltInProximitySensor  |
			 UIDeviceSupportsAccessibility  |
			 UIDeviceSupportsVoiceOver |
			 UIDeviceSupportsVoiceControl |
			 UIDeviceSupportsPeerToPeer |
			 UIDeviceSupportsARMV7 |
			 UIDeviceSupportsBrightnessSensor |
			 UIDeviceSupportsEncodeAAC |
			 UIDeviceSupportBluetooth |
			 UIDeviceSupportNike |
			 // UIDeviceSupportPiezoClicker |
			 UIDeviceSupportVolumeButtons
			 );			
		case UIDeviceUnknowniPod:  return 0;
			
		case UIDeviceiPhoneSimulator: 
			return
			(// UIDeviceSupportsTelephony  |
			 // UIDeviceSupportsSMS  |
			 // UIDeviceSupportsStillCamera  |
			 // UIDeviceSupportsAutofocusCamera |
			 // UIDeviceSupportsVideoCamera  |
			 UIDeviceSupportsWifi  |
			 // UIDeviceSupportsAccelerometer  |
			 UIDeviceSupportsLocationServices  |
			 // UIDeviceSupportsGPS  |
			 // UIDeviceSupportsMagnetometer  |
			 // UIDeviceSupportsBuiltInMicrophone  |
			 // UIDeviceSupportsExternalMicrophone  |
			 UIDeviceSupportsOPENGLES1_1  |
			 // UIDeviceSupportsOPENGLES2  |
			 UIDeviceSupportsAccessibility  | // with limitations
			 UIDeviceSupportsVoiceOver | // with limitations
			 UIDeviceBuiltInSpeaker |
			// UIDeviceSupportsVibration  |
			// UIDeviceBuiltInProximitySensor  |
			// UIDeviceSupportsVoiceControl |
			// UIDeviceSupportsPeerToPeer |
			// UIDeviceSupportsARMV7 |
			// UIDeviceSupportsBrightnessSensor |
			// UIDeviceSupportsEncodeAAC |
			// UIDeviceSupportBluetooth |
			// UIDeviceSupportNike |
			// UIDeviceSupportPiezoClicker |
			// UIDeviceSupportVolumeButtons
			);
		default: return 0;
	}
}

- (NSArray *) capabilityArray
{
	NSUInteger flags = [self platformCapabilities];
	NSMutableArray *array = [NSMutableArray array];
	
	if (flags & UIDeviceSupportsTelephony) [array addObject:@"Telephony"];
	if (flags & UIDeviceSupportsSMS) [array addObject:@"SMS"];
	if (flags & UIDeviceSupportsStillCamera) [array addObject:@"Still Camera"];
	if (flags & UIDeviceSupportsAutofocusCamera) [array addObject:@"AutoFocus Camera"];
	if (flags & UIDeviceSupportsVideoCamera) [array addObject:@"Video Camera"];
	if (flags & UIDeviceSupportsWifi) [array addObject:@"WiFi"];
	if (flags & UIDeviceSupportsAccelerometer) [array addObject:@"Accelerometer"];
	if (flags & UIDeviceSupportsLocationServices) [array addObject:@"Location Services"];
	if (flags & UIDeviceSupportsGPS) [array addObject:@"GPS"];
	if (flags & UIDeviceSupportsMagnetometer) [array addObject:@"Magnetometer"];
	if (flags & UIDeviceSupportsBuiltInMicrophone) [array addObject:@"Built-in Microphone"];
	if (flags & UIDeviceSupportsExternalMicrophone) [array addObject:@"External Microphone Support"];
	if (flags & UIDeviceSupportsOPENGLES1_1) [array addObject:@"OpenGL ES 1.1"];
	if (flags & UIDeviceSupportsOPENGLES2) [array addObject:@"OpenGL ES 2.x"];
	if (flags & UIDeviceBuiltInSpeaker) [array addObject:@"Built-in Speaker"];
	if (flags & UIDeviceSupportsVibration) [array addObject:@"Vibration"];
	if (flags & UIDeviceBuiltInProximitySensor) [array addObject:@"Proximity Sensor"];
	if (flags & UIDeviceSupportsAccessibility) [array addObject:@"Accessibility"];
	if (flags & UIDeviceSupportsVoiceOver) [array addObject:@"VoiceOver"];
	if (flags & UIDeviceSupportsVoiceControl) [array addObject:@"Voice Control"];
	if (flags & UIDeviceSupportsBrightnessSensor) [array addObject:@"Brightness Sensor"];
	if (flags & UIDeviceSupportsPeerToPeer) [array addObject:@"Peer to Peer Bluetooth"];
	if (flags & UIDeviceSupportsARMV7) [array addObject:@"The armv7 instruction set"];
	
	return array;
}

#pragma mark MAC addy
// Return the local MAC addy
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
	sdl = (struct sockaddr_dl *)(ifm - 1);
	ptr = (unsigned char *)LLADDR(sdl);
	NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr-1), *(ptr-2), *(ptr-3), *(ptr-4), *(ptr-5)];
	free(buf);
	return [outstring uppercaseString];
}

- (NSString *) platformCode
{
	switch ([self platformType])
	{
		case UIDevice1GiPhone: return @"M68";
		case UIDevice3GiPhone: return @"N82";
		case UIDevice3GSiPhone:	return @"N88";
		case UIDeviceUnknowniPhone: return nil;
			
		case UIDevice1GiPod: return @"N45";
		case UIDevice2GiPod: return @"N72";
		case UIDevice3GiPod: return @"N18"; 
		case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
			
		case UIDeviceiPhoneSimulator: return IPHONE_SIMULATOR_NAMESTRING;
			
		default: return IPOD_FAMILY_UNKNOWN_DEVICE;
	}
}
@end

@implementation UIDevice (Orientation)
- (BOOL) isLandscape
{
	return (self.orientation == UIDeviceOrientationLandscapeLeft) || (self.orientation == UIDeviceOrientationLandscapeRight);
}

- (BOOL) isPortrait
{
	return (self.orientation == UIDeviceOrientationPortrait) || (self.orientation == UIDeviceOrientationPortraitUpsideDown);
}

- (NSString *) orientationString
{
	switch ([[UIDevice currentDevice] orientation])
	{
		case UIDeviceOrientationUnknown: return @"Unknown";
		case UIDeviceOrientationPortrait: return @"Portrait";
		case UIDeviceOrientationPortraitUpsideDown: return @"Portrait Upside Down";
		case UIDeviceOrientationLandscapeLeft: return @"Landscape Left";
		case UIDeviceOrientationLandscapeRight: return @"Landscape Right";
		case UIDeviceOrientationFaceUp: return @"Face Up";
		case UIDeviceOrientationFaceDown: return @"Face Down";
		default: break;
	}
	return nil;
}
@end