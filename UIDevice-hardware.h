#import <UIKit/UIKit.h>

#define IPHONE_1G_NAMESTRING @"iPhone 1G"
#define IPHONE_3G_NAMESTRING @"iPhone 3G"
#define IPHONE_UNKNOWN_NAMESTRING @"Unknown iPhone"
#define IPOD_1G_NAMESTRING @"iPod touch 1G"
#define IPOD_2G_NAMESTRING @"iPod touch 2G"
#define IPOD_UNKNOWN_NAMESTRING @"Unknown iPod"

typedef enum {
	UIDeviceUnknown,
	UIDevice1GiPhone,
	UIDevice1GiPod,
	UIDevice3GiPhone,
	UIDevice2GiPod,
	UIDeviceUnknowniPhone,
	UIDeviceUnknowniPod
} UIDevicePlatform;

enum {
	UIDeviceSupportsGPS	= 1 << 0,
	UIDeviceBuiltInSpeaker = 1 << 1,
	UIDeviceBuiltInCamera = 1 << 2,
	UIDeviceBuiltInMicrophone = 1 << 3,
	UIDeviceSupportsExternalMicrophone = 1 << 4,
	UIDeviceSupportsTelephony = 1 << 5,
	UIDeviceSupportsVibration = 1 << 6
};

@interface UIDevice (Hardware)
- (NSString *) platform;
- (int) platformType;
- (NSString *) platformString;
- (int) platformCapabilities;
@end
