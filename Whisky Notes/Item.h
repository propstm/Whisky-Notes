//
//  Item.h
//  Whisky Notes
//
//  Created by Matthew Propst on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic) NSString * age_statement;
@property (nonatomic) NSString * brand;
@property (nonatomic) NSString * company;
@property (nonatomic) NSString * finish;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * nose;
@property (nonatomic) NSString * overall;
@property (nonatomic) NSData * photo;
@property (nonatomic) NSString * rating;
@property (nonatomic) NSString * strength;
@property (nonatomic) NSDate * timeStamp;
@property (nonatomic) NSString * uuid;

@end
