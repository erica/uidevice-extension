#import <UIKit/UIKit.h>

#define SUPPORTS_UNDOCUMENTED_APPLICATION_PROXIMITY	0

#if SUPPORTS_UNDOCUMENTED_APPLICATION_PROXIMITY

// Proximity Delegate Protocol
@protocol ProximityDelegate <NSObject>
- (void) proximityStateDidChange: (NSNumber *) newState;
@end

// Expose State Change
@interface UIApplication (proximity)
- (void)proximityStateChanged:(BOOL)fp8;
@end

// Subclass UIApplication
@interface ProximityApplication : UIApplication
{
	id <ProximityDelegate>	proximityClient;
}
@property (nonatomic, retain)	id <ProximityDelegate> proximityClient;
@end
#endif