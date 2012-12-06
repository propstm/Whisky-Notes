//
//  CustomCellBackground.m
//  CoolTable
//
//  Created by Ray Wenderlich on 9/29/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "CustomCellBackground.h"
#import "Common.h"

@implementation CustomCellBackground


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor *whiteUIColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]; 
    UIColor *lightUIGrayColor = [UIColor colorWithRed:245.0/255.0 green:222.0/255.0 blue:179.0/255.0 alpha:1.0];
    UIColor *wheatUIColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    UIColor *separatorUIColor = [UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1.0];
    
    CGColorRef whiteColor = whiteUIColor.CGColor;
    CGColorRef lightGrayColor = lightUIGrayColor.CGColor;
    CGColorRef wheatColor = wheatUIColor.CGColor;
    CGColorRef separatorColor = separatorUIColor.CGColor;
    
    CGRect paperRect = self.bounds;

    // Fill with gradient
    drawLinearGradient(context, paperRect, lightGrayColor, wheatColor);
    
    // Add white 1 px stroke
    CGRect strokeRect = paperRect;
    strokeRect.size.height -= 1;
    strokeRect = rectFor1PxStroke(strokeRect);

    CGContextSetStrokeColorWithColor(context, whiteColor);
    CGContextSetLineWidth(context, 1.0);
    NSLog(@"CONTEXT: %@", context);
    NSLog(@"STROKE REF: %f %f %f %f", strokeRect.origin.x, strokeRect.origin.y, strokeRect.size.width, strokeRect.size.height);
    CGContextStrokeRect(context, strokeRect);
    
    // Add separator
    CGPoint startPoint = CGPointMake(paperRect.origin.x, paperRect.origin.y + paperRect.size.height - 1);
    CGPoint endPoint = CGPointMake(paperRect.origin.x + paperRect.size.width - 1, paperRect.origin.y + paperRect.size.height - 1);
    draw1PxStroke(context, startPoint, endPoint, separatorColor); 
    
}



@end
