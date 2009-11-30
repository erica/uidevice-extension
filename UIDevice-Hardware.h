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
#define IPHONE_4G_NAMESTRING			@"iPhone 4G" 
#define IPHONE_UNKNOWN_NAMESTRING		@"Unknown iPhone"

#define IPOD_1G_NAMESTRING				@"iPod touch 1G"
#define IPOD_2G_NAMESTRING				@"iPod touch 2G"
#define IPOD_2GPLUS_NAMESTRING			@"iPod touch 2G Plus"
#define IPOD_3G_NAMESTRING				@"iPod touch 3G"
#define IPOD_4G_NAMESTRING				@"iPod touch 4G"
#define IPOD_UNKNOWN_NAMESTRING			@"Unknown iPod"

#define IPROD_1G_NAMESTRING				@"iProd 1G"
#define IPROD_2G_NAMESTRING				@"iProd 2G"

#define IPOD_FAMILY_UNKNOWN_DEVICE @"Unknown device in the iPhone/iPod family"

#define IPHONE_SIMULATOR_NAMESTRING	@"iPhone Simulator"

typedef enum {
	UIDeviceUnknown,
	UIDeviceiPhoneSimulator,
	UIDevice1GiPhone,
	UIDevice3GiPhone,
	UIDevice3GSiPhone,
	UIDevice4GiPhone,
	UIDevice1GiPod,
	UIDevice2GiPod,
	UIDevice2GPlusiPod,
	UIDevice3GiPod,
	UIDevice4GiPod,
	UIDeviceUnknowniPhone,
	UIDeviceUnknowniPod,
	UIDeviceIFPGA,
	UIDeviceiProd1G,
	UIDeviceiProd2G,
} UIDevicePlatform;

typedef enum {
	UIDeviceFirmware2,
	UIDeviceFirmware3,
} UIDeviceFirmware;

enum {
	UIDeviceSupportsTelephony = 1 << 0,
	UIDeviceSupportsSMS = 1 << 1,
	UIDeviceSupportsStillCamera = 1 << 2,
	UIDeviceSupportsAutofocusCamera = 1 << 3,
	UIDeviceSupportsVideoCamera = 1 << 4,
	UIDeviceSupportsWifi = 1 << 5,
	UIDeviceSupportsAccelerometer = 1 << 6,
	UIDeviceSupportsLocationServices = 1 << 7,
	UIDeviceSupportsGPS = 1 << 8,
	UIDeviceSupportsMagnetometer = 1 << 9,
	UIDeviceSupportsBuiltInMicrophone = 1 << 10,
	UIDeviceSupportsExternalMicrophone = 1 << 11,
	UIDeviceSupportsOPENGLES1_1 = 1 << 12,
	UIDeviceSupportsOPENGLES2 = 1 << 13,
	UIDeviceBuiltInSpeaker = 1 << 14,
	UIDeviceSupportsVibration = 1 << 15,
	UIDeviceBuiltInProximitySensor = 1 << 16,
	UIDeviceSupportsAccessibility = 1 << 17,
	UIDeviceSupportsVoiceOver = 1 << 18,
	UIDeviceSupportsVoiceControl = 1 << 19,
	UIDeviceSupportsBrightnessSensor = 1 << 20,
	UIDeviceSupportsPeerToPeer = 1 << 21,
	UIDeviceSupportsARMV7 = 1 << 22,
	UIDeviceSupportsEncodeAAC = 1 << 23,
	UIDeviceSupportsBluetooth = 1 << 24,
	UIDeviceSupportsNike = 1 << 25,
	UIDeviceSupportsPiezoClicker = 1 << 26,
	UIDeviceSupportVolumeButtons = 1 << 27,
};

/*
 NOT Covered:
 launch-applications-while-animating, load-thumbnails-while-scrolling,
 delay-sleep-for-headset-click, Unified iPod, standalone contacts,
 fcc-logos-via-software, gas-gauge-battery & hiccough-interval
 */

@interface UIDevice (Hardware)
- (NSString *) platform;
- (NSUInteger) platformType;
- (NSUInteger) platformCapabilities;
- (NSString *) platformString;
- (NSString *) platformCode;

- (NSArray *) capabilityArray;

- (NSUInteger) cpuFrequency;
- (NSUInteger) busFrequency;
- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;

- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;

- (NSString *) macaddress;
@end

@interface UIDevice (Orientation)
- (BOOL) isLandscape;
- (BOOL) isPortrait;
- (NSString *) orientationString;
@property (nonatomic, readonly) BOOL isLandscape;
@property (nonatomic, readonly) BOOL isPortrait;
@property (nonatomic, readonly) NSString *orientationString;
@end
