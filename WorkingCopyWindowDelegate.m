//
//  WindowDelegate.m
//  Diffly
//
//  Created by Matt Mower on 03/02/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "WorkingCopyWindowDelegate.h"

#import "WorkingCopyDocument.h"

@implementation WorkingCopyWindowDelegate

- (void)windowDidBecomeMain:(NSNotification *)aNotification
{
	[[self document] synchFilterMenu];
}

- (BOOL)windowShouldClose:(id)__sender
{
	return YES;
}

@end
