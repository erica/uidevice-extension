/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

/*
 
 THIS CATEGORY IS NOT APP STORE SAFE AT THIS TIME. DO NOT USE IN PRODUCTION CODE.
 YOU CAN, HOWEVER, USE THIS TO HELP BUILD YOUR OWN CUSTOM CODE TO PRE_COMPUTE CAPABILITIES.
 
 */

/*
 See http://iphonedevwiki.net/index.php/GSCapability for information about what some of these items are
 Thanks DB42
 */

#define UIDevice720pPlaybackCapability	@"720p"
#define UIDeviceARMV6ExecutionCapability	@"armv6"
#define UIDeviceARMV7ExecutionCapability	@"armv7"
#define UIDeviceAccelerometerCapability	@"accelerometer"
#define UIDeviceAccessibilityCapability	@"accessibility"
#define UIDeviceAppleInternalInstallCapability	@"apple-internal-install"
#define UIDeviceAutoFocusCameraCapability	@"auto-focus-camera"
#define UIDeviceBluetoothCapability	@"bluetooth"
#define UIDeviceCameraCapability	@"still-camera"
#define UIDeviceCameraFlashCapability	@"camera-flash"
#define UIDeviceCellularDataCapability	@"cellular-data"
#define UIDeviceContainsCellularRadioCapability	@"contains-cellular-radio"
#define UIDeviceDataPlanCapability	@"data-plan"
#define UIDeviceDelaySleepForHeadsetClickCapability	@"delay-sleep-for-headset-click"
#define UIDeviceDisplayFCCLogosViaSoftwareCapability	@"fcc-logos-via-software"
#define UIDeviceDisplayIdentifiersCapability	@"application-display-identifiers"
#define UIDeviceDisplayPortCapability	@"displayport"
#define UIDeviceEncodeAACCapability	@"encode-aac"
#define UIDeviceEncryptedDataPartitionCapability	@"encrypted-data-partition"
#define UIDeviceFrontFacingCameraCapability	@"front-facing-camera"
#define UIDeviceGPSCapability	@"gps"
#define UIDeviceGasGaugeBatteryCapability	@"gas-gauge-battery"
#define UIDeviceGreenTeaDeviceCapability	@"green-tea" // China only feature
#define UIDeviceGyroscopeCapability	@"gyroscope"
#define UIDeviceH264EncoderCapability	@"h264-encoder"
#define UIDeviceHasAllFeaturesCapability	@"all-features"
#define UIDeviceHiDPICapability	@"hidpi"
#define UIDeviceHideNonDefaultApplicationsCapability	@"hide-non-default-apps"
#define UIDeviceIOSurfaceBackedImagesCapability	@"io-surface-backed-images"
#define UIDeviceInternationalSettingsCapability	@"international-settings"
#define UIDeviceLaunchApplicationsWhileAnimatingCapability	@"launch-applications-while-animating"
#define UIDeviceLoadThumbnailsWhileScrollingCapability	@"load-thumbnails-while-scrolling"
#define UIDeviceLocationServicesCapability	@"location-services"
#define UIDeviceMMSCapability	@"mms"
#define UIDeviceMagnetometerCapability	@"magnetometer"
#define UIDeviceMicrophoneCapability	@"microphone"
#define UIDeviceMultitaskingCapability	@"multitasking"
#define UIDeviceNikeIpodCapability	@"nike-ipod"
#define UIDeviceNotGreenTeaDeviceCapability	@"not-green-tea"
#define UIDeviceOpenGLES1Capability	@"opengles-1"
#define UIDeviceOpenGLES2Capability	@"opengles-2"
#define UIDevicePeer2PeerCapability	@"peer-peer"
#define UIDevicePiezoClickerCapability	@"piezo-clicker"
#define UIDevicePlatformStandAloneContactsCapability	@"stand-alone-contacts"
#define UIDeviceProximitySensorCapability	@"proximity-sensor"
#define UIDeviceRingerSwitchCapability	@"ringer-switch"
#define UIDeviceSMSCapability	@"sms"
#define UIDeviceSensitiveUICapability	@"sensitive-ui"
#define UIDeviceTelephonyCapability	@"telephony"
#define UIDeviceTVOutCrossfadeCapability	@"tv-out-crossfade"
#define UIDeviceTVOutSettingsCapability	@"tv-out-settings"
#define UIDeviceUnifiedIPodCapability	@"unified-ipod"
#define UIDeviceVOIPCapability	@"voip"
#define UIDeviceVeniceCapability	@"venice" // Video Conferencing
#define UIDeviceVideoCameraCapability	@"video-camera"
#define UIDeviceVoiceControlCapability	@"voice-control"
#define UIDeviceVolumeButtonCapability	@"volume-buttons"
#define UIDeviceWiFiCapability	@"wifi"
#define UIDeviceWildcatCapability	@"wildcat" // iPad features
#define UIDeviceYouTubeCapability	@"youtube"
#define UIDeviceYouTubePluginCapability	@"youtubePlugin"

// Non binary -- use fetchCapability:, not supportsCapability:
#define UIDeviceScreenDimensionsCapability	@"screen-dimensions"
#define UIDeviceTelephonyMaximumGeneration  @"telephony-maximum-generation"
#define UIDeviceMarketingNameString @"marketing-name"
#define UIDeviceDeviceNameString @"device-name"

// Boolean values only
#define CAPABILITY_STRINGS ([NSArray arrayWithObjects:UIDevice720pPlaybackCapability, UIDeviceARMV6ExecutionCapability, UIDeviceARMV7ExecutionCapability, UIDeviceAccelerometerCapability, UIDeviceAccessibilityCapability, UIDeviceAppleInternalInstallCapability, UIDeviceAutoFocusCameraCapability, UIDeviceBluetoothCapability, UIDeviceCameraCapability, UIDeviceCameraFlashCapability, UIDeviceCellularDataCapability, UIDeviceContainsCellularRadioCapability, UIDeviceDataPlanCapability, UIDeviceDelaySleepForHeadsetClickCapability, UIDeviceDisplayFCCLogosViaSoftwareCapability, UIDeviceDisplayIdentifiersCapability, UIDeviceDisplayPortCapability, UIDeviceEncodeAACCapability, UIDeviceEncryptedDataPartitionCapability, UIDeviceFrontFacingCameraCapability, UIDeviceGPSCapability, UIDeviceGasGaugeBatteryCapability, UIDeviceGreenTeaDeviceCapability, UIDeviceGyroscopeCapability, UIDeviceH264EncoderCapability, UIDeviceHasAllFeaturesCapability, UIDeviceHiDPICapability, UIDeviceHideNonDefaultApplicationsCapability, UIDeviceIOSurfaceBackedImagesCapability, UIDeviceInternationalSettingsCapability, UIDeviceLaunchApplicationsWhileAnimatingCapability, UIDeviceLoadThumbnailsWhileScrollingCapability, UIDeviceLocationServicesCapability, UIDeviceMMSCapability, UIDeviceMagnetometerCapability, UIDeviceMicrophoneCapability, UIDeviceMultitaskingCapability, UIDeviceNikeIpodCapability, UIDeviceNotGreenTeaDeviceCapability, UIDeviceOpenGLES1Capability, UIDeviceOpenGLES2Capability, UIDevicePeer2PeerCapability, UIDevicePiezoClickerCapability, UIDevicePlatformStandAloneContactsCapability, UIDeviceProximitySensorCapability, UIDeviceRingerSwitchCapability, UIDeviceSMSCapability, UIDeviceSensitiveUICapability, UIDeviceTVOutCrossfadeCapability, UIDeviceTVOutSettingsCapability, UIDeviceUnifiedIPodCapability, UIDeviceVOIPCapability, UIDeviceVeniceCapability, UIDeviceVideoCameraCapability, UIDeviceVoiceControlCapability, UIDeviceVolumeButtonCapability, UIDeviceWiFiCapability, UIDeviceWildcatCapability, UIDeviceYouTubeCapability, UIDeviceYouTubePluginCapability, UIDeviceTelephonyCapability, nil])

@interface UIDevice (Capabilities)
- (BOOL) supportsCapability: (NSString *) capability;
- (id) fetchCapability: (NSString *) capability;
- (NSArray *) capabilityArray;
- (void) scanCapabilities;
@end
