/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

typedef enum {
	UIDeviceUnknown                 = 0x000000,
	
	UIDeviceSimulatorIPhone         = 0x000001, // both regular and iPhone 4 devices
	UIDeviceSimulatorIPad           = 0x000002,
	
	UIDeviceIPhone1G                = 0x000004,
	UIDeviceIPhone3G                = 0x000008,
	UIDeviceIPhone3GS               = 0x000010,
	UIDeviceIPhone4_GSM             = 0x000020,
	UIDeviceIPhone4_CDMA            = 0x000040,
	UIDeviceIPhone5                 = 0x000080,

	UIDeviceIPod1G                  = 0x000100,
	UIDeviceIPod2G                  = 0x000200,
	UIDeviceIPod3G                  = 0x000300,
	UIDeviceIPod4G                  = 0x000400,
	
	UIDeviceIPad1                   = 0x000800, // both regular and 3G, needs verification.
	UIDeviceIPad2_WiFi              = 0x001000,
	UIDeviceIPad2_3G_GSM            = 0x002000,
	UIDeviceIPad2_3G_CDMA           = 0x004000,
	
	UIDeviceAppleTV2                = 0x008000,
	
	UIDeviceUnknownSimulator        = 0x010000,
	UIDeviceUnknownIPhone           = 0x020000,
	UIDeviceUnknownIPod             = 0x040000,
	UIDeviceUnknownIPad             = 0x080000,
	UIDeviceIFPGA                   = 0x100000,
} UIDevicePlatform;

@interface UIDevice (Hardware)
- (NSString *) platform;
- (NSString *) hwmodel;
- (NSUInteger) platformType;
- (NSString *) platformString;
- (NSString *) platformCode;

- (NSUInteger) cpuFrequency;
- (NSUInteger) busFrequency;
- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;

- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;

- (NSString *) macaddress;
@end
