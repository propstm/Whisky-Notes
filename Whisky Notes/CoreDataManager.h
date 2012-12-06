//
//  CoreDataManager.h
//  JohnHancockETrunk
//
//  Created by Robert Brecher on 8/22/11.
//  Copyright 2011 Genuine Interactive. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Item.h"
#import "WhiskyItemObject.h"

@class LocalComment, LocalFavorite, LocalFile, LocalFileTag, LocalFolder, LocalTag;

@interface CoreDataManager : NSObject {
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataManager *)sharedManager;
- (BOOL)commitUpdates;
- (void)addOrUpdateWhisky:(WhiskyItemObject *)wio;
- (WhiskyItemObject *)getWhiskyById:(NSString *)uuid;
- (WhiskyItemObject *)getLastWhisky;
- (NSMutableArray *)getAllWhiskies;
- (NSString *)uuid;
- (void)removeWhiskyItem:(NSString *)number;

@end
