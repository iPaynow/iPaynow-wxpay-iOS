//
//  IpaynowPluginApi.h
//  TestPlugin
//
//  Created by dby on 14-8-19.
//  Copyright (c) 2014年 Ipaynow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IpaynowPluginDelegate.h"

@interface IpaynowPluginApi : NSObject

/**
 *  是否隐藏loading页面
 *
 *  @param isHidden 是/否
 */
+ (void)setLoadingViewHidden:(BOOL)isHidden;



/**
 是否在支付状态返回之前隐藏loading页面(不建议使用)

 @param isHidden 隐藏
 */
+ (void)setBeforeReturnLoadingHidden:(BOOL)isHidden;

// 订单发起
+ (BOOL)pay:(NSString*)data AndScheme:(NSString*)scheme viewController:(UIViewController*)viewController delegate:(id<IpaynowPluginDelegate>)delegate;

// 回调方法
+ (void)willEnterForeground;
@end
