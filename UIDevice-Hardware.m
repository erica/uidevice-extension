/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 
 Modified by Eric Horacek for Monospace Ltd. on 2/4/13
 */

#include <sys/sysctl.h>
#import "UIDevice-Hardware.h"

@implementation UIDevice (Hardware)

- (NSString *)getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

- (NSUInteger)getSysInfo:(uint)typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

- (NSString *)modelIdentifier
{
    return [self getSysInfoByName:"hw.machine"];
}

- (NSString *)modelName
{
    NSString *platform = [self modelIdentifier];
    
    // iPhone http://theiphonewiki.com/wiki/IPhone
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (GSM Rev A)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (Global)";
    
    if ([platform hasPrefix:@"iPhone"])             return @"Unknown iPhone";
    
    // iPad http://theiphonewiki.com/wiki/IPad
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (Rev A)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (Gloabl)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (Gloabl)";
    
    // iPad Mini http://theiphonewiki.com/wiki/IPad_mini
    
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad mini 1G (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad mini 1G (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad mini 1G (Global)";
    
    if ([platform hasPrefix:@"iPad"])               return @"Unknown iPad";
    
    // iPod http://theiphonewiki.com/wiki/IPod
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod touch 5G";
    
    if ([platform hasPrefix:@"iPod"])               return @"Unknown iPod";
    
    // Simulator
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = ([[UIScreen mainScreen] bounds].size.width < 768.0);
        return (smallerScreen ? @"iPhone Simulator" : @"iPad Simulator");
    }
    
    return @"Unknown Device";
}

- (UIDeviceFamily) deviceFamily
{
    NSString *platform = [self modelIdentifier];
    if ([platform hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([platform hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([platform hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    return UIDeviceFamilyUnknown;
}

@end