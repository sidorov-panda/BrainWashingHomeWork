//
//  WPIssueModel.h
//  BrainWashingHomeWork
//
//  Created by panda on 05.08.13.
//  Copyright (c) 2013 WiredPanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WPIssueModel : NSManagedObject

@property (nonatomic, retain) NSNumber * issueId;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *products;

+ (void)issuesWithCompletionHandler:(void (^)(NSArray *issues,
                                              NSError *error))completionHandler;

@end

@interface WPIssueModel (CoreDataGeneratedAccessors)

- (void)addProductsObject:(NSManagedObject *)value;
- (void)removeProductsObject:(NSManagedObject *)value;
- (void)addProducts:(NSSet *)values;
- (void)removeProducts:(NSSet *)values;

@end
