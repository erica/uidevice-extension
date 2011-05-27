/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

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

// Nano? Apple TV?
#define APPLETV_2G_NAMESTRING			@"Apple TV 2G"

#define IPOD_FAMILY_UNKNOWN_DEVICE			@"Unknown iOS device"

#define IPHONE_SIMULATOR_NAMESTRING			@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPHONE_NAMESTRING	@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPAD_NAMESTRING	@"iPad Simulator"

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
