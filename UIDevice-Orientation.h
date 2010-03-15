//
//  UIDevice-Orientation.h
//  HelloWorld
//
//  Created by Erica Sadun on 3/15/10.
//  Copyright 2010 Up To No Good, Inc. All rights reserved.
//

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
