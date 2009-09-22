/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "UIDevice-IOKitExtensions.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <mach/mach_host.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>

#if SUPPORTS_IOKIT_EXTENSIONS
#pragma mark IOKit miniheaders

#define kIODeviceTreePlane		"IODeviceTree"

enum {
    kIORegistryIterateRecursively	= 0x00000001,
    kIORegistryIterateParents		= 0x00000002
};

typedef mach_port_t	io_object_t;
typedef io_object_t	io_registry_entry_t;
typedef char		io_name_t[128];
typedef UInt32		IOOptionBits;

CFTypeRef
IORegistryEntrySearchCFProperty(
								io_registry_entry_t	entry,
								const io_name_t		plane,
								CFStringRef		key,
								CFAllocatorRef		allocator,
								IOOptionBits		options );

kern_return_t
IOMasterPort( mach_port_t	bootstrapPort,
			 mach_port_t *	masterPort );

io_registry_entry_t
IORegistryGetRootEntry(
					   mach_port_t	masterPort );

CFTypeRef
IORegistryEntrySearchCFProperty(
								io_registry_entry_t	entry,
								const io_name_t		plane,
								CFStringRef		key,
								CFAllocatorRef		allocator,
								IOOptionBits		options );

kern_return_t   mach_port_deallocate
(ipc_space_t                               task,
 mach_port_name_t                          name);


@implementation UIDevice (IOKit_Extensions)
#pragma mark IOKit Utils
NSArray *getValue(NSString *iosearch)
{
    mach_port_t          masterPort;
    CFTypeID             propID = (CFTypeID) NULL;
    unsigned int         bufSize;
	
    kern_return_t kr = IOMasterPort(MACH_PORT_NULL, &masterPort);
    if (kr != noErr) return nil;
	
    io_registry_entry_t entry = IORegistryGetRootEntry(masterPort);
    if (entry == MACH_PORT_NULL) return nil;
	
    CFTypeRef prop = IORegistryEntrySearchCFProperty(entry, kIODeviceTreePlane, (CFStringRef) iosearch, nil, kIORegistryIterateRecursively);
    if (!prop) return nil;
	
	propID = CFGetTypeID(prop);
    if (!(propID == CFDataGetTypeID())) 
	{
		mach_port_deallocate(mach_task_self(), masterPort);
		return nil;
	}
	
    CFDataRef propData = (CFDataRef) prop;
    if (!propData) return nil;
	
    bufSize = CFDataGetLength(propData);
    if (!bufSize) return nil;
	
    NSString *p1 = [[[NSString alloc] initWithBytes:CFDataGetBytePtr(propData) length:bufSize encoding:1] autorelease];
    mach_port_deallocate(mach_task_self(), masterPort);
    return [p1 componentsSeparatedByString:@"\0"];
}

- (NSString *) imei
{
	NSArray *results = getValue(@"device-imei");
	if (results) return [results objectAtIndex:0];
	return nil;
}

- (NSString *) serialnumber
{
	NSArray *results = getValue(@"serial-number");
	if (results) return [results objectAtIndex:0];
	return nil;
}

- (NSString *) backlightlevel
{
	NSArray *results = getValue(@"backlight-level");
	if (results) return [results objectAtIndex:0];
	return nil;
}
@end
#endif