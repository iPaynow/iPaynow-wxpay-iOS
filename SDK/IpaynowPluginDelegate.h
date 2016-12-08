//
//  IpaynowPluginDelegate.h
//  TestIpaynow
//
//  Created by dby on 14-8-17.
//  Copyright (c) 2014年 Ipaynow. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IPNPayResult) {
    IPNPayResultFail           ,  //失败
    IPNPayResultSuccess   ,  //成功
    IPNPayResultCancel      ,  //取消
    IPNPayResultUnknown     //未知
};

@protocol IpaynowPluginDelegate <NSObject>


/**
 支付回调结果展示

 @param result 支付结果状态枚举
 @param errorCode 错误码
 @param errorInfo 错误信息
 
 */
- (void)iPaynowPluginResult:(IPNPayResult)result errorCode:(NSString *)errorCode errorInfo:(NSString *)errorInfo;
@end
