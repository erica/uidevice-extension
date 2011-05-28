/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

typedef enum {
	UIDeviceUnknown                 = 0x000000,
	
	UIDeviceiPhoneSimulatoriPhone   = 0x000001, // both regular and iPhone 4 devices
	UIDeviceiPhoneSimulatoriPad     = 0x000002,
	
	UIDevice1GiPhone                = 0x000004,
	UIDevice3GiPhone                = 0x000008,
	UIDevice3GSiPhone               = 0x000010,
	UIDevice4iPhoneGSM              = 0x000020,
	UIDevice4iPhoneCDMA             = 0x000040,
	UIDevice5iPhone                 = 0x000080,
	
	UIDevice1GiPod                  = 0x000100,
	UIDevice2GiPod                  = 0x000200,
	UIDevice3GiPod                  = 0x000300,
	UIDevice4GiPod                  = 0x000400,
	
	UIDevice1GiPad                  = 0x000800, // both regular and 3G
	UIDevice2GiPadWiFi              = 0x001000,
	UIDevice2GiPad3GGSM             = 0x002000,
	UIDevice2GiPad3GCDMA            = 0x004000,
	
	UIDeviceAppleTV2                = 0x008000,
	
	UIDeviceUnknownSimulator        = 0x010000,
	UIDeviceUnknowniPhone           = 0x020000,
	UIDeviceUnknowniPod             = 0x040000,
	UIDeviceUnknowniPad             = 0x080000,
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
