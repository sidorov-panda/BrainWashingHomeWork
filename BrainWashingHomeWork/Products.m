//
//  Products.m
//  BrainWashingHomeWork
//
//  Created by panda on 05.08.13.
//  Copyright (c) 2013 WiredPanda. All rights reserved.
//

#import "Products.h"
#import "WPIssueModel.h"


@implementation Products

@dynamic productId;
@dynamic title;
@dynamic comment;
@dynamic desc;
@dynamic brief;
@dynamic issueId;
@dynamic label;
@dynamic label2x;
@dynamic bottle;
@dynamic bottle2x;
@dynamic country;
@dynamic issue;

+ (void)productWithCompletionHandler:(void (^)(NSArray *products,
                                               NSError *error))completionHandler {
    
    void (^successHandler)(NSURLRequest *request,
                           NSHTTPURLResponse *response,
                           id JSON) = ^(NSURLRequest *request,
                                        NSHTTPURLResponse *response,
                                        id JSON) {
        NSMutableArray *products = [[NSMutableArray alloc] init];
        for (NSDictionary *product in JSON[@"products"]) {
            
            NSArray *savedProductModels = [[WPCoreDataManager sharedInstance]
                                         objectWithType:NSStringFromClass([self class])
                                         descriptors:nil
                                         predicate:[NSPredicate predicateWithFormat:@"productId = %@", product[@"id"]]
                                         inContext:[[WPCoreDataManager sharedInstance] defaultManagedObjectContext]];
            if ([savedProductModels count] > 0) {
                [products addObject:savedProductModels[0]];
                continue;
            }
            Products *productModel = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:[WPCoreDataManager sharedInstance].defaultManagedObjectContext];
            productModel.productId = product[@"id"];
            productModel.issueId = product[@"issue_id"];
            productModel.title = product[@"title"];
            productModel.bottle = product[@"bottle"];
            productModel.bottle2x = product[@"bottle2x"];
            productModel.label = product[@"label"];
            productModel.label2x = product[@"label2x"];
            [products addObject:productModel];
        }
        
        completionHandler(products, nil);
    };
    
    void (^failureHandler)(NSURLRequest *request,
                           NSHTTPURLResponse *response,
                           NSError *error,
                           id JSON) = ^(NSURLRequest *request,
                                        NSHTTPURLResponse *response,
                                        NSError *error,
                                        id JSON) {
        completionHandler(nil, error);
    };
    
    [[WPWineAPI sharedInstance] productsWithSuccess:successHandler failure:failureHandler];
}

@end
