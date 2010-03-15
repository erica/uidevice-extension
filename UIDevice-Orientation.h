/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>


@interface UIDevice (Orientation) <UIAccelerometerDelegate>
- (BOOL) isLandscape;
- (BOOL) isPortrait;
- (NSString *) orientationString;
- (float) orientationAngleRelativeToOrientation:(UIDeviceOrientation) someOrientation;
@property (nonatomic, readonly) BOOL isLandscape;
@property (nonatomic, readonly) BOOL isPortrait;
@property (nonatomic, readonly) NSString *orientationString;
@property (nonatomic, readonly) float orientationAngle;
@end
