//
//  KeychainContext.h
//  ecmc
//
//  Created by hangqian on 14-9-10.
//  Copyright (c) 2014年 cp9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

@interface KeychainContext : NSObject
{
	KeychainItemWrapper *keychain;
}

+(void)clearResource;
+ (KeychainContext *) sharedKeychainContext;
- (NSString*) getUUID;
@end
