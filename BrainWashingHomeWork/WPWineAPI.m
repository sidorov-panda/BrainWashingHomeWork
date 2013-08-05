//
//  WPWineAPI.m
//  BrainWashingHomeWork
//
//  Created by panda on 05.08.13.
//  Copyright (c) 2013 WiredPanda. All rights reserved.
//

#import "WPWineAPI.h"

@implementation WPWineAPI

static NSString *kWineAPIURL = @"http://wine.anvd.cc/api/";

+ (WPWineAPI *)sharedInstance {
    static WPWineAPI *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (AFHTTPClient *)defaultHttpClient {
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kWineAPIURL]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    return httpClient;
}

- (void)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters succes:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id JSON))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure {
    
    AFHTTPClient * httpClient = [self defaultHttpClient];
    NSMutableURLRequest * request = [httpClient requestWithMethod:method path:path parameters:@{}.copy];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    [request setTimeoutInterval:((float)15)];

    
    AFPropertyListRequestOperation *operation = [AFPropertyListRequestOperation propertyListRequestOperationWithRequest:request success:success failure:failure];
    [AFPropertyListRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plist"]];
    [operation start];
}

- (void)productsWithSuccess:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id JSON))success
             failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure {
    [self requestWithMethod:@"GET" path:@"products.plist" parameters:@{}.copy succes:success failure:failure];
}

- (void)storesWithSuccess:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id JSON))success
                    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure {
    [self requestWithMethod:@"GET" path:@"stores.plist" parameters:@{}.copy succes:success failure:failure];

}

- (void)issuesWithSuccess:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id JSON))success
                  failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure {
    [self requestWithMethod:@"GET" path:@"issues.plist" parameters:@{}.copy succes:success failure:failure];
}

@end
