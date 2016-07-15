//
//  KeychainContext.m
//  ecmc
//
//  Created by hangqian on 14-9-10.
//  Copyright (c) 2014年 cp9. All rights reserved.
//

#import "KeychainContext.h"

@implementation KeychainContext

static KeychainContext *keychainContext;

+ (KeychainContext *) sharedKeychainContext
{
	@synchronized(self)
	{
        if(keychainContext == nil)
		{
            keychainContext = [[KeychainContext alloc] init];
        }
    }
	
    return keychainContext;
}

- (id) init
{
	self = [super init];
    if (self) {
        NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *identifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
        keychain=[[KeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
    }
    return self;
}

- (NSString*)getUUID
{
    NSString *uudi = [keychain  objectForKey:(id)kSecAttrAccount];
    if([uudi isEqual:[NSNull null]] || [uudi length] == 0)
    {
        
        NSString *cfuuidString = [self getDeviceUUID];
        [keychain setObject:cfuuidString forKey:(id)kSecAttrAccount];// 上面两行用来标识一个Item
        uudi = [NSString stringWithFormat:@"%@",cfuuidString];
    }
    return uudi;
}

-(NSString *)getDeviceUUID
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+(void)clearResource
{
    if(keychainContext)
    {
        [keychainContext release];
        keychainContext = nil;
    }
}

-(void)dealloc
{
    if(keychain)
    {
        [keychain release];
        keychain = nil;
    }
	
	[super dealloc];
}

@end
