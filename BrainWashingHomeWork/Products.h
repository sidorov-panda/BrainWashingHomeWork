//
//  Products.h
//  BrainWashingHomeWork
//
//  Created by panda on 05.08.13.
//  Copyright (c) 2013 WiredPanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WPIssueModel;

@interface Products : NSManagedObject

@property (nonatomic, retain) NSNumber * productId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * brief;
@property (nonatomic, retain) NSNumber * issueId;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * label2x;
@property (nonatomic, retain) NSString * bottle;
@property (nonatomic, retain) NSString * bottle2x;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) WPIssueModel *issue;

+ (void)productWithCompletionHandler:(void (^)(NSArray *products,
                                               NSError *error))completionHandler;

@end
