//
//  UIPlaceHolderTextView.h
//  Whisky Notes
//
//  Created by Matthew Propst on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIPlaceHolderTextView : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic) UILabel *placeHolderLabel;
@property (nonatomic) NSString *placeholder;
@property (nonatomic) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
