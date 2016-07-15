//
//  PersistProxy.h
//  ecmc
//
//  Created by Yujie Zhu on 1/13/11.
//  Copyright 2011 Company. All rights reserved.
//
/**
 * sqlite3 持久化类
 * @author zhuyujie
 *
 */
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface PersistProxy : NSObject {
	sqlite3 *contactDB;
}
- (NSMutableArray*) query:(NSString*)sql nsmdirect:(NSMutableDictionary*)selectionArgs columns:(NSArray*)columsArgs;
- (int) execute:(NSString*)sql nsmdirect:(NSMutableDictionary*)parameters;
- (int) execute:(NSString*)sql;
@end

