//
//  WPWineAPI.h
//  BrainWashingHomeWork
//
//  Created by panda on 05.08.13.
//  Copyright (c) 2013 WiredPanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPWineAPI : NSObject

+ (WPWineAPI *)sharedInstance;

- (void)productsWithSuccess:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id JSON))success
                    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

- (void)storesWithSuccess:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id JSON))success
                  failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;


- (void)issuesWithSuccess:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id JSON))success
                  failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end
