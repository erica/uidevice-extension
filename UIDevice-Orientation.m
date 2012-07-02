/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.0 Edition
 BSD License, Use at your own risk
 */

// Thanks jweinberg, Emanuele Vulcano, rincewind42, Jonah Williams

#import "UIDevice-Orientation.h"

@implementation UIDevice (Orientation)
#pragma mark current angle
CGFloat device_angle;

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	CGFloat xx = acceleration.x;
	CGFloat yy = -acceleration.y;
	device_angle = M_PI / 2.0f - atan2(yy, xx);
    
    if (device_angle > M_PI)
        device_angle -= 2 * M_PI;
	
	CFRunLoopStop(CFRunLoopGetCurrent());
}

- (CGFloat) orientationAngle
{
#if TARGET_IPHONE_SIMULATOR
	switch (self.orientation)
	{
		case UIDeviceOrientationPortrait: 
			return 0.0f;
		case UIDeviceOrientationPortraitUpsideDown:
			return M_PI;
		case UIDeviceOrientationLandscapeLeft: 
			return -(M_PI/2.0f);
		case UIDeviceOrientationLandscapeRight: 
			return (M_PI/2.0f);
		default:
			return 0.0f;
	}
#else
    // supercede current delegate
	id priorDelegate = [UIAccelerometer sharedAccelerometer].delegate;
	[UIAccelerometer sharedAccelerometer].delegate = self;
	
	// Wait for a reading
	CFRunLoopRun();
    
    // restore delgate
	[UIAccelerometer sharedAccelerometer].delegate = priorDelegate;
	
	return device_angle;
#endif
}

// Limited to the four portrait/landscape options
- (UIDeviceOrientation) acceleratorBasedOrientation
{
    CGFloat baseAngle = self.orientationAngle;
    if ((baseAngle > -M_PI_4) && (baseAngle < M_PI_4))
        return UIDeviceOrientationPortrait;
    if ((baseAngle < -M_PI_4) && (baseAngle > -3 * M_PI_4))
        return UIDeviceOrientationLandscapeLeft;
    if ((baseAngle > M_PI_4) && (baseAngle < 3 * M_PI_4))
        return UIDeviceOrientationLandscapeRight;
    return UIDeviceOrientationPortraitUpsideDown;
}

#pragma mark relative orientation

// Thanks Jonah Williams
- (CGFloat) orientationAngleRelativeToOrientation:(UIDeviceOrientation) someOrientation
{
 	CGFloat dOrientation = 0.0f;
	switch (someOrientation)
	{
		case UIDeviceOrientationPortraitUpsideDown: {dOrientation = M_PI; break;}
		case UIDeviceOrientationLandscapeLeft: {dOrientation = -(M_PI/2.0f); break;}
		case UIDeviceOrientationLandscapeRight: {dOrientation = (M_PI/2.0f); break;}
		default: break;
	}
	
	CGFloat adjustedAngle = fmod(self.orientationAngle - dOrientation, 2.0f * M_PI);
	if (adjustedAngle > (M_PI + 0.01f)) 
        adjustedAngle = (adjustedAngle - 2.0f * M_PI);
	return adjustedAngle;
}

#pragma mark basic orientation

- (BOOL) isLandscape
{
	return UIDeviceOrientationIsLandscape(self.orientation);
}

- (BOOL) isPortrait
{
	return UIDeviceOrientationIsPortrait(self.orientation);
}

// Transform to real world-readable string for arbitrary orientation
+ (NSString *) orientationString: (UIDeviceOrientation) orientation
{
	switch (orientation)
	{
		case UIDeviceOrientationUnknown: return @"Unknown";
		case UIDeviceOrientationPortrait: return @"Portrait";
		case UIDeviceOrientationPortraitUpsideDown: return @"Portrait Upside Down";
		case UIDeviceOrientationLandscapeLeft: return @"Landscape Left";
		case UIDeviceOrientationLandscapeRight: return @"Landscape Right";
		case UIDeviceOrientationFaceUp: return @"Face Up";
		case UIDeviceOrientationFaceDown: return @"Face Down";
		default: break;
	}
	return nil;
}

// String for current orientaiton
- (NSString *) orientationString
{
    return [UIDevice orientationString:self.orientation];
}
@end