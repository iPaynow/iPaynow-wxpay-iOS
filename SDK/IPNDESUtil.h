//
//  IPNDESUtil.h
//  TestPlugin
//
//  Created by 刘宁 on 14/11/26.
//  Copyright (c) 2014年 Ipaynow. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IPNDESUtil : NSObject

+ (NSString*)md5Encrypt: (NSString *) inPutText;
+ (NSString *)TripleDESEncrypt:(NSString *)plainText WithKey:(NSString *)keyStr;
+ (NSString *)hexStringFromString:(NSData *)data;

@end
