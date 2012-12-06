//
//  DetailViewController.m
//  Whisky Notes
//
//  Created by Matthew Propst on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "WhiskyItemObject.h"
#import "UILabel+VerticalAlign.h"
#import "AddEntryViewController.h"
#import "AddEntryVC_iPad.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController
@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize myScrollView;
@synthesize distilleryLbl;
@synthesize nameLbl;
@synthesize ageLbl;
@synthesize strengthLbl;
@synthesize noseLbl, ratingLbl, overallLbl, finishLbl;
@synthesize noseTitleLbl, ratingTitleLbl, overallTitleLbl, finishTitleLbl;
@synthesize picHolder;
@synthesize boozeImg;





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
    
    //First Run - app load - grab first item from the whisky item array
    if (![self.detailItem isMemberOfClass:[Item class]]){
        NSMutableArray *nsma = [[CoreDataManager sharedManager] getAllWhiskies];
        if([nsma count] > 0){
            self.detailItem = [nsma objectAtIndex:0];            
        }
    }
    
    //Secondary run - grab correct item that's been passed
    if (self.detailItem) {
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(editObject)];
        self.navigationItem.rightBarButtonItem = editButton;
        //(WhiskyItemObject *)
        [self detailItem];
        self.view.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        
        //SET THE VALUES OF THE WHISKY OBJECT PASSED
        [self setTitle:[self.detailItem name]];
        [[self detailDescriptionLabel]  setFont:[UIFont fontWithName:@"Futura" size:(isPad) ? 32.0f : 20.0f]];
        [[self detailDescriptionLabel] setBackgroundColor: [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:240.0f/255.0f alpha:1.0f]];
        [[self detailDescriptionLabel] setTextColor:[UIColor colorWithRed:58.0f/255.0f green:58.0f/255.0f blue:58.0f/255.0f alpha:1.0f]];
        self.detailDescriptionLabel.text = [self.detailItem name];
        //RESIZE FOR TOP: 
        NSString *descriptionLbl = self.detailDescriptionLabel.text;
        CGFloat descWidth = [self.detailDescriptionLabel frame].size.width;
        CGSize constraint = CGSizeMake(descWidth, 500.0f);
        CGSize txtSize = [descriptionLbl sizeWithFont:[UIFont fontWithName:@"Futura" size:(isPad) ? 18.0f : 14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        CGRect frame = [self.detailDescriptionLabel frame];
        frame.size.height = txtSize.height;
        [self.detailDescriptionLabel setFrame:frame];
        [self.detailDescriptionLabel resizeForTopAlign];
        frame = self.detailDescriptionLabel.frame;
        frame.origin.y = (isPad)? 15 : 15;
        self.detailDescriptionLabel.frame = frame;
        
        
        self.distilleryLbl.text = [self.detailItem company];
        //RESIZE FOR TOP: 
        descriptionLbl = self.distilleryLbl.text;
        descWidth = [self.distilleryLbl frame].size.width;
        constraint = CGSizeMake(descWidth, 500.0f);
        txtSize = [descriptionLbl sizeWithFont:[UIFont fontWithName:@"Futura" size:(isPad) ? 18.0f : 14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        frame = [self.distilleryLbl frame];
        frame.size.height = txtSize.height;
        [self.distilleryLbl setFrame:frame];
        [self.distilleryLbl resizeForTopAlign];
        
        self.nameLbl.text = [self.detailItem name];
        self.ageLbl.text = [self.detailItem age_statement];
        self.strengthLbl.text = [NSString stringWithFormat:@"%@",[self.detailItem strength] ];
        UIImage *img = [[UIImage alloc] initWithData:[self.detailItem photo]]; 
        self.boozeImg = img; 
        //SET SIZE OF INTERESTING STUFF
        picHolder.contentMode = UIViewContentModeScaleAspectFit;
        
        
        self.noseLbl.text = [self.detailItem nose];
        //RESIZE FOR TOP & RESIZE FOR CONTENT: 
        descriptionLbl = self.noseLbl.text;
        descWidth = [self.noseLbl frame].size.width;
        constraint = CGSizeMake(descWidth, 500.0f);
        txtSize = [descriptionLbl sizeWithFont:[UIFont fontWithName:@"Futura" size:(isPad) ? 18.0f : 14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        frame = [self.noseLbl frame];
        if(!isPad){

            frame.origin.x = self.noseTitleLbl.frame.size.width - 55;
            frame.size.width = 240;
        }
        frame.size.height = txtSize.height;
        [self.noseLbl setFrame:frame];
        [self.noseLbl resizeForTopAlign];
        
        //SET TITLE
        frame = noseTitleLbl.frame;
        frame.origin.y = noseLbl.frame.origin.y;
        [noseTitleLbl setFrame:frame];
        
        //POSITION RELATIVE TO LAST ITEM;
        frame = [self.finishLbl frame];
        frame.origin.y = noseLbl.frame.origin.y + noseLbl.frame.size.height + 15;
        if(!isPad){
            
            frame.origin.x = self.finishTitleLbl.frame.size.width - 50;
            frame.size.width = 240;
            
            picHolder.image = boozeImg;
        }
        
        
        [self.finishLbl setFrame:frame];
        self.finishLbl.text = [self.detailItem finish];
        NSLog(@"NOSE: %@", [self.detailItem nose]);
        NSLog(@"FINISH: %@", [self.detailItem finish]);
        //self.finishLbl.text = @"FOOOOOOO";
        //RESIZE FOR TOP & RESIZE FOR CONTENT: 
        descriptionLbl = self.finishLbl.text;
        descWidth = [self.finishLbl frame].size.width;
        constraint = CGSizeMake(descWidth, 500.0f);
        txtSize = [descriptionLbl sizeWithFont:[UIFont fontWithName:@"Futura" size:(isPad) ? 18.0f : 14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        frame = [self.finishLbl frame];
        frame.size.height = txtSize.height;
        [self.finishLbl setFrame:frame];
        [self.finishLbl resizeForTopAlign];
        
        //SET TITLE
        frame = finishTitleLbl.frame;
        frame.origin.y = finishLbl.frame.origin.y;
        
        [finishTitleLbl setFrame:frame];

        
        //POSITION RELATIVE TO LAST ITEM;
        frame = [self.overallLbl frame];
        frame.origin.y = finishLbl.frame.origin.y + finishLbl.frame.size.height + 15;
        
        if(!isPad){
            
            frame.origin.x = self.finishTitleLbl.frame.size.width - 50;
            frame.size.width = 240;
            
        }
        [self.overallLbl setFrame:frame];
        
        self.overallLbl.text = [self.detailItem overall];
        //RESIZE FOR TOP & RESIZE FOR CONTENT: 
        descriptionLbl = self.overallLbl.text;
        descWidth = [self.overallLbl frame].size.width;
        constraint = CGSizeMake(descWidth, 500.0f);
        txtSize = [descriptionLbl sizeWithFont:[UIFont fontWithName:@"Futura" size:(isPad) ? 18.0f : 14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        frame = [self.overallLbl frame];
        frame.size.height = txtSize.height;
        [self.overallLbl setFrame:frame];
        [self.overallLbl resizeForTopAlign];
        //SET TITLE
        frame = overallTitleLbl.frame;
        frame.origin.y = overallLbl.frame.origin.y;
        
        [overallTitleLbl setFrame:frame];

        
        //POSITION RELATIVE TO LAST ITEM;
        frame = [self.ratingLbl frame];
        frame.origin.y = overallLbl.frame.origin.y + overallLbl.frame.size.height + 15;
        [self.ratingLbl setFrame:frame];
        if(!isPad){
            
            frame.origin.x = self.ratingLbl.frame.size.width - 50;
            frame.size.width = 240;
            
        }

        //self.tasteLbl.text = [self.detailItem taste];
        self.ratingLbl.text = [NSString stringWithFormat:@"%@", [self.detailItem rating]];
        //RESIZE FOR TOP & RESIZE FOR CONTENT: 
        descriptionLbl = self.ratingLbl.text;
        descWidth = [self.ratingLbl frame].size.width;
        constraint = CGSizeMake(descWidth, 500.0f);
        txtSize = [descriptionLbl sizeWithFont:[UIFont fontWithName:@"Futura" size:(isPad) ? 18.0f : 14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        frame = [self.ratingLbl frame];
        frame.size.height = txtSize.height;
        [self.ratingLbl setFrame:frame];
        [self.ratingLbl resizeForTopAlign];
        
        if(!isPad){
            frame = picHolder.frame;
            frame.origin.y = (ratingLbl.frame.origin.y + ratingLbl.frame.size.height + 30);
            picHolder.frame = frame;
            picHolder.image = boozeImg;
        }else{
            frame = picHolder.frame;
            frame.origin.y = (nameLbl.frame.origin.y-20);
            picHolder.frame = frame;
            picHolder.image = boozeImg;
            
        }
        
        //SET TITLE
        frame = ratingTitleLbl.frame;
        frame.origin.y = ratingLbl.frame.origin.y;
        [ratingTitleLbl setFrame:frame];

      //COMMENTED OUT -- When should this be released.  
      //  [self.detailItem release];
        
//        for (UILabel *label in [myScrollView subviews] ){
//            [label setTextColor:[UIColor colorWithRed:58.0f/255.0f green:58.0f/255.0f blue:58.0f/255.0f alpha:1.0f]];
//        }
        if(isPad){
            [myScrollView setContentSize: CGSizeMake(
                                                     self.myScrollView.frame.size.width, 
                                                     self.ratingLbl.frame.origin.y + self.ratingLbl.frame.size.height + 400
                                                     )];
        }else{
            [myScrollView setContentSize: CGSizeMake(
                                                     self.myScrollView.frame.size.width, 
                                                     self.picHolder.frame.origin.y + self.picHolder.frame.size.height + 100
                                                     )];
        }
       
        [myScrollView setFrame: CGRectMake(0,
                                           0, 
                                           self.myScrollView.frame.size.width, 
                                           self.myScrollView.frame.size.height
                                           )];
        myScrollView.scrollEnabled = YES;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self isPadCheck];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configureView];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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

- (void)editObject{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setValue:[self.detailItem uuid] forKey:@"editEntry"];
    NSLog(@"~~~UUID: %@ ~~", [self.detailItem uuid]);
   // AddEntryViewController *aevc = [[[AddEntryViewController alloc] initWithNibName:(isPad) ? @"AddEntryViewController_iPad" : @"AddEntryViewController_iPhone" bundle:nil] autorelease];
    AddEntryVC_iPad *aevc = [[AddEntryVC_iPad alloc] initWithNibName:@"AddEntryVC_iPad" bundle:nil];
    [self.navigationController pushViewController:aevc animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
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
