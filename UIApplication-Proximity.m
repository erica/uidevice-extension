#import "UIApplication-Proximity.h"

#if SUPPORTS_UNDOCUMENTED_APPLICATION_PROXIMITY
@implementation ProximityApplication
@synthesize proximityClient;

/*
 
 NOTE -- Proximity is not stable. Please do not use this right now.
 
 */

- (void) proximityStateChanged:(BOOL)isOn
{
	if (self.proximityClient) 
		[self.proximityClient proximityStateDidChange:[NSNumber numberWithBool:isOn]];
}

@end
#endif