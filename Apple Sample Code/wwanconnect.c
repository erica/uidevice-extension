// Direct from Apple. Thank you Apple

#include "wwanconnect.h"
#include <CFNetwork/CFSocketStream.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <ifaddrs.h>
#include <stdio.h>

static Boolean TestGetIFAddrs(void);
static void MyCFWriteStreamClientCallBack(CFWriteStreamRef stream, CFStreamEventType type, void *clientCallBackInfo);
static void CleanupAfterWAAN(MyStreamInfoPtr myInfoPtr);
static void CloseStreams(MyStreamInfoPtr myInfoPtr);

static Boolean TestGetIFAddrs(void)
{
	int				result;
	struct  ifaddrs	*ifbase, *ifiterator;
	int				done = 0;
	Boolean			addrFound = FALSE;
	char			loopbackname[] = "lo0/0";
	
	result = getifaddrs(&ifbase);
	ifiterator = ifbase;
	while (!done && (ifiterator != NULL))
	{
		if (ifiterator->ifa_addr->sa_family == AF_INET)
		{
			if (memcmp(ifiterator->ifa_name, loopbackname, 3))
			{
				struct	sockaddr *saddr, *netmask, *daddr;
				saddr = ifiterator->ifa_addr;
				netmask = ifiterator->ifa_netmask;
				daddr = ifiterator->ifa_dstaddr;
				
				// we've found an entry for the IP address
				struct sockaddr_in	*iaddr;
				char				addrstr[64];
				iaddr = (struct sockaddr_in *)saddr;
				inet_ntop(saddr->sa_family, &iaddr->sin_addr, addrstr, sizeof(addrstr));
				fprintf(stderr, "ipv4 interface name %s, source IP addr %s ", ifiterator->ifa_name, addrstr);
				
				iaddr = (struct sockaddr_in *)netmask;
				if (iaddr)
				{
					inet_ntop(saddr->sa_family, &iaddr->sin_addr, addrstr, sizeof(addrstr));
					fprintf(stderr, "netmask IP addr %s ", addrstr);
				}
				
				iaddr = (struct sockaddr_in *)daddr;
				if (iaddr)
				{
					inet_ntop(saddr->sa_family, &iaddr->sin_addr, addrstr, sizeof(addrstr));
					fprintf(stderr, "dest/broadcast IP addr %s.\n\n", addrstr);
				}
				return TRUE;
			}
			
		}
		else if (ifiterator->ifa_addr->sa_family == AF_INET6)
		{
			// we've found an entry for the IP address
			struct sockaddr_in6	*iaddr6 = (struct sockaddr_in6 *)ifiterator->ifa_addr;
			char				addrstr[256];
			inet_ntop(ifiterator->ifa_addr->sa_family, iaddr6, addrstr, sizeof(addrstr));
			fprintf(stderr, "ipv6 interface name %s, source IP addr %s \n\n", ifiterator->ifa_name, addrstr);
		}
		ifiterator = ifiterator->ifa_next;
	}
	if (ifbase)
		freeifaddrs(ifbase);	/* done with the memory allocated by getifaddrs */
	
    return addrFound;
}

static void MyCFWriteStreamClientCallBack(CFWriteStreamRef stream, CFStreamEventType type, void *clientCallBackInfo)
{
	MyStreamInfoPtr	myInfoPtr = (MyStreamInfoPtr) clientCallBackInfo;
	
	printf("MyCFWriteStreamClientCallBack entered - event is %d\n", (int) type);
	
	switch (type)
	{
		case kCFStreamEventOpenCompleted:
			myInfoPtr->isConnected = TRUE;
			TestGetIFAddrs();		// call the test function to return the local ip address associated with this connection.
			if (myInfoPtr->clientCB)
			{
				// call client callback routine
				myInfoPtr->clientCB(myInfoPtr->refCon);
			}
			printf("write stream connected\n");
			break;
			
		case kCFStreamEventErrorOccurred:
			myInfoPtr->errorOccurred = TRUE;
			myInfoPtr->error = CFWriteStreamGetError(myInfoPtr->wStreamRef);
			printf("write stream error %d .. giving up\n", (int)myInfoPtr->error.error);
			break;
			
		default:
			break;
	}
	// stop the run loop at this point
	CFRunLoopStop(CFRunLoopGetCurrent());
}

