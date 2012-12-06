//
//  AddEntryViewController.m
//  Whisky Notes
//
//  Created by Matthew Propst on 1/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AddEntryViewController.h"
#import "MasterViewController.h"
#import "CoreDataManager.h"
#import "WhiskyItemObject.h"
#import "AppDelegate.h"

@interface AddEntryViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation AddEntryViewController
@synthesize detailItem = _detailItem;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize addItem;
@synthesize cancelItem;
@synthesize wio, itemWhisky;
@synthesize nameField;
@synthesize brandField;
@synthesize companyField;
@synthesize ageField;
@synthesize strengthField;
@synthesize overallField;
@synthesize finishField;
@synthesize noseField;
@synthesize ratingField;
@synthesize uuidField;



-(IBAction)clickedButton:(id)sender{
    wio = [[WhiskyItemObject alloc] init];
    [wio setNose : noseField.text];
    [wio setName : nameField.text];
    [wio setTimeStamp:[[NSDate alloc] init]];
    [wio setCompany : brandField.text];
    [wio setAge_statement : ageField.text];
    [wio setOverall : overallField.text];
    [wio setFinish : finishField.text];
    [wio setBrand : brandField.text];
    
    [wio setOverall : overallField.text];
    [wio setRating : ratingField.text];
    [wio setStrength : strengthField.text];
    NSLog(@"UUID FIELD: %@", uuidField);
    if(uuidField == nil){
        [wio setUuid : [[CoreDataManager sharedManager] uuid]];
    }else{
        [wio setUuid : uuidField];
        
       }
    NSLog(@"FIRST WIO: %@", wio);
    NSLog(@"FIRST NAME: %@", [wio name]);
    NSLog(@"FRST UUID: %@", [wio uuid]);    
    [[CoreDataManager sharedManager] addOrUpdateWhisky:wio];
    itemWhisky = [[CoreDataManager sharedManager] getLastWhisky];
    
    NSLog(@"%@", itemWhisky);
    NSLog(@"%@", [itemWhisky uuid]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadRootTable" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickedCancelButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem; 
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
//        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self isPadCheck];
    noseField = (isPad) ? [[UITextView alloc] initWithFrame:CGRectMake(303, 270, 395, 96)]
                        : [[UITextView alloc] initWithFrame:CGRectMake(88, 145, 220, 46)] ;
    UITextField* roundRect = (isPad) ? [[UITextField alloc] initWithFrame:CGRectMake(300, 267, 400, 100)]
                                    :   [[UITextField alloc] initWithFrame:CGRectMake(85, 142, 225, 50)];
    [roundRect setBorderStyle:UITextBorderStyleRoundedRect];
    roundRect.enabled = NO;
    [self.view addSubview:roundRect];
    [self.view addSubview:noseField];
    
    finishField = (isPad)   ? [[UITextView alloc] initWithFrame:CGRectMake(303, 375, 395, 96)]
                            : [[UITextView alloc] initWithFrame:CGRectMake(88, 210, 220, 46)];
    roundRect = (isPad) ? [[UITextField alloc] initWithFrame:CGRectMake(300, 372, 400, 100)]
                        : [[UITextField alloc] initWithFrame:CGRectMake(85, 207, 225, 50)];
    [roundRect setBorderStyle:UITextBorderStyleRoundedRect];
    roundRect.enabled = NO;
    [self.view addSubview:roundRect];
    [self.view addSubview:finishField];
    
    overallField = (isPad) ? [[UITextView alloc] initWithFrame:CGRectMake(303, 485, 395, 96)]
                           : [[UITextView alloc] initWithFrame:CGRectMake(88, 270, 220, 46)];
    roundRect = (isPad) ? [[UITextField alloc] initWithFrame:CGRectMake(300, 482, 400, 100)]
                        : [[UITextField alloc] initWithFrame:CGRectMake(85, 267, 225, 50)];
    [roundRect setBorderStyle:UITextBorderStyleRoundedRect];
    roundRect.enabled = NO;
    [self.view addSubview:roundRect];
    [self.view addSubview:overallField];
    
    uuidField = [[NSString alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[defaults objectForKey:@"editEntry"] isEqualToString:@""]){
        NSLog(@"UUID IN ADD ENTRY: %@",[defaults objectForKey:@"editEntry"]);
        wio =[[CoreDataManager sharedManager] getWhiskyById:[defaults objectForKey:@"editEntry"]];
        
        nameField.text = [wio name];
        brandField.text = [wio brand];
        ageField.text = [wio age_statement];
        strengthField.text = [wio strength];
        noseField.text = [wio nose];
        finishField.text = [wio finish];
        overallField.text = [wio overall];
        ratingField.text = [wio rating];
        uuidField = [wio uuid];
        [defaults setValue:@"" forKey:@"editEntry"];
    }else{
        uuidField = nil;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(BOOL)isPadCheck
{
    NSRange range = [[[UIDevice currentDevice] model] rangeOfString:@"iPad"];
    if(range.location==NSNotFound)
    {
        isPad=NO;
        
        
    }
    else {
        isPad=YES;
    }
    NSLog(@"IPAD VALUE %i", isPad);
    return isPad;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
