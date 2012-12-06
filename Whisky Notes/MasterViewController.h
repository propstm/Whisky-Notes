//
//  MasterViewController.h
//  Whisky Notes
//
//  Created by Matthew Propst on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class AddEntryViewController;

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController{
    NSMutableArray *nsma;
    BOOL isPad;
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) AddEntryViewController *addEntryViewController;
@property (nonatomic) IBOutlet NSMutableArray *nsma;
-(BOOL)isPadCheck;
-(void)reloadRootTable;
@end
