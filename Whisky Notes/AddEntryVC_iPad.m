//
//  AddEntryVC_iPad.m
//  Whisky Notes
//
//  Created by Matthew Propst on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "AddEntryVC_iPad.h"
#import "UIPlaceHolderTextView.h"
#import "WhiskyItemObject.h"
#import "CoreDataManager.h"

@implementation AddEntryVC_iPad
@synthesize tableView;
@synthesize topTableView;
@synthesize cancelButton;
@synthesize saveButton;
@synthesize wio;
@synthesize uuidField;
@synthesize tname,tage,tstrength,tdistillery;
@synthesize tnose, tfinish, toverall, trating;
@synthesize imgView;
@synthesize imageBtn;
@synthesize myImg;
@synthesize popoverController;

@synthesize imagePickerController;
@synthesize imagePickerPopoverController;
@synthesize activityIndicator;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self isPadCheck];
    
    [super viewDidLoad];
    NSLog(@"keyboard visible default: %i", keyboardVisible);

    
    self.title = @"Add/Edit Entry";
    myImg = [UIImage imageNamed:@"madiera.jpg"];
    
    //imgView.contentMode = UIViewContentModeScaleAspectFill;
    // Do any additional setup after loading the view from its nib.
   // self.view.backgroundColor = self.view.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    NSLog(@"TABLEVIEW STYLE: %d", tableView.style);
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    
    
    //uuidField = [[NSString alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![[defaults objectForKey:@"editEntry"] isEqualToString:@""] && [defaults objectForKey:@"editEntry"] != NULL){
        if([defaults objectForKey:@"editEntry"]==nil){
            NSLog(@"equal to nil");
        }else {
            NSLog(@"not equal to nil");
        }
        NSLog(@"UUID IN ADD ENTRY: %@",[defaults objectForKey:@"editEntry"]);
        wio =[[CoreDataManager sharedManager] getWhiskyById:[defaults objectForKey:@"editEntry"]];
        
        [self setupWhiskyObject:wio];
        
        
        uuidField = [wio uuid];
        [defaults setValue:@"" forKey:@"editEntry"];
    }else{
        uuidField = nil;
    }

    //if(imgView.image
    //if([imgView.image.imageNamed:@"madiera.jpg" isEqualToString: @"madiera.jpg"]){

    if(imgView.image == [UIImage imageNamed:@"madiera.jpg"]){
        NSLog(@"image is madiera");
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"A Message To Display"
//                                                                 delegate:self
//                                                        cancelButtonTitle:@"Cancel"
//                                                   destructiveButtonTitle:nil
//                                                        otherButtonTitles:@"Test1",@"Test2",nil];
//        [actionSheet showInView:self.view];
//        [actionSheet autorelease];
    }
    //[self.imgView.image release];
    NSLog(@"ORIGINAL FRAME WIDTH: %f", tableView.frame.size.width);
    NSLog(@"ORIGINAL FRAME HEIGHT: %f", tableView.frame.size.height);
    
    tvFrame = tableView.frame;
}
- (void) viewWillAppear:(BOOL)animated 
{
    [activityIndicator setAlpha:1.0f];
	[super viewWillAppear:animated];
	NSLog(@"Registering for keyboard events");
    
	// Register for the events
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:)
												 name: UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:)
												 name: UIKeyboardDidHideNotification object:nil];
    
	//Initially the keyboard is hidden
	keyboardVisible = NO;	
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(void) keyboardDidShow: (NSNotification *)notif 
{
    NSLog(@"keyboard did show");
    
    // If keyboard is visible, return
    if (keyboardVisible) 
    {
        NSLog(@"Keyboard is already visible. Ignoring notification.");
        return;
    }
    
	// Get the size of the keyboard.
	NSDictionary* info = [notif userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
	keyboardSize = [aValue CGRectValue].size;
    
    // Save the current location so we can restore
    // when keyboard is dismissed
    
    offset = tableView.contentOffset;
    
    NSLog(@"TABLEVIEW HEIGHT: %f", tableView.frame.size.height);
    // Resize the scroll view to make room for the keyboard
    CGRect viewFrame = tableView.frame;
    viewFrame.size.height -= keyboardSize.height;
    viewFrame.size.height -=25;
    tableView.frame = viewFrame;
    
    NSLog(@"OFFSET TABLEVIEW HEIGHT: %f", tableView.frame.size.height);
    // Keyboard is now visible
    keyboardVisible = YES;
}
-(void) keyboardDidHide: (NSNotification *)notif 
{
    NSLog(@"KEYBOARD DID HIDE NOTIFICATION");
    // Is the keyboard already shown
    if (!keyboardVisible) 
    {
        NSLog(@"Keyboard is already hidden. Ignoring notification.");
        return;
    }
    if(isPad){
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
            tvFrame.size.width = 755;
        }else{
            tvFrame.size.width = 705;
        }
    }
    tableView.frame = tvFrame;
    
    //tableView.frame = CGRectMake(0, 0, 320, 460);
    
    
    // Reset the scrollview to previous location
    tableView.scrollEnabled = YES;
    tableView.contentOffset = offset;
    
    // Keyboard is no longer visible
    keyboardVisible = NO;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section{
    if(aTableView == tableView){
        return 4;
    }else{
        return 4;
    }
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(aTableView == topTableView){
        
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            // Add the text field or add the text view.
            // Set the tag value to some value like 1.
            
            UITextField *textField = [[UITextField alloc] init];
            [textField setTag:1];
            textField.delegate = self;
            CGRect frame = cell.frame;
            
            frame.origin.x = cell.frame.origin.x + 10;
            frame.origin.y = cell.frame.origin.y + 10;
            frame.size.width = 350;
            [textField setFrame:frame];
            if(aTableView == topTableView){
                [cell.contentView addSubview:textField];
                switch (indexPath.row) {
                    case 0:
                        textField.text = tname;
                        [textField setPlaceholder :@"Name"];
                        
                        break;
                    case 1:
                        
                        [textField setPlaceholder :@"Distillery"];
                        textField.text = tdistillery;
                        NSLog(@"DISTILLERY: %@", tdistillery);
                        
                        break;
                    case 2:
                        textField.text = tage;
                        [textField setPlaceholder :@"Age Statement"];
                        NSLog(@"AGE: %@", tage);
                        
                        break;
                    case 3:
                        textField.text = tstrength;
                        [textField setPlaceholder :@"Strength"];
                        
                        break;
                        
                    default:
                        break;
                }
                
            }
        }
        return cell;
    }else{
        
        static NSString *cellIdentifier = @"cellbottom";
        UITableViewCell *bottomCell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (bottomCell == nil) {
            bottomCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
            [bottomCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            CGRect frame = bottomCell.frame;
            if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
                frame.origin.x = bottomCell.frame.origin.x + 0;
                frame.origin.y = bottomCell.frame.origin.y + 5;
                frame.size.width = 680;
            }else{
                frame.origin.x = bottomCell.frame.origin.x + 0;
                frame.origin.y = bottomCell.frame.origin.y + 5;
                frame.size.width = 615;
            }
            if(indexPath.row == 3){
                frame.size.height = 44;
            }else{
                frame.size.height = 90;
            }
            UIPlaceHolderTextView *txtView = [[UIPlaceHolderTextView alloc] init];
            txtView.delegate = self;
            [txtView setFont:[UIFont systemFontOfSize:16.0f]];
            [txtView setFrame:frame];
            [txtView setBackgroundColor:[UIColor clearColor]];
            [bottomCell.contentView addSubview:txtView];
            switch (indexPath.row) {
                case 0:
                {
                    NSLog(@"INDEXPATH ROW: %i", indexPath.row);
                    txtView.text = tnose;
                    [txtView setPlaceholder :@"Nose"];
                    
                }
                    break;
                case 1:
                {
                    txtView.text = tfinish;
                    [txtView setPlaceholder :@"Finish"];
                    
                }
                    break;
                case 2:
                {
                    txtView.text = toverall;
                    [txtView setPlaceholder :@"Overall"];
                    
                }
                    break;
                case 3:
                {
                    txtView.text = trating;
                    [txtView setPlaceholder :@"Rating"];
                    
                }
                    break;
                default:
                    break;
                    
            }
        }
        return bottomCell;

    }
    return nil;
}

