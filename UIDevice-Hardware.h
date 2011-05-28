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

#define UIDEVICE_PLATFORM_MASK_IPHONE3 (UIDeviceIPhone3G | UIDeviceIPhone3GS)
#define UIDEVICE_PLATFORM_MASK_IPHONE4 (UIDeviceIPhone4_GSM | UIDeviceIPhone4_CDMA)
#define UIDEVICE_PLATFORM_MASK_IPHONE (UIDeviceIPhone1G | UIDEVICE_PLATFORM_IPHONE3 | UIDEVICE_PLATFORM_IPHONE4 | UIDeviceIPhone5 | UIDeviceSimulatorIPhone | UIDeviceUnknownIPhone)
#define UIDEVICE_PLATFORM_MASK_IPOD (UIDeviceIPod1G | UIDeviceIPod2G | UIDeviceIPod3G | UIDeviceIPod4G | UIDeviceUnknownIPod)
#define UIDEVICE_PLATFORM_MASK_IPAD (UIDeviceIPad1 | UIDeviceIPad2_WiFi | UIDeviceIPad2_3G_GSM | UIDeviceIPad2_3G_CDMA | UIDeviceSimulatorIPad | UIDeviceUnknownIPad)
#define UIDEVICE_PLATFORM_MASK_UNKNOWN (UIDeviceUnknownSimulator | UIDeviceUnknownIPhone | UIDeviceUnknownIPod | UIDeviceUnknownIPad)

/* Use these macros to recognize families of devices. Usage:
 * if (UIDEVICE_PLATFORMTYPE_IS_IPHONE([[UIDevice currentDevice] platformType])) {
 *   do_iphone_specific_stuff();
 * }
 */

#define UIDEVICE_PLATFORMTYPE_IS_IPHONE3(type) ((type & UIDEVICE_PLATFORM_MASK_IPHONE3) != 0)
#define UIDEVICE_PLATFORMTYPE_IS_IPHONE4(type) ((type & UIDEVICE_PLATFORM_MASK_IPHONE4) != 0)
#define UIDEVICE_PLATFORMTYPE_IS_IPHONE(type) ((type & UIDEVICE_PLATFORM_MASK_IPHONE) != 0)
#define UIDEVICE_PLATFORMTYPE_IS_IPOD(type) ((type & UIDEVICE_PLATFORM_MASK_IPOD) != 0)
#define UIDEVICE_PLATFORMTYPE_IS_IPAD(type) ((type & UIDEVICE_PLATFORM_MASK_IPAD) != 0)
#define UIDEVICE_PLATFORMTYPE_IS_UNKNOWN(type) ((type & UIDEVICE_PLATFORM_MASK_UNKNOWN) != 0)

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
