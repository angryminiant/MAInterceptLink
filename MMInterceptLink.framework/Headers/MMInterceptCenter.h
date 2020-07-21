//
//  MMInterceptCenter.h
//  InterceptLink
//
//  Created by mm on 2018/8/19.
//  Copyright © 2018 mm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMInterceptCenter : NSObject

/// 设置数据
/// @param params <#params description#>
+ (void) setParams:(NSDictionary *) params;

/// 获取数据
+ (NSDictionary *) getResultParams;

/// 清空数据
+ (void) clearData;

/// 打印所有链接
+ (void) ShowInterceptLog;

/// 打印拦截目标链接
+ (void) ShowInterceptTargetLog;

/// 注册
+ (void) registerIntercept;

/// 注销
+ (void) unregisterIntercept;

@end

NS_ASSUME_NONNULL_END