-(UIView *) tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section
{
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,500,400)];
        
        if (aTableView == tableView) {
            // create the parent view that will hold header Label
            
            // create the label objects
            if(topTableView == nil){
                topTableView = [[UITableView alloc] initWithFrame:CGRectMake(260, 10, 400, 200) style:UITableViewStyleGrouped];
                [topTableView setDelegate:self];
                [topTableView setDataSource:self];
                topTableView.backgroundView = nil;
                topTableView.backgroundColor = self.view.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
            }
            //topTableView.backgroundColor = [UIColor cyanColor];
            // create the imageView with the image in it
            if(imgView == nil){
                imgView = [[UIImageView alloc] initWithImage:myImg];
            }
                imgView.frame = CGRectMake(50,10,200,200);
                imgView.contentMode = UIViewContentModeScaleAspectFit;
            if(imageBtn == nil){
                imageBtn = [[UIButton alloc] init];
            }
                imageBtn.frame = imgView.frame;
                [imageBtn addTarget:self action:@selector(choosePhoto) forControlEvents:UIControlEventTouchUpInside];
                
                
                [imageBtn setAlpha:1.0f];
                [imageBtn setBackgroundColor:[UIColor clearColor]];
                [customView addSubview:imgView];
                [customView addSubview:imageBtn];
                [customView addSubview:topTableView];
            //        [customView addSubview:detailLabel];
            
                return customView;
            
        }
        return customView;
    
    
