//
//  MMInterceptCenter.m
//  InterceptLink
//
//  Created by mm on 2018/8/19.
//  Copyright © 2018 mm. All rights reserved.
//

#import "MMInterceptCenter.h"

//static NSString*const SOURURL  = @"";
//static NSString*const LOCALURL = @"";
//static NSString*const FilterProtocolURLHandledKey = @"filteredCssKey";
//static NSDictionary *Params;
//static NSDictionary *ResultParams;
//static BOOL InterceptLog;
//static BOOL InterceptTargetLog;


@interface InterceptProtocol : NSURLProtocol

//@property (nonatomic, strong) NSMutableData *responseData;
//@property (nonatomic, strong) NSURLConnection *connection;


@end

@implementation MMInterceptCenter


//static NSString*const SOURURL  = @"";
//static NSString*const LOCALURL = @"";
//static NSString*const FilterProtocolURLHandledKey = @"filteredCssKey";
//static NSDictionary *Params;
//static NSDictionary *ResultParams;
//static BOOL InterceptLog;
//static BOOL InterceptTargetLog;

NSString*const SOURURL  = @"";
NSString*const LOCALURL = @"";
NSString*const FilterProtocolURLHandledKey = @"filteredCssKey";
NSDictionary *Params;
NSDictionary *ResultParams;
BOOL InterceptLog;
BOOL InterceptTargetLog;


/// 设置数据
/// @param params <#params description#>
+ (void) setParams:(NSDictionary *) params {
    Params = params;
}

/// 获取数据
+ (NSDictionary *) getResultParams {
    
    return [ResultParams copy];;
}

/// 打印所有链接
+ (void) ShowInterceptLog {
    InterceptLog = YES;
}

/// 打印拦截目标链接
+ (void) ShowInterceptTargetLog {
    InterceptTargetLog = YES;
}

/// 清空数据
+ (void) clearData {
    
    Params = nil;
    ResultParams = nil;
    InterceptLog = NO;
    InterceptTargetLog = NO;
}

/// 注册
+ (void) registerIntercept {
    
    [NSURLProtocol registerClass:[InterceptProtocol class]];
}

/// 注销
+ (void) unregisterIntercept {

    [NSURLProtocol unregisterClass:[InterceptProtocol class]];
}
@end


@implementation InterceptProtocol
// <NSURLConnectionDelegate>
//@implementation declaration cannot be protocol qualified Replace '<NSURLConnectionDelegate>' with ''
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    NSString *urlStr = request.URL.absoluteString;
    NSString *scheme = [[request URL] scheme];
        
    if ( InterceptTargetLog ) {
        NSLog(@"Intercept link = %@",urlStr);
    }
    
    //只处理http和https请求
    if ([scheme caseInsensitiveCompare:@"http"]  == NSOrderedSame || [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame ) {
        // 判断是否已经处理过了，防止无限循环
        if ( [NSURLProtocol propertyForKey:FilterProtocolURLHandledKey inRequest:request] ) {
            
            return NO;
        }
        NSString *logout = [Params objectForKey:@"intercept_link_1"];
        if ( logout.length > 0 && [urlStr rangeOfString:logout].location != NSNotFound ) {
                        
            [[NSNotificationCenter defaultCenter] postNotificationName:[Params objectForKey:@"intercept_notifi_1"] object:nil];
        }
        
        NSString *filterUrl = [Params objectForKey:@"intercept_link_2"];
            if ( filterUrl.length > 0 && [urlStr rangeOfString:filterUrl].location != NSNotFound ) {
            
            if ( InterceptTargetLog ) {
                NSLog(@"Intercept target link = %@",request.URL.absoluteString);
            }
            ResultParams = @{@"result_1": request.URL};
            [[NSNotificationCenter defaultCenter] postNotificationName:[Params objectForKey:@"intercept_notifi_2"] object:nil];
            return YES;
        }
        return NO;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    if ( SOURURL.length > 0 && LOCALURL.length > 0 ) {
        
        //截取重定向
        if ( [request.URL.absoluteString isEqualToString:SOURURL] ) {
            
            NSURL* url1 = [NSURL URLWithString:LOCALURL];
            mutableReqeust = [NSMutableURLRequest requestWithURL:url1];
        }
    }
    
    return mutableReqeust;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
    
    NSMutableURLRequest *request = [[self request] mutableCopy];
    
    //给我们处理过的请求设置一个标识符, 防止无限循环,
    [NSURLProtocol setProperty:@YES forKey:FilterProtocolURLHandledKey inRequest:request];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ( InterceptTargetLog ) {
            NSLog(@"%@",obj);
        }
    }];
    [dataTask resume];// 启动，继续
    
    // iOS 2.0-9.0
//    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
//    [self.connection start];
}

- (void)stopLoading {
    
//    if (self.connection != nil) {
//        [self.connection cancel];
//        self.connection = nil;
//    }
}

//#pragma mark- NSURLConnectionDelegate iOS 2.0-9.0
//// 网络请求的响应结果
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//
//    [self.client URLProtocol:self didFailWithError:error];
//}
//
//#pragma mark - NSURLConnectionDataDelegate
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//
//    // 每个被拦截的有效链接的响应开始 初始化接受数据的responseData
//    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//
//    self.responseData = [[NSMutableData alloc] init];
//}
//
//// 接收网络响应数据， 多次调用
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//
//    // 每个被拦截的有效练级的返回数据 数据可能只是所有返回数据的一部分，需要拼接到responseData中
//
//    // 返回给URL Loading System接收到的数据，这个很重要，不然光截取不返回，就瞎了。
//    [self.client URLProtocol:self didLoadData:data];
//
//    [self.responseData appendData:data];
//
//    // 打印返回数据
//    NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    if (dataStr) {
//        //        NSLog(@"部分截取数据: %@", dataStr);
//    }
//}
//
//// 网络请求结束
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//
//    // 每个被拦截的有效练级的返回数据 结束
//    [self.client URLProtocolDidFinishLoading:self];
//
//    // 回调数据
//    NSString *dataStr = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
//    if ( dataStr  ) {
//
//        NSLog(@"所有截取数据: %@", dataStr);
//
//    }
//
//}


@end
