/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License for anything not specifically marked as developed by a third party.
 Apple's code excluded.
 Use at your own risk
 */

#import <UIKit/UIKit.h>

#define SUPPORTS_UNDOCUMENTED_API	1

@protocol ReachabilityWatcher <NSObject>
- (void) reachabilityChanged;
@end


@interface UIDevice (Reachability)
+ (NSString *) stringFromAddress: (const struct sockaddr *) address;
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address;

- (NSString *) hostname;
- (NSString *) getIPAddressForHost: (NSString *) theHost;
- (NSString *) localIPAddress;
- (NSString *) localWiFiIPAddress;
- (NSString *) whatismyipdotcom;

- (BOOL) hostAvailable: (NSString *) theHost;
- (BOOL) networkAvailable;
- (BOOL) activeWLAN;
- (BOOL) activeWWAN;
- (BOOL) performWiFiCheck;

- (BOOL) forceWWAN; // via Apple
- (void) shutdownWWAN; // via Apple

- (BOOL) scheduleReachabilityWatcher: (id) watcher;
- (void) unscheduleReachabilityWatcher;

#ifdef SUPPORTS_UNDOCUMENTED_API
// Don't use this code in real life, boys and girls. It is not App Store friendly.
// It is, however, really nice for testing callbacks
// DEVICE ONLY!!!!
+ (void) setAPMode: (BOOL) yorn;
#endif
@end

#ifdef SUPPORTS_UNDOCUMENTED_API
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
#endif