//    }else {
//        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,500,400)];
//        
//        if (aTableView == tableView) {
//            // create the parent view that will hold header Label
//            
//            // create the label objects
//            topTableView = [[UITableView alloc] initWithFrame:CGRectMake(130, 0, 190, 220) style:UITableViewStyleGrouped];
//            [topTableView setDelegate:self];
//            [topTableView setDataSource:self];
//            topTableView.backgroundView = nil;
//            topTableView.backgroundColor = self.view.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
//            
//            //topTableView.backgroundColor = [UIColor cyanColor];
//            // create the imageView with the image in it
//            imgView = [[UIImageView alloc] initWithImage:myImg];
//            imgView.frame = CGRectMake(10,20,120,120);
//            imageBtn = [[UIButton alloc] init];
//            imageBtn.frame = imgView.frame;
//            [imageBtn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
//            [imageBtn setAlpha:1.0f];
//            [imageBtn setBackgroundColor:[UIColor clearColor]];
//            [customView addSubview:imgView];
//            [customView addSubview:imageBtn];
//            [customView addSubview:topTableView];
//            //        [customView addSubview:detailLabel];
//            
//            return customView;
//            
//        }
//        return customView;
//    }

}


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(aTableView == tableView){
        if (indexPath.row <3) {
            return 110;
        }
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)aTableView viewForFooterInSection:(NSInteger)section
{
    
    UIView* customView;
    
    if (isPad) {
        if(aTableView == tableView){
            customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 70.0)];
            [customView addSubview:self.cancelButton];
            [customView addSubview:self.saveButton];
        }else{
            customView = nil;
            //            customView = [[UIView alloc] initWithFrame:CGRectMake(05.0, 05.0, 320.0, 70.0)];
            
        }
    }else{
        if(aTableView == tableView){
            customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 70.0)];
            [customView addSubview:self.cancelButton];
            [customView addSubview:self.saveButton];
        }else{
            customView = nil;
//            customView = [[UIView alloc] initWithFrame:CGRectMake(05.0, 05.0, 320.0, 70.0)];
            
        }
    }
    
    
    
    return customView;          
}

-(IBAction)resetAction:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Reset"
                                                 message:@"You just pressed the Reset button"
                                                delegate:self
                                       cancelButtonTitle:@"Acknowledged"
                                       otherButtonTitles:nil];
    [alert show];
    
}

