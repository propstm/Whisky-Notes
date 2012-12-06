//
//  MasterTableCell.h
//  Whisky Notes
//
//  Created by Matthew Propst on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterTableCell : UITableViewCell{
    UILabel *nameLbl;
    UILabel *companyLbl;
    UILabel *dateLbl;
    UILabel *ratingLbl;
    
}

@property (nonatomic) IBOutlet UILabel *ratingLbl;
@property (nonatomic) IBOutlet UILabel *companyLbl;
@property (nonatomic) IBOutlet UILabel *dateLbl;
@property (nonatomic) IBOutlet UILabel *nameLbl;

@end
