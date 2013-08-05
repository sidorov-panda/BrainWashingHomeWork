//
//  WPBaseModel.m
//  BrainWashingHomeWork
//
//  Created by panda on 05.08.13.
//  Copyright (c) 2013 WiredPanda. All rights reserved.
//

#import "WPBaseModel.h"

@implementation WPBaseModel

+ (id)save:(id)instance {
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([instance class]) inManagedObjectContext:[[WPCoreDataManager sharedInstance] defaultManagedObjectContext]];
}

@end
