//
//  WindowDelegate.m
//  Diffly
//
//  Created by Matt Mower on 03/02/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
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
