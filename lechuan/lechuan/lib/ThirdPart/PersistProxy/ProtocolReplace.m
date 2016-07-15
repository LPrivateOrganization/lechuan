//
//  ProtocolReplace.m
//  ecmc
//
//  Created by Zhu Yujie on 2/16/11.
//  Copyright 2011 Company. All rights reserved.
//

#import "ProtocolReplace.h"


@implementation ProtocolReplace
-(NSString*) replaceProtocol:(NSString*)str map:(NSMutableDictionary*)map{
	NSArray *keys = [map allKeys];
	for (int i = 0; i < [keys count]; i++) {
		NSString *value = [map objectForKey:[keys objectAtIndex:i]];
		NSString *key = [NSString stringWithFormat:@"$%@$",[keys objectAtIndex:i]];
		str = [str stringByReplacingOccurrencesOfString:key withString:value];
	}
	return str;
}


-(NSString*) replaceSql:(NSString*)str map:(NSMutableDictionary*)map
{
	NSArray *keys = [map allKeys];
	//NSString* replacedSql = nil;
	for (int i = 0; i < [keys count]; i++)
	{
		NSString *value = [map objectForKey:[keys objectAtIndex:i]];
		NSString *key = [NSString stringWithFormat:@":%@",[keys objectAtIndex:i]];
		NSString *tmpvalue = [NSString stringWithFormat:@"\"%@\"",value];
		str = [str stringByReplacingOccurrencesOfString:key withString:tmpvalue];
	}
	return str;
}
@end

