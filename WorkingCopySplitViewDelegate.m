//
//  WorkingCopySplitViewDelegate.m
//  Diffly
//
//  Created by Matt Mower on 03/02/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "WorkingCopySplitViewDelegate.h"

@implementation WorkingCopySplitViewDelegate

- (void)splitView:(RBSplitView*)sender wasResizedFrom:(float)oldDimension to:(float)newDimension
{
	float delta = newDimension - oldDimension;
	
	[[sender subviewAtPosition:0] changeDimensionBy:(delta * 0.15) mayCollapse:NO move:NO];
	[[sender subviewAtPosition:1] changeDimensionBy:(delta * 0.85) mayCollapse:NO move:NO];
	
	[sender adjustSubviews];
}

@end
