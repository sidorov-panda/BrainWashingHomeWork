//
//  WPIssueModel.m
//  BrainWashingHomeWork
//
//  Created by panda on 05.08.13.
//  Copyright (c) 2013 WiredPanda. All rights reserved.
//

#import "WPIssueModel.h"


@implementation WPIssueModel

@dynamic issueId;
@dynamic number;
@dynamic title;
@dynamic products;

+ (void)issuesWithCompletionHandler:(void (^)(NSArray *issues,
                                              NSError *error))completionHandler {
    
    void (^successHandler)(NSURLRequest *request,
                           NSHTTPURLResponse *response,
                           id JSON) = ^(NSURLRequest *request,
                                        NSHTTPURLResponse *response,
                                        id JSON) {
        
        
        NSMutableArray *issues = [[NSMutableArray alloc] init];
        for (NSDictionary *issue in JSON[@"issues"]) {
            NSArray *savedIssueModels = [[WPCoreDataManager sharedInstance]
                                         objectWithType:NSStringFromClass([self class])
                                         descriptors:nil
                                         predicate:[NSPredicate predicateWithFormat:@"issueId = %@", issue[@"id"]]
                                         inContext:[[WPCoreDataManager sharedInstance] defaultManagedObjectContext]];
            if ([savedIssueModels count] > 0) {
                [issues addObject:savedIssueModels[0]];
                continue;
            }
            WPIssueModel *issueModel = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:[WPCoreDataManager sharedInstance].defaultManagedObjectContext];
            issueModel.issueId = issue[@"id"];
            issueModel.number = issue[@"number"];
            issueModel.title = issue[@"title"];
            [[WPCoreDataManager sharedInstance] saveContext:[[WPCoreDataManager sharedInstance] defaultManagedObjectContext]];
            [issues addObject:issueModel];
        }
        completionHandler(issues, nil);
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
    
    [[WPWineAPI sharedInstance] issuesWithSuccess:successHandler failure:failureHandler];
}

@end
