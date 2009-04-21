#import "UIApplication-Proximity.h"

#if SUPPORTS_UNDOCUMENTED_APPLICATION_PROXIMITY
@implementation ProximityApplication
@synthesize proximityClient;

- (void) proximityStateChanged:(BOOL)isOn
{
	if (self.proximityClient) 
		[self.proximityClient proximityStateDidChange:[NSNumber numberWithBool:isOn]];
}

@end
#endif