//
//  ProtocolReplace.h
//  ecmc
//
//  Created by Zhu Yujie on 2/16/11.
//  Copyright 2011 Company. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProtocolReplace : NSObject {

}
-(NSString*) replaceProtocol:(NSString*)str map:(NSMutableDictionary*)map;
-(NSString*) replaceSql:(NSString*)str map:(NSMutableDictionary*)map;
@end
