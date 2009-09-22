/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

/*
 http://broadcast.oreilly.com/2009/04/iphone-dev-iokit---the-missing.html
 
 In Xcode, I was surprised to see that Apple didn't include IOKit header files. When I tried to 
 add #import <IOKit/IOKit.h>, the file could not be found. So I manually put together a simple 
 header file by hand, added IOKit to my frameworks and attempted to compile.
 
 As you can see from the screenshot at the top of this post, I failed to do so. Xcode complained 
 that the IOKit framework could not be found. Despite being filed as public, IOKit is apparently 
 not meant to be used by the general public. As iPhone evangelist Matt Drance tweeted, 
 "IOKit is not public on iPhone. Lack of headers and docs is rarely an oversight."
 
 In the official docs, I found a quote that described IOKit as such: "Contains interfaces used by
 the device. Do not include this framework directly." So in the end, my desire to access that IOKit 
 information was thwarted. For whatever reason, Apple has chosen to list it as a public framework 
 but the reality is that it is not.
*/

#import <UIKit/UIKit.h>

#define SUPPORTS_IOKIT_EXTENSIONS	1

/*
 * To use, you must add the (semi)public IOKit framework before compiling
 */

#if SUPPORTS_IOKIT_EXTENSIONS
@interface UIDevice (IOKit_Extensions)
- (NSString *) imei;
- (NSString *) serialnumber;
- (NSString *) backlightlevel;
@end
#endif