- (UIButton *)cancelButton{
    if (cancelButton == nil)
    {
        
        cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        if(isPad){
            cancelButton.frame = CGRectMake(510.0, 5 , 110.0, 40.0);
        }else{
            cancelButton.frame = CGRectMake(175.0, 5 , 110.0, 40.0);
        }    
        [cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor clearColor];
        [cancelButton addTarget:self action:@selector(clickedCancelButton:) forControlEvents:UIControlEventTouchDown];
        
        cancelButton.tag = 1;    
    }
    return cancelButton;
}

- (UIButton *)saveButton{
    if (saveButton == nil)
    {
        
        saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        if(isPad){
            saveButton.frame = CGRectMake(110.0, 5 , 110.0, 40.0);
        }else{
            saveButton.frame = CGRectMake(35.0, 5 , 110.0, 40.0);
        }
        [saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
        saveButton.backgroundColor = [UIColor clearColor];
        [saveButton addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchDown];
        
        saveButton.tag = 0;    
    }
    return saveButton;
}



-(IBAction)clickedButton:(id)sender{
    [activityIndicator setAlpha:1.0f];
    UIView *blockerView = [[UIView alloc] initWithFrame:[self.view frame]];
    [blockerView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:blockerView];
    
    
    wio = [[WhiskyItemObject alloc] init];
    [wio setName : [(UIPlaceHolderTextView *)[[[[topTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]contentView]subviews]objectAtIndex:0]text]];
    [wio setTimeStamp:[[NSDate alloc] init]];
    [wio setCompany : [(UIPlaceHolderTextView *)[[[[topTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]contentView]subviews]objectAtIndex:0]text]];
    [wio setBrand : [(UIPlaceHolderTextView *)[[[[topTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]contentView]subviews]objectAtIndex:0]text]];
    [wio setAge_statement : [(UIPlaceHolderTextView *)[[[[topTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]contentView]subviews]objectAtIndex:0]text]];
    [wio setStrength : [(UIPlaceHolderTextView *)[[[[topTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]contentView]subviews]objectAtIndex:0]text]];

    [wio setNose : [(UIPlaceHolderTextView *)[[[[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]contentView]subviews]objectAtIndex:0]text]];
    [wio setFinish : [(UIPlaceHolderTextView *)[[[[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]contentView]subviews]objectAtIndex:0]text]];
    [wio setOverall : [(UIPlaceHolderTextView *)[[[[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]contentView]subviews]objectAtIndex:0]text]];
    [wio setRating : [(UIPlaceHolderTextView *)[[[[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]]contentView]subviews]objectAtIndex:0]text]];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(imgView.image)];

    [wio setPhoto:imageData];
   
    NSLog(@"UUID FIELD: %@", uuidField);
    if(uuidField == nil){
        NSLog(@"nil");
        [wio setUuid : [[CoreDataManager sharedManager] uuid]];
    }else{
        NSLog(@"not nil -- null i guess?");
        [wio setUuid : uuidField];
        
    }
    NSLog(@"FIRST WIO: %@", wio);
    NSLog(@"FIRST NAME: %@", [wio name]);
    NSLog(@"FRST UUID: %@", [wio uuid]);

    [[CoreDataManager sharedManager] addOrUpdateWhisky:wio];
    [activityIndicator setAlpha:1.0f];
    [self.view removeFromSuperview];
