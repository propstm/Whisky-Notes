//
//  UILabel+VerticalAlign.m
//  JohnHancockETrunk
//
//  Created by Robert Brecher on 9/14/11.
//  Copyright 2011 Genuine Interactive. All rights reserved.
//

#import "UILabel+VerticalAlign.h"

@implementation UILabel (VerticalAlign)

- (void)resizeForTopAlign
{
	CGSize maximumSize = self.bounds.size;
    maximumSize.height = CGFLOAT_MAX;
	CGSize labelSize = [[self text] sizeWithFont:[self font] constrainedToSize:maximumSize lineBreakMode:[self lineBreakMode]];
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, labelSize.height)];
}

- (void)resizeForBottomAlign
{
	CGSize maximumSize = self.bounds.size;
	CGSize labelSize = [[self text] sizeWithFont:[self font] constrainedToSize:maximumSize lineBreakMode:[self lineBreakMode]];
	[self setFrame:CGRectMake(self.frame.origin.x, 
							  self.frame.origin.y + self.frame.size.height - labelSize.height, 
							  self.frame.size.width, 
							  labelSize.height)];
}

@end
