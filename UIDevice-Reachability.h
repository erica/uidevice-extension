/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 5.0 Edition
 BSD License for anything not specifically marked as developed by a third party.
 Apple's code excluded.
 Use at your own risk
 */

#import <UIKit/UIKit.h>

@interface UIDevice (Reachability)
+ (NSString *) stringFromAddress: (const struct sockaddr *) address;
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address;
+ (NSData *) dataFromAddress: (struct sockaddr_in) address;
+ (NSString *) addressFromData:(NSData *) addressData;
+ (NSString *) portFromData:(NSData *) addressData;


- (NSString *) hostname;
- (NSString *) getIPAddressForHost: (NSString *) theHost;
- (NSString *) localIPAddress;
- (NSString *) localWiFiIPAddress;
+ (NSArray *) localWiFiIPAddresses;
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
@end