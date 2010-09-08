/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "UIDevice-Capabilities.h"
#import <dlfcn.h>

/*
 
 THIS CATEGORY IS NOT APP STORE SAFE AT THIS TIME. DO NOT USE IN PRODUCTION CODE.
 YOU CAN, HOWEVER, USE THIS TO HELP BUILD YOUR OWN CUSTOM CODE TO PRE_COMPUTE CAPABILITIES.
 
 */

#define GRAPHICS_SERVICES_PATH	"/System/Library/PrivateFrameworks/GraphicsServices.framework/GraphicsServices"

@implementation UIDevice (Capabilities)

- (BOOL) supportsCapability: (NSString *) capability
{
	void *libHandle = dlopen(GRAPHICS_SERVICES_PATH, RTLD_LAZY);
	int (*GSSystemHasCapability)(NSString *);
	GSSystemHasCapability = dlsym(libHandle, "GSSystemHasCapability");
	BOOL result = GSSystemHasCapability(capability);
	dlclose(libHandle);
	return result;
}

- (id) fetchCapability: (NSString *) capability
{
	void *libHandle = dlopen(GRAPHICS_SERVICES_PATH, RTLD_LAZY);
	int (*GSSystemCopyCapability)(NSString *);
	GSSystemCopyCapability = dlsym(libHandle, "GSSystemCopyCapability");
	id capabilityValue = (id) GSSystemCopyCapability(capability);
	dlclose(libHandle);
	return [capabilityValue autorelease];
}

- (void) scanCapabilities
{
	printf("Device: %s\n", [[self fetchCapability: UIDeviceMarketingNameString] UTF8String]);
	for (NSString *capability in CAPABILITY_STRINGS)
	{
		printf("%s: %s\n", [capability UTF8String], [self supportsCapability:capability] ? "Yes" : "No");
	}
}

- (NSArray *) capabilityArray
{
	NSMutableArray *array = [NSMutableArray array];
	for (NSString *capability in CAPABILITY_STRINGS)
	{
		if ([self supportsCapability:capability])
			[array addObject:capability];
	}
	
	return array;
}
@end
