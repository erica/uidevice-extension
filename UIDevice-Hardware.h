/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

#define IPHONE_1G_NAMESTRING @"iPhone 1G"
#define IPHONE_3G_NAMESTRING @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING @"iPhone 3GS" 
#define IPHONE_UNKNOWN_NAMESTRING @"Unknown iPhone"

#define IPOD_1G_NAMESTRING @"iPod touch 1G"
#define IPOD_2G_NAMESTRING @"iPod touch 2G"
#define IPOD_UNKNOWN_NAMESTRING @"Unknown iPod"

#define IPOD_FAMILY_UNKNOWN_DEVICE @"Unknown device in the iPhone/iPod family"

#define IPHONE_SIMULATOR_NAMESTRING	@"iPhone Simulator"

typedef enum {
	UIDeviceUnknown,
	UIDeviceiPhoneSimulator,
	UIDevice1GiPhone,
	UIDevice1GiPod,
	UIDevice3GiPhone,
	UIDevice3GSiPhone,
	UIDevice2GiPod,
	UIDeviceUnknowniPhone,
	UIDeviceUnknowniPod,
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
	UIDeviceSupportsOPENGLES1 = 1 << 12,
	UIDeviceSupportsOPENGLES2 = 1 << 13,
	UIDeviceBuiltInSpeaker = 1 << 14,
	UIDeviceSupportsVibration = 1 << 15,
	UIDeviceBuiltInProximitySensor = 1 << 16,
	UIDeviceSupportsAccessibility = 1 << 17,
	UIDeviceSupportsVoiceControl = 1 << 18,
	UIDeviceSupportsBrightnessSensor = 1 << 19,
};

@interface UIDevice (Hardware)

+ (NSString *) platform;
+ (NSUInteger) platformType;
+ (NSUInteger) platformCapabilities;
+ (NSString *) platformString;
+ (NSString *) platformCode;

+ (NSArray *) capabilityArray;

+ (NSUInteger) cpuFrequency;
+ (NSUInteger) busFrequency;
+ (NSUInteger) totalMemory;
+ (NSUInteger) userMemory;

+ (NSNumber *) totalDiskSpace;
+ (NSNumber *) freeDiskSpace;

+ (NSString *) macaddress;
@end

@interface UIDevice (Orientation)
- (BOOL) isLandscape;
- (BOOL) isPortrait;
- (NSString *) orientationString;
@property (nonatomic, readonly) BOOL isLandscape;
@property (nonatomic, readonly) BOOL isPortrait;
@property (nonatomic, readonly) NSString *orientationString;
@end
