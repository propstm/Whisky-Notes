//
//  WhiskyItemObject.h
//  Whisky Notes
//
//  Created by Matthew Propst on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WhiskyItemObject : NSObject {
    NSString * age_statement;
    NSString * brand;
    NSString * company;
    NSString * finish;
    NSString * nose;
    NSString * overall;
    NSString * __weak rating;
    NSString * __weak strength;
    NSDate * timeStamp;
    NSString * name;
    NSData * photo;
    NSString * uuid;
}

@property (nonatomic) NSString * age_statement;
@property (nonatomic) NSString * brand;
@property (nonatomic) NSString * company;
@property (nonatomic) NSString * finish;
@property (nonatomic) NSString * nose;
@property (nonatomic) NSString * overall;
@property (nonatomic, weak) NSString * rating;
@property (nonatomic, weak) NSString * strength;
@property (nonatomic) NSDate * timeStamp;
@property (nonatomic) NSString * name;
@property (nonatomic) NSData * photo;
@property (nonatomic) NSString * uuid;

@end