extern MyInfoRef StartWWAN(ConnectClientCallBack clientCB, void *refCon)
{ 
	char						host[] = kTestHost;
	int							portNum = kTestPort;
	CFDataRef					addressData;
	MyStreamInfoPtr				myInfoPtr;
	CFStreamClientContext		ctxt = {0, NULL, NULL, NULL, NULL};
	Boolean						errorOccurred = FALSE;
	
	myInfoPtr = malloc(sizeof(MyStreamInfo));
	if (!myInfoPtr)
	{
		return NULL;
	}
	
	// init the allocated memory
	memset(myInfoPtr, 0, sizeof(MyStreamInfo));
	myInfoPtr->clientCB = clientCB;
	myInfoPtr->refCon = refCon;	
	ctxt.info = myInfoPtr;
	
	// Check for a dotted-quad address, if so skip any host lookups 
	in_addr_t addr = inet_addr(host); 
	if (addr != INADDR_NONE) { 
		// Create the streams from numberical host 
		struct sockaddr_in sin; 
		memset(&sin, 0, sizeof(sin)); 
		
		sin.sin_len= sizeof(sin); 
		sin.sin_family = AF_INET; 
		sin.sin_addr.s_addr = addr; 
		sin.sin_port = htons(portNum); 
		
		addressData = CFDataCreate(NULL, (UInt8 *)&sin, sizeof(sin)); 
		CFSocketSignature sig = { AF_INET, SOCK_STREAM, IPPROTO_TCP, addressData }; 
		
		// Create the streams. 
		CFStreamCreatePairWithPeerSocketSignature(kCFAllocatorDefault, &sig, &(myInfoPtr->rStreamRef), &(myInfoPtr->wStreamRef)); 		
		CFRelease(addressData); 
	} else { 
		// Create the streams from ascii host name 
		CFStringRef hostStr = CFStringCreateWithCStringNoCopy(kCFAllocatorDefault, host, kCFStringEncodingUTF8, kCFAllocatorNull); 
		CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, hostStr, portNum, &(myInfoPtr->rStreamRef), &(myInfoPtr->wStreamRef)); 
	} 
	
	myInfoPtr->isConnected = FALSE;
	myInfoPtr->isStreamInitd = TRUE;
	myInfoPtr->isClientSet = FALSE;
	
	// Inform the streams to kill the socket when it is done with it. 
	// This effects the write stream too since the pair shares the 
	// one socket. 
	CFWriteStreamSetProperty(myInfoPtr->wStreamRef, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue); 
	
	// set up the client
	if (!CFWriteStreamSetClient(myInfoPtr->wStreamRef, kCFStreamEventOpenCompleted | kCFStreamEventErrorOccurred | kCFStreamEventEndEncountered, 
								MyCFWriteStreamClientCallBack, &ctxt))
	{
		printf("CFWriteStreamSetClient failed\n");
		errorOccurred = TRUE;
	}
	else
		myInfoPtr->isClientSet = TRUE;
	
	if (!errorOccurred)
	{
		// schedule the stream
		CFWriteStreamScheduleWithRunLoop(myInfoPtr->wStreamRef, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		
		// Try to open the stream.
		if (!CFWriteStreamOpen(myInfoPtr->wStreamRef))
		{
			printf("CFWriteStreamOpen failed\n");
			errorOccurred = TRUE;
		}
	}
	
	if (!errorOccurred)
	{
		// everything worked so far, so run the runloop - when the callback gets called, it will stop the run loop
		printf("CFWriteStreamOpen returned with no error - calling CFRunLoopRun\n");
		CFRunLoopRun();
		if (myInfoPtr->errorOccurred)
			errorOccurred = TRUE;
		printf("after CFRunLoopRun - returning\n");
	}
	
	if (errorOccurred)
	{
		myInfoPtr->isConnected = FALSE;
		CleanupAfterWAAN(myInfoPtr);
		CloseStreams(myInfoPtr);
		
		if (myInfoPtr->isStreamInitd)
		{
			CFRelease(myInfoPtr->rStreamRef);
			CFRelease(myInfoPtr->wStreamRef);
			myInfoPtr->isStreamInitd = FALSE;
		}
		free(myInfoPtr);
		return NULL;
	}
	return (MyInfoRef)myInfoPtr;
} 

static void CleanupAfterWAAN(MyStreamInfoPtr myInfoPtr)
{
	assert(myInfoPtr != NULL);
	if (myInfoPtr->isClientSet)
	{
		CFWriteStreamSetClient(myInfoPtr->wStreamRef, 0, NULL, NULL);
		CFWriteStreamUnscheduleFromRunLoop(myInfoPtr->wStreamRef, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		myInfoPtr->isClientSet = FALSE;
	}
}

static void CloseStreams(MyStreamInfoPtr myInfoPtr)
{
	assert(myInfoPtr != NULL);
	if (myInfoPtr->rStreamRef)
	{
		CFReadStreamClose(myInfoPtr->rStreamRef);
		myInfoPtr->rStreamRef = NULL;
	}
	if (myInfoPtr->wStreamRef)
	{
		CFWriteStreamClose(myInfoPtr->wStreamRef);
		myInfoPtr->wStreamRef = NULL;
	}
}

extern void StopWWAN(MyInfoRef infoRef)
{
	MyStreamInfoPtr myInfoPtr = (MyStreamInfoPtr)infoRef;
	
	printf("stopWWAN entered\n");
	assert(myInfoPtr != NULL);
	myInfoPtr->isConnected = FALSE;
	CleanupAfterWAAN(myInfoPtr);
	CloseStreams(myInfoPtr);
	free(myInfoPtr);
}
