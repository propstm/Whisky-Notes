//
//  AddEntryViewController.h
//  Whisky Notes
//
//  Created by Matthew Propst on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhiskyItemObject.h"
#import "Item.h"
#import "CoreDataManager.h"

@interface AddEntryViewController : UIViewController <UISplitViewControllerDelegate>{
    IBOutlet UIButton *addItem;
    IBOutlet UIButton *cancelItem;
    WhiskyItemObject *itemWhisky;
    WhiskyItemObject *wio;
    UITextField *nameField;
    UITextField *brandField;
    UITextField *companyField;
    UITextField *ageField;
    UITextField *strengthField;
    UITextView *noseField;
    UITextView *finishField;
    UITextView *overallField;
    UITextField *ratingField;
    NSString *uuidField;
    BOOL isPad;
    
    
}

@property (nonatomic) IBOutlet UIButton *addItem;
@property (nonatomic) IBOutlet UIButton *cancelItem;

@property (strong, nonatomic) id detailItem;
@property (nonatomic) WhiskyItemObject *itemWhisky;
@property (nonatomic) WhiskyItemObject *wio;
@property (nonatomic) IBOutlet UITextField *nameField;
@property (nonatomic) IBOutlet UITextField *brandField;
@property (nonatomic) IBOutlet UITextField *companyField;
@property (nonatomic) IBOutlet UITextField *ageField;
@property (nonatomic) IBOutlet UITextField *strengthField;
@property (nonatomic) IBOutlet UITextView *noseField;
@property (nonatomic) IBOutlet UITextView *finishField;
@property (nonatomic) IBOutlet UITextView *overallField;
@property (nonatomic) IBOutlet UITextField *ratingField;
@property (nonatomic) NSString *uuidField;

-(IBAction)clickedButton:(id)sender;
-(IBAction)clickedCancelButton:(id)sender;
-(BOOL)isPadCheck;
@end