//    itemWhisky = [[CoreDataManager sharedManager] getLastWhisky];
//    
//    NSLog(@"%@", itemWhisky);
//    NSLog(@"%@", [itemWhisky uuid]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadRootTable" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickedCancelButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForFooterInSection:(NSInteger)section{
    if(aTableView == tableView){
        return 120;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForHeaderInSection:(NSInteger)section{
    if(aTableView == tableView){
        return 220;
    }
    return 0;
}

- (void)takePhoto
{
    tookImage = YES;
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//	imagePickerController.editing = YES;
//    imagePickerController.delegate = (id)self;
//    //[self popoverController:imagePickerController];
//    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)choosePhoto
{
    if(tookImage){
        tookImage = NO;
    }


    if(isPad){
        // Display assets from the photo library only.
        UIImagePickerController *imagePicker = [self imagePickerController];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        UIPopoverController *newPopoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
//        [newPopoverController presentPopoverFromBarButtonItem:[self addButton] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [newPopoverController presentPopoverFromRect:self.imgView.frame
                                              inView:self.view
                            permittedArrowDirections:UIPopoverArrowDirectionAny 
                                            animated:YES];

        [self setImagePickerPopoverController:newPopoverController];
//        [self setMasterPopoverController:newPopoverController];
//        [newPopoverController presentPopoverFromBarButtonItem:[self addButton] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        [self setImagePickerController:newPopoverController];
    }else{ 
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.editing = YES;
        ipc.delegate = (id)self;
        [self presentModalViewController:ipc animated:YES];

    }
}

- (void)setupWhiskyObject:(WhiskyItemObject *)passedWhiskyObj{
    if(tname == nil){
        tname = [[NSString alloc] initWithFormat:@"%@",[passedWhiskyObj name]];
    }else {
        tname = [passedWhiskyObj name];
    }
    
    if(tdistillery == nil){
        tdistillery = [[NSString alloc] initWithFormat:@"%@",[passedWhiskyObj company]];
    }else {
        tdistillery = [passedWhiskyObj company];
    }
    
    if(tage == nil){
        tage = [[NSString alloc] initWithFormat:@"%@",[passedWhiskyObj age_statement]];
    }else {
        tage = [passedWhiskyObj age_statement];
    }
    
    if(tstrength == nil){
        tstrength = [[NSString alloc] initWithFormat:@"%@",[passedWhiskyObj strength]];
    }else {
        tstrength = [passedWhiskyObj strength];
    }
    
    if(tnose == nil){
        tnose = [[NSString alloc] initWithFormat:@"%@",[passedWhiskyObj nose]];
    }else {
        tnose = [passedWhiskyObj nose];
    }
    
    if(toverall == nil){
        toverall = [[NSString alloc] initWithFormat:@"%@",[passedWhiskyObj overall]];
    }else {
        toverall = [passedWhiskyObj overall];
    }
    
    if(trating == nil){
        trating = [[NSString alloc] initWithFormat:@"%@",[passedWhiskyObj rating]];
    }else {
        trating = [passedWhiskyObj rating];
    }
    
    if(tfinish == nil){
        tfinish = [[NSString alloc] initWithFormat:@"%@",[passedWhiskyObj finish]];
    }else {
        tfinish = [passedWhiskyObj finish];
    }

    if([wio photo] != nil){
        myImg = [[UIImage alloc] initWithData: [wio photo]];
    }else{
        imgView.image = [UIImage imageNamed:@"madiera.jpg"];
    }
}

- (UIImagePickerController *)imagePickerController
{
    if (imagePickerController) {
        return imagePickerController;
    }
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    [self.imagePickerController setDelegate:self];
    
    return imagePickerController;
}

#pragma -
#pragma mark Imagepicker delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{
        
    if(tookImage){
        // Access the uncropped image from info dictionary
        //UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        tookImage = NO;
    }
    // Edited image works great (if you allowed editing)
    imgView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    // AND the original image works great
    imgView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // AND do whatever you want with it, (NSDictionary *)info is fine now
  myImg = [info objectForKey:UIImagePickerControllerEditedImage];
    //myImg = 
    [picker dismissModalViewControllerAnimated:NO];
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:NO];
}

-(IBAction)showActionSheet:(id)sender {
    NSLog(@"in showActionSheet");
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Take or Choose a Photo" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:@"Choose Photo" otherButtonTitles: nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        NSLog(@"one");
		[self choosePhoto];
	} else if (buttonIndex == 1) {
       // NSLog(@"two");
		//[self choosePhoto];
	}/*} else if (buttonIndex == 2) {
        NSLog(@"three");
		//self.label.text = @"Other Button 2 Clicked";
	} else if (buttonIndex == 3) {
        NSLog(@"four");
		//self.label.text = @"Cancel Button Clicked";
	}*/
    

}

#pragma mark - TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
	if ( [ text isEqualToString: @"\n" ] ) {
		[ textView resignFirstResponder ];
		return NO;
	}
	return YES;
}


@end
