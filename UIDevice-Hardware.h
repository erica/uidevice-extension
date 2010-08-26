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
#define IPHONE_4G_NAMESTRING			@"iPhone 4G" // 2 other models yet to debut
#define IPHONE_UNKNOWN_NAMESTRING		@"Unknown iPhone"

#define IPOD_1G_NAMESTRING				@"iPod touch 1G"
#define IPOD_2G_NAMESTRING				@"iPod touch 2G"
#define IPOD_2GPLUS_NAMESTRING			@"iPod touch 2G Plus"
#define IPOD_3G_NAMESTRING				@"iPod touch 3G"
#define IPOD_4G_NAMESTRING				@"iPod touch 4G"
#define IPOD_UNKNOWN_NAMESTRING			@"Unknown iPod"

#define IPAD_1G_NAMESTRING				@"iPad 1G"
#define IPAD_2G_NAMESTRING				@"iPad 2G"
#define IPAD_UNKNOWN_NAMESTRING			@"Unknown iPad"

#define ITV_1G_NAMESTRING				@"iTV 1G"
#define ITV_UNKNOWN_NAMESTRING			@"Unknown iTV"

#define IPOD_FAMILY_UNKNOWN_DEVICE			@"Unknown iOS device"

#define IPHONE_SIMULATOR_NAMESTRING			@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPHONE_NAMESTRING	@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPAD_NAMESTRING	@"iPad Simulator"

typedef enum {
	UIDeviceUnknown,
	UIDeviceiPhoneSimulator,
	UIDeviceiPhoneSimulatoriPhone, // both regular and iPhone 4 devices
	UIDeviceiPhoneSimulatoriPad,
	UIDevice1GiPhone,
	UIDevice3GiPhone,
	UIDevice3GSiPhone,
	UIDevice4GiPhone,
	UIDevice1GiPod,
	UIDevice2GiPod,
	UIDevice2GPlusiPod, // anticipating
	UIDevice3GiPod,
	UIDevice4GiPod,
	UIDevice1GiPad, // both regular and 3G
	UIDevice2GiPad,
	UIDevice1GiTV, 
	UIDeviceUnknowniPhone,
	UIDeviceUnknowniPod,
	UIDeviceUnknowniPad,
	UIDeviceUnknowniTV, // anticipating
	UIDeviceIFPGA,
} UIDevicePlatform;

typedef enum {
	UIDeviceFirmware2,
	UIDeviceFirmware3,
	UIDeviceFirmware4,
	UIDeviceFirmware5,
} UIDeviceFirmware;

// Sensors
enum {
	UIDeviceSensorsSupportsAccelerometer = 1 << 0,	
	UIDeviceSensorsSupportsGyro = 1 << 1,
	UIDeviceSensorsSupportsMagnetometer = 1 << 2,
	UIDeviceSensorsSupportsBrightnessSensor = 1 << 3,
	UIDeviceSensorsSupportsBuiltInProximitySensor = 1 << 4,
	UIDeviceSensorsSupportsBuiltInMicrophone = 1 << 5,
	UIDeviceSensorsSupportsExternalMicrophone = 1 << 6,
	UIDeviceSensorsSupportsDualMicNoiseSuppression = 1 << 6,
};

// Cameras
enum {
	UIDeviceCamerasSupportsStillCamera = 1 << 0,
	UIDeviceCamerasSupportsAutofocusCamera = 1 << 1,
	UIDeviceCamerasSupportsVideoCamera = 1 << 2,	
	UIDeviceCamerasSupportsFrontCamera = 1 << 3,
	UIDeviceCamerasSupportsBackLED = 1 << 4,
};

// Communication
enum {
	UIDeviceCommoSupportsTelephony = 1 << 0,
	UIDeviceCommoSupportsSMS = 1 << 1,
	UIDeviceCommoSupportsWifi = 1 << 2,
	UIDeviceCommoSupportsBluetooth = 1 << 3,
	UIDeviceCommoSupportsPeerToPeer = 1 << 4,
};

// Audio
enum {
	UIDeviceAudioSupportsBuiltInSpeaker = 1 << 0,
	UIDeviceAudioSupportsVibration = 1 << 1,
	UIDeviceAudioSupportsPiezoClicker = 1 << 2,
	UIDeviceAudioSupportsHardwareVolumeButtons = 1 << 3,
	UIDeviceAudioSupportsEncodeAAC = 1 << 4,
};

// Other Capabilities
enum {
	UIDeviceSupportsLocationServices = 1 << 0,
	UIDeviceSupportsGPS = 1 << 1,
	UIDeviceSupportsOPENGLES1_1 = 1 << 2,
	UIDeviceSupportsOPENGLES2 = 1 << 3,
	UIDeviceSupportsARMV7 = 1 << 4,
	UIDeviceSupportsNike = 1 << 5,
	UIDeviceSupportsAccessibility = 1 << 6,
	UIDeviceSupportsVoiceOver = 1 << 7,
	UIDeviceSupportsVoiceControl = 1 << 8,
	UIDeviceSupportsEnhancedMultitouch = 1 << 9, // http://www.boygeniusreport.com/2010/01/13/apples-tablet-is-an-iphone-on-steroids/
};

// Is it worth adding retina display here or not?

/*
 NOT Covered:
 launch-applications-while-animating, load-thumbnails-while-scrolling,
 delay-sleep-for-headset-click, Unified iPod, standalone contacts,
 fcc-logos-via-software, gas-gauge-battery & hiccough-interval
 */

@interface UIDevice (Hardware)
- (NSString *) platform;
- (NSString *) hwmodel;
- (NSUInteger) platformType;
- (NSUInteger) platformCapabilities;
- (NSString *) platformString;
- (NSString *) platformCode;

- (NSArray *) capabilityArray;
- (BOOL) platformHasCapability:(NSUInteger)capability;

- (NSUInteger) cpuFrequency;
- (NSUInteger) busFrequency;
- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;

- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;

- (NSString *) macaddress;
@end