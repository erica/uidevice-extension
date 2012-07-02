/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface UIDevice (Orientation) <UIAccelerometerDelegate>
- (float) orientationAngleRelativeToOrientation:(UIDeviceOrientation) someOrientation;
+ (NSString *) orientationString: (UIDeviceOrientation) orientation;

@property (nonatomic, readonly) BOOL isLandscape;
@property (nonatomic, readonly) BOOL isPortrait;
@property (nonatomic, readonly) NSString *orientationString;
@property (nonatomic, readonly) float orientationAngle;
@property (nonatomic, readonly) UIDeviceOrientation acceleratorBasedOrientation;

@end
