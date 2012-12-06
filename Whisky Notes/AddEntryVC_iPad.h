//
//  AddEntryVC_iPad.h
//  Whisky Notes
//
//  Created by Matthew Propst on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhiskyItemObject.h"


@interface AddEntryVC_iPad : UIViewController <UISplitViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate>{
    UITableView *tableView; 
    UITableView *topTableView;
    UIButton *cancelButton;
    UIButton *saveButton;
    WhiskyItemObject *wio;
    NSString *uuidField;
    NSString *tname;
    NSString *tdistillery;
    NSString *tage;
    NSString *tstrength;
    
    NSString *tnose;
    NSString *tfinish;
    NSString *toverall;
    NSString *trating;
    UIImageView *imgView;
    UIImage *myImg;
    UIButton *imageBtn;
    BOOL tookImage;
    UIPopoverController *popoverController;
    BOOL isPad;
    
    UIImagePickerController *imagePickerController;
    UIPopoverController *imagePickerPopoverController;
    BOOL keyboardVisible;
    CGPoint offset;
    CGSize keyboardSize;
    CGRect tvFrame;
}

@property (nonatomic) UIPopoverController *popoverController;
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UITableView *topTableView;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *saveButton;
@property (nonatomic) WhiskyItemObject *wio;
@property (nonatomic) NSString *uuidField;
@property (nonatomic) NSString *tname;
@property (nonatomic) NSString *tdistillery;
@property (nonatomic) NSString *tage;
@property (nonatomic) NSString *tstrength;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIPopoverController *imagePickerPopoverController;
@property (nonatomic) NSString *tnose;
@property (nonatomic) NSString *tfinish;
@property (nonatomic) NSString *toverall;
@property (nonatomic) NSString *trating;
@property (nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic) IBOutlet UIImage *myImg;
@property (nonatomic) IBOutlet UIButton *imageBtn;

- (UIButton *)cancelButton;
- (UIButton *)saveButton;
- (IBAction)showActionSheet:(id)sender;
- (IBAction)clickedCancelButton:(id)sender;
- (IBAction)clickedButton:(id)sender;
- (BOOL)isPadCheck;
- (void)setupWhiskyObject:(WhiskyItemObject *)passedWhiskyObj;
- (void) keyboardDidShow: (NSNotification *)notif;
- (void) keyboardDidHide: (NSNotification *)notif;


@end
