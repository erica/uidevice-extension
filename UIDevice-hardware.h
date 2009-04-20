#import <UIKit/UIKit.h>

#define SUPPORTS_UNDOCUMENTED_API	1

#define IPHONE_1G_NAMESTRING @"iPhone 1G"
#define IPHONE_3G_NAMESTRING @"iPhone 3G"
#define IPHONE_UNKNOWN_NAMESTRING @"Unknown iPhone"
#define IPOD_1G_NAMESTRING @"iPod touch 1G"
#define IPOD_2G_NAMESTRING @"iPod touch 2G"
#define IPOD_UNKNOWN_NAMESTRING @"Unknown iPod"
#define IPOD_FAMILY_UNKNOWN_DEVICE @"Unknown device in the iPhone/iPod family"

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
- (NSUInteger) platformType;
- (NSUInteger) platformCapabilities;
- (NSString *) platformString;

- (NSUInteger) cpuFrequency;
- (NSUInteger) busFrequency;
- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;
- (NSUInteger) maxSocketBufferSize;

- (NSString *) macaddress;
- (NSString *) hostname;
- (NSString *) localWiFiIPAddress;
- (NSString *) localIPAddress;
- (NSString *) getIPAddress;
- (NSString *) whatismyipdotcom;
@end

#if SUPPORTS_UNDOCUMENTED_API
@interface NSHost : NSObject
{
    NSArray *names;
    NSArray *addresses;
    void *reserved;
}

+ (id)currentHost;
+ (void)_fixNSHostLeak;
+ (id)hostWithName:(id)fp8;
+ (id)hostWithAddress:(id)fp8;
+ (BOOL)isHostCacheEnabled;
+ (void)setHostCacheEnabled:(BOOL)fp8;
+ (void)flushHostCache;
- (BOOL)isEqualToHost:(id)fp8;
- (id)name;
- (id)names;
- (id)address;
- (id)addresses;
- (id)description;
- (void)dealloc;

@end

// UIDevice_Undocumented_Expanded
// Methods which rely on undocumented methods 
@interface UIDevice (UIDevice_Undocumented_Expanded)
@end
#endif // SUPPORTS_UNDOCUMENTED_API

