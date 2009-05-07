/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License for anything not specifically marked as developed by a third party.
 Apple's code excluded.
 Use at your own risk
 */

#import <UIKit/UIKit.h>

#define SUPPORTS_UNDOCUMENTED_API	1

@interface UIDevice (Reachability)
- (NSString *) hostname;

- (NSString *) localWiFiIPAddress;
- (NSString *) localIPAddress;
- (NSString *) whatismyipdotcom;

- (BOOL) activeWLAN;
- (BOOL) addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address; // via Apple

- (void) forceWWAN; // via Apple
- (void) shutdownWWAN; // via Apple
@end

// Methods which rely on undocumented API methods 
#if SUPPORTS_UNDOCUMENTED_API

@interface UIDevice (UIDevice_Undocumented_Reachability)
- (BOOL) networkAvailable;
- (BOOL) activeWWAN;
@end

@interface NSHost : NSObject
{
    NSArray *names;
    NSArray *addresses;
    void *reserved;
}

+ (id)currentHost;
+ (void)_fixNSHostLeak;
+ (id)hostWithName:(id)fp8;
+ (id)hostWithAddress:(id)fp8;
+ (BOOL)isHostCacheEnabled;
+ (void)setHostCacheEnabled:(BOOL)fp8;
+ (void)flushHostCache;
- (BOOL)isEqualToHost:(id)fp8;
- (id)name;
- (id)names;
- (id)address;
- (id)addresses;
- (id)description;
- (void)dealloc;

@end
#endif // SUPPORTS_UNDOCUMENTED_API
