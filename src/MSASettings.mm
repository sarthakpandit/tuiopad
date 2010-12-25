/*
 *  MSASettings.mm
 *  TUIO Pad
 *
 *  Created by Mehmet Akten on 20/02/2009.
 *	Updated by Martin Kaltenbrunner 2010
 *  Copyright 2009 MSA Visuals Ltd.. All rights reserved.
 *
 */

#include "MSASettings.h"


#include <netdb.h>
#include <arpa/inet.h>
#include <unistd.h>

@implementation MSASettings

#pragma mark ----- Utility -----


- (NSString *)getIpAddress { 
	NSString *address = @"127.0.0.1";
	BOOL connected = [self connectedToNetwork];
	if (!connected) return address;
	
	struct ifaddrs *interfaces = NULL; 
	struct ifaddrs *temp_addr = NULL;
	int success = getifaddrs(&interfaces); 
	if (success == 0)  { 
		// Loop through linked list of interfaces  
		temp_addr = interfaces; 
		while(temp_addr != NULL)  { 
			if(temp_addr->ifa_addr->sa_family == AF_INET)  { 
				// Get NSString from C String  
				address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; 
				// Check if interface is en0 which is the wifi connection on the iPhone  
				NSLog([NSString stringWithFormat:@"MSASettings::found network device %s",temp_addr->ifa_name]);
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] rangeOfString:@"en"].location != NSNotFound) break;
			} 
			temp_addr = temp_addr->ifa_next; 
		} 
	} 
	// Free memory  
	freeifaddrs(interfaces); 
	return address; 
}

- (NSString *)getBroadcastAddress { 
	NSString *address = [self getIpAddress]; 
	NSArray *chunks = [address componentsSeparatedByString: @"."];
	address = [NSString stringWithFormat:@"%@.%@.%@.%i",  [chunks objectAtIndex: 0],[chunks objectAtIndex: 1],[chunks objectAtIndex: 2],255];

	return address; 
}

- (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
		NSLog(@"MSASettings::Could not recover network reachability flags");
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	
	if (!isReachable) NSLog(@"MSASettings::Network is unreachable");
	if (needsConnection) NSLog(@"MSASettings::Network needs connection");
			
	return (isReachable && !needsConnection) ? YES : NO;
}

#pragma mark ----- Getters -----

-(id)getDefaultFor:(NSString*)key {
	return [defaults objectForKey:key];
}


-(float)getFloat:(NSString*)key {
	return [[current objectForKey:key] floatValue];
}

-(int)getInt:(NSString*)key {
	return [[current objectForKey:key] intValue];
}

-(NSString*)getString:(NSString*)key {
	return [current objectForKey:key];
}

-(const char*)getCString:(NSString*)key {
	return [[current objectForKey:key] UTF8String];
}




#pragma mark ----- Setters -----

-(void)setFloat:(float)d forKey:(NSString*)key {
	[current setObject:[NSNumber numberWithFloat:d] forKey:key];
	//[self saveSettings];
}


-(void)setInt:(int)d forKey:(NSString*)key {
	[current setObject:[NSNumber numberWithInt:d] forKey:key];
	//[self saveSettings];
}

-(void)setString:(NSString*)d forKey:(NSString*)key {
	[current setObject:d forKey:key];
	//[self saveSettings];
}


-(void)setCString:(char*)d forKey:(NSString*)key {
	[current setObject:[NSString stringWithCString:d] forKey:key];
	//[self saveSettings];
}




#pragma mark ----- Save & load -----

-(void)loadSettings {
	NSLog(@"MSASettings::loadSettings");
	[current release];
	current = [[[NSUserDefaults standardUserDefaults] objectForKey:kSettings_Key] mutableCopy];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



-(void)saveSettings {
	NSLog(@"MSASettings::saveSettings");
	[[NSUserDefaults standardUserDefaults] setObject:current forKey:kSettings_Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



#pragma mark ----- System -----

-(void)awakeFromNib {
	NSLog(@"MSASettings::awakeFromNib");
	
	defaults = [[NSDictionary alloc] initWithObjectsAndKeys:
				[self getBroadcastAddress], kSetting_HostIP,
				[NSNumber numberWithInt:3333], kSetting_Port,
				[NSNumber numberWithInt:0], kSetting_Packet,
				[NSNumber numberWithInt:0], kSetting_Orientation, 
				[NSNumber numberWithInt:1], kSetting_PeriodicUpdates, 
				[NSNumber numberWithInt:1], kSetting_FullUpdates, 
				nil];

    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:defaults forKey:kSettings_Key]];
    [[NSUserDefaults standardUserDefaults] synchronize];

	[self loadSettings];
}


-(void)dealloc {
	NSLog(@"MSASettings::dealloc");
	[defaults release];
	[current release];
	[super dealloc];
}



@end
