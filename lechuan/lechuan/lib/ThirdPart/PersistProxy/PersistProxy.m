//
//  PersistProxy.m
//  ecmc
//
//  Created by Yujie Zhu on 1/13/11.
//  Copyright 2011 Company. All rights reserved.
//

#import "PersistProxy.h"
#import "ProtocolReplace.h"
#import "Utilities.h"
/**
 *  数据库持久化类
 */

@implementation PersistProxy

- (NSMutableArray*)query:(NSString*)sql nsmdirect:(NSMutableDictionary*)selectionArgs columns:(NSArray*)columsArgs
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    NSString *databasePath = [Utilities documentsPath:DB_NAME];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt   *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        ProtocolReplace *resql =[[ProtocolReplace alloc]init];
        NSString *newSql = [resql replaceSql:sql map:selectionArgs];
        
        const char *query_stmt = [newSql UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
                for (int i=0; i< sqlite3_column_count(statement);i++)
                {
                    NSString *columName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_name(statement, i)];
                    NSString *columValue = nil;
                    if(sqlite3_column_text(statement, i)!=nil)
                    {
                        columValue = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, i)];
                        //为空值是 挂掉
                        [resultMap setObject:columValue forKey: columName];
                    }
                }
                [resultList addObject:resultMap];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return resultList;
}

/*
 参数：	NSMutableDictionary *parameters
 例如：	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity: 1];
 [parameters setObject: @"100" forKey: @"id"];
 */
- (int) execute:(NSString*)sql nsmdirect:(NSMutableDictionary*)parameters{
    int flag = 1;
    sqlite3_stmt  *statement = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentDirectory stringByAppendingPathComponent:DB_NAME];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        ProtocolReplace *resql =[[ProtocolReplace alloc]init];
        NSString *insertSQL = [resql replaceSql:sql map:parameters];
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            flag = 1;
        } else
        {
            flag = 0;
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return flag;
}

- (int) callback1
{
    return 1;
}

- (int)execute:(NSString*)sql
{
    int flag = 1;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentDirectory stringByAppendingPathComponent:DB_NAME];	
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = [sql UTF8String];
        if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            flag = 1;
        }else 
        {
            flag = 0;
        }		
        sqlite3_close(contactDB);		
    } 
    else 
    {
        flag = 0;
    }
    return flag;
}

@end
