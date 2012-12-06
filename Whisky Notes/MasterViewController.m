//
//  MasterViewController.m
//  Whisky Notes
//
//  Created by Matthew Propst on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CoreDataManager.h"
#import "WhiskyItemObject.h"
#import "MasterTableCell.h"
#import "AddEntryViewController.h"
#import "CustomCellBackground.h"
#import "AddEntryVC_iPad.h"


//@interface MasterViewController ()
//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
//@end

@implementation MasterViewController
@synthesize detailViewController = _detailViewController;
@synthesize addEntryViewController = _addEntryViewController;
@synthesize nsma;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        }
    }
    return self;
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
    self.title = @"Reviews";
	// Do any additional setup after loading the view, typically from a nib.
    // Set up the edit and add buttons.
    NSRange rangeOfDash = [@"Thats Some Percentage Bullshit" rangeOfString:@"Percentage"];
    if(rangeOfDash.location != NSNotFound){
       NSLog(@"BINK!---");
    }else{
        NSLog(@"no bink");
    }
    [self isPadCheck];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
    nsma = [[CoreDataManager sharedManager] getAllWhiskies];
    if([nsma count] == 0){
        AddEntryVC_iPad *aevc = [[AddEntryVC_iPad alloc] initWithNibName:@"AddEntryVC_iPad" bundle:nil];
        if(isPad){
            [self.detailViewController.navigationController pushViewController:aevc animated:YES];
        }else{
            [self.navigationController pushViewController:aevc animated:YES];
        }
    }
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
    nsma = [[CoreDataManager sharedManager] getAllWhiskies];
    [self reloadRootTable];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRootTable) name:@"reloadRootTable" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadRootTable" object:nil];
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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //CODE AGAINST THIS
    return 1;
//    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Code against this
    nsma = [[CoreDataManager sharedManager] getAllWhiskies];
    return [nsma count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    nsma = [[CoreDataManager sharedManager] getAllWhiskies];
    static NSString *cellIdentifier = @"ProductsCategoryItemCell";
    MasterTableCell *cell = (MasterTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell = [[MasterTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MasterTableCell" owner:self options:nil];
        for (UIView *view in nibContents) {
            if ([view isMemberOfClass:[MasterTableCell class]]) {
                cell = (MasterTableCell *)view;
                break;
            }
        }
        //cell.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"masterBG.png"]]; 
        //cell.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        cell.backgroundView = [[CustomCellBackground alloc] init];
        cell.selectedBackgroundView = [[CustomCellBackground alloc] init];
        [[cell nameLbl]  setFont:[UIFont fontWithName:@"Futura" size:18.0f]];
        //[[cell nameLbl] setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:240.0f/255.0f alpha:1.0f]];
       [[cell nameLbl] setTextColor:[UIColor colorWithRed:58.0f/255.0f green:58.0f/255.0f blue:58.0f/255.0f alpha:1.0f]];
        [[cell ratingLbl] setTextColor:[UIColor colorWithRed:58.0f/255.0f green:58.0f/255.0f blue:58.0f/255.0f alpha:1.0f]];
        
    }

    WhiskyItemObject *wio = [nsma objectAtIndex:indexPath.row];
   // [self configureCell:cell atIndexPath:indexPath];
    [[cell nameLbl] setText:[wio name]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateStyle:NSDateFormatterShortStyle];
    
    [[cell ratingLbl] setText:[NSString stringWithFormat:@"%@ | %@ | %@", [wio company] , [dateFormat stringFromDate:[wio timeStamp]], [wio rating]]];
//    cell.backgroundView = nil;
//    [[cell contentView] setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:240.0f/255.0f alpha:1.0f]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    nsma = [[CoreDataManager sharedManager] getAllWhiskies];
    WhiskyItemObject *wio = [nsma objectAtIndex:indexPath.row];
    // [self configureCell:cell atIndexPath:indexPath];
    NSLog(@"WIO NAME: %@",[wio name]);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    if (!self.detailViewController) {
	        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone" bundle:nil];
	    }
        //NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
         WhiskyItemObject *wio = [nsma objectAtIndex:indexPath.row];
        NSLog(@"NAME: %@", [wio name]);
        NSLog(@"UUID: %@", [wio uuid]);
        NSLog(@"NAME: %@", [wio company]);
        NSLog(@"NAME: %@", [wio overall]);
        
        
        self.detailViewController.detailItem = wio;    
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        //Figure out coding that shit.
        WhiskyItemObject *wio = [nsma objectAtIndex:indexPath.row];
        NSLog(@"NAME: %@", [wio name]);
        NSLog(@"UUID: %@", [wio uuid]);
        NSLog(@"NAME: %@", [wio company]);
        NSLog(@"NAME: %@", [wio overall]);

        self.detailViewController.detailItem = wio;    
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    nsma = [[CoreDataManager sharedManager] getAllWhiskies];
    WhiskyItemObject *wio = [nsma objectAtIndex:indexPath.row];
    [[CoreDataManager sharedManager] removeWhiskyItem:[wio uuid]];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

-(void)insertNewObject
{
//    if (!self.addEntryViewController) {
    
//        self.addEntryViewController = [[[AddEntryViewController alloc] initWithNibName:@"AddEntryViewController_iPad" bundle:nil] autorelease];
    
    AddEntryVC_iPad *aevc = [[AddEntryVC_iPad alloc] initWithNibName:@"AddEntryVC_iPad" bundle:nil];
    if(isPad){
        [self.detailViewController.navigationController pushViewController:aevc animated:YES];
    }else{
        [self.navigationController pushViewController:aevc animated:YES];
    }
        
//    }
    
}

-(void)reloadRootTable{
    [self.tableView reloadData];
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

@end
