//
//  WPCoreDataManager.h
//  BrainWashingHomeWork
//
//  Created by panda on 05.08.13.
//  Copyright (c) 2013 WiredPanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPCoreDataManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *defaultManagedObjectContext;

+ (instancetype)sharedInstance;

- (NSArray *)objectWithType:(NSString *)object
                descriptors:(NSArray*)descriptors
                  predicate:(NSPredicate*)predicate
                  inContext:(NSManagedObjectContext *)context;

- (void)loadContextWithCompletionHandler:(void (^)(NSError *error))completion;

- (void)saveContext:(NSManagedObjectContext *)context;

@end
