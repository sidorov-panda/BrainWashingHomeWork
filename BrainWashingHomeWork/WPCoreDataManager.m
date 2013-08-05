//
//  WPCoreDataManager.m
//  BrainWashingHomeWork
//
//  Created by panda on 05.08.13.
//  Copyright (c) 2013 WiredPanda. All rights reserved.
//

#import "WPCoreDataManager.h"

@implementation WPCoreDataManager

+ (instancetype)sharedInstance {
    static WPCoreDataManager *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[WPCoreDataManager alloc] init];
    });
    return instance;
}

- (NSArray *)objectWithType:(NSString *)object
                descriptors:(NSArray*)descriptors
                  predicate:(NSPredicate*)predicate
                  inContext:(NSManagedObjectContext *)context {
    // Создаем request для получения объектов
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    // Устанавливаем получение полных объектов, не faults (по умолчанию)
    [request setReturnsObjectsAsFaults:NO];
    
    // Получаем объект описания записи, который необходим для request
    NSEntityDescription* desc = [NSEntityDescription entityForName:object inManagedObjectContext:[[WPCoreDataManager sharedInstance] defaultManagedObjectContext]];
    
    [request setEntity:desc];
    
    // Устанавливаем descriptors для сортивки результатов
    if (descriptors != nil) {
        [request setSortDescriptors:descriptors];
    }
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id != 0"];
    // Устанавливаем predicate для ограничения количества объектов
    if (predicate != nil) {
        [request setPredicate:predicate];
    }
    
    // Выполняем запрос с инициализированным request
    NSError* error = nil;
    NSArray* result = nil;
    result = [[[WPCoreDataManager sharedInstance] defaultManagedObjectContext] executeFetchRequest:request error:&error];
    
    // Есть есть ошибки возвращаем nil
    if ((result == nil) || (error != nil)) {
        return nil;
    }
    
    return result;
}


- (void)loadContextWithCompletionHandler:(void (^)(NSError *error))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BrainWashingHomeWork" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        NSPersistentStoreCoordinator *psc =[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        if (psc) {
            NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
            [context setPersistentStoreCoordinator:psc];
            self.defaultManagedObjectContext = context;
        }
        NSError *error;
        //Добавляем БД к psc
        NSURL *documentURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                     inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [documentURL URLByAppendingPathComponent:@"BrainWashingHomeWork.sqlite"];
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                          configuration:nil
                                    URL:storeURL
                                options:@{}.copy
                                  error:&error];
        
        if (store) {
            completion(nil);
            return;
        }
        completion(error);
        return;
    });
}

- (void)insertObject:(id)object {
    [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([object class]) inManagedObjectContext:self.defaultManagedObjectContext];
}


- (void)saveContext:(NSManagedObjectContext *)context {
    NSParameterAssert(context);
    
    if (![context hasChanges]) {
		return;
    }
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"%@", error);
    }
}

@end
