//
//  CoreDataManager.m
//  JohnHancockETrunk
//
//  Created by Robert Brecher on 8/22/11.
//  Copyright 2011 Genuine Interactive. All rights reserved.
//

#import "CoreDataManager.h"
#import "Item.h"
#import "WhiskyItemObject.h"
@interface CoreDataManager (PrivateMethods)

- (NSArray *)searchTermsForString:(NSString *)searchString;

@end

@implementation CoreDataManager

#pragma mark -
#pragma mark Singleton Methods

static CoreDataManager *sharedCoreDataManager = nil;

+ (CoreDataManager *)sharedManager
{
	if (sharedCoreDataManager == nil) {
		sharedCoreDataManager = [[super allocWithZone:NULL] init];
	}
	return sharedCoreDataManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

//- (id)retain
//{
//	return self;
//}
//
//- (NSUInteger)retainCount
//{
//	return NSUIntegerMax;
//}
//
//- (oneway void)release
//{
//	// do nothing
//}
//
//- (id)autorelease
//{
//	return self;
//}

#pragma mark -
#pragma mark CoreData Stack

- (NSManagedObjectContext *)managedObjectContext
{	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	NSURL *storeUrl = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"WhiskyNotes.sqlite"]];
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
	if (![[NSFileManager defaultManager] setAttributes:[NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey] ofItemAtPath:[storeUrl path] error:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Overall Methods

- (BOOL)commitUpdates
{
	NSError *error;
	if (![managedObjectContext save:&error]) {
		NSLog(@"%@", [error localizedDescription]);
		return NO;
	}
	return YES;
}

- (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge NSString *)uuidStringRef;
}

- (void)addOrUpdateWhisky:(WhiskyItemObject *)wio
{	
	// get reference to local folder, create it if needed
    NSLog(@"UUID IN CD: %@", [wio uuid]);
	Item *whisky = (Item *)[self getWhiskyById:[wio uuid]];
    if(whisky == nil){
        whisky = (Item *)[NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:[self managedObjectContext]];
		//[localFolder setFolderId:[boxFolder objectId]];
        [whisky setUuid:[wio uuid]];
	}
	
	// set folder fields
	[whisky setName:[wio name]];
    [whisky setAge_statement:[wio age_statement]];
    [whisky setBrand:[wio brand ]];
    [whisky setCompany:[wio company ]];
    [whisky setFinish:[wio finish ]];
    [whisky setNose:[wio nose ]];
    [whisky setOverall:[wio overall ]];
    [whisky setRating:[wio rating]];
    [whisky setStrength:[wio strength]];
    [whisky setTimeStamp:[wio timeStamp ]];
    [whisky setPhoto:[wio photo]];

    NSLog(@"WIO NAME: %@",[wio name]);
	// apply update
	NSError *error;
	if (![managedObjectContext save:&error]) {
		NSLog(@"%@", [error localizedDescription]);
		//return nil;
	}
	//return localFolder;
}

- (WhiskyItemObject *)getWhiskyById:(NSString *)uuid{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"Item" inManagedObjectContext:[self managedObjectContext]]];
	[request setPredicate:[NSPredicate predicateWithFormat:@"uuid == %@", uuid]];
	NSArray *results = [managedObjectContext executeFetchRequest:request error:nil];
	if (!results || ![results count]) {
        NSLog(@"results = nil");
		return nil;
	}
    NSLog(@"LAST ELEMENT: %@", [results objectAtIndex:[results count]-1]);
    NSLog(@"UUID: %@", [[results objectAtIndex:[results count]-1] uuid]);
	NSLog(@"NAME: %@", [[results objectAtIndex:[results count]-1] name]);
    return [results objectAtIndex:[results count]-1];
}


- (WhiskyItemObject *)getLastWhisky
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"Item" inManagedObjectContext:[self managedObjectContext]]];
	//[request setPredicate:[NSPredicate predicateWithFormat:@"folderId == %@", folderId]];
	NSArray *results = [managedObjectContext executeFetchRequest:request error:nil];
	if (!results || ![results count]) {
        NSLog(@"results = nil");
		return nil;
	}
    NSLog(@"LAST ELEMENT: %@", [results objectAtIndex:[results count]-1]);
    NSLog(@"UUID: %@", [[results objectAtIndex:[results count]-1] uuid]);
	NSLog(@"NAME: %@", [[results objectAtIndex:[results count]-1] name]);
    return [results objectAtIndex:[results count]-1];
}

-(NSMutableArray *)getAllWhiskies{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Item" inManagedObjectContext:[self managedObjectContext]]];
    //[request setPredicate:[NSPredicate predicateWithFormat:@"folderId == %@", folderId]];
    NSArray *results = [managedObjectContext executeFetchRequest:request error:nil];
    if (!results || ![results count]) {
        NSLog(@"results = nil");
        return nil;
    }
    NSLog(@"LAST ELEMENT: %@", [results objectAtIndex:[results count]-1]);
    NSLog(@"UUID: %@", [[results objectAtIndex:[results count]-1] uuid]);
    NSLog(@"NAME: %@", [[results objectAtIndex:[results count]-1] name]);
    NSMutableArray *nsma = [results mutableCopy];
    //[results release];
    return nsma;
}

-(void)removeWhiskyItem:(NSString *)number{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Item" inManagedObjectContext:[self managedObjectContext]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"uuid == %@", number]];
    NSArray *results = [managedObjectContext executeFetchRequest:request error:nil];
    
    for(NSManagedObject *result in results){
        [managedObjectContext deleteObject:result];
    }
    
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
}

#pragma mark -
#pragma mark Utility

- (NSArray *)searchTermsForString:(NSString *)searchString
{
	searchString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return [searchString componentsSeparatedByString:@" "];
}

@end
