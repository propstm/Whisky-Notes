//
//  DetailViewController.h
//  Whisky Notes
//
//  Created by Matthew Propst on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>{
    UIScrollView *myScrollView;
    UILabel *distilleryLbl;
    UILabel *nameLbl;
    UILabel *ageLbl;
    UILabel *strengthLbl;
    
    UILabel *noseLbl;
    UILabel *tasteLbl;    
    UILabel *finishLbl;    
    UILabel *overallLbl;    
    UILabel *ratingLbl;
    
    UILabel *noseTitleLbl;
    UILabel *tasteTitleLbl;    
    UILabel *finishTitleLbl;    
    UILabel *overallTitleLbl;    
    UILabel *ratingTitleLbl;
    BOOL isPad;
    UIImageView *picHolder;
    UIImage *boozeImg;


}

@property (strong, nonatomic) id detailItem;
@property (nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *distilleryLbl;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *ageLbl;
@property (strong, nonatomic) IBOutlet UILabel *strengthLbl;

@property (strong, nonatomic) IBOutlet UILabel *noseLbl;
//@property (strong, nonatomic) IBOutlet UILabel *tasteLbl;    
@property (strong, nonatomic) IBOutlet UILabel *finishLbl;    
@property (strong, nonatomic) IBOutlet UILabel *overallLbl;    
@property (strong, nonatomic) IBOutlet UILabel *ratingLbl;

@property (strong, nonatomic) IBOutlet UILabel *noseTitleLbl;
//@property (strong, nonatomic) IBOutlet UILabel *tasteTitleLbl;    
@property (strong, nonatomic) IBOutlet UILabel *finishTitleLbl;    
@property (strong, nonatomic) IBOutlet UILabel *overallTitleLbl;    
@property (strong, nonatomic) IBOutlet UILabel *ratingTitleLbl;
@property (nonatomic) IBOutlet UIImageView *picHolder;
@property (nonatomic) UIImage *boozeImg;


-(BOOL)isPadCheck;

@end
