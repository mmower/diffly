//
//  WorkingCopyUIDelegate.m
//  Diffly
//
//  Created by Matt Mower on 03/02/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "WorkingCopyUIDelegate.h"

@implementation WorkingCopyUIDelegate

- (id)initWithDocument:(WorkingCopyDocument *)__document view:(id)__view
{
	if( ( self = [super init]) != nil )
	{
		[self setDocument:__document];
		[self setView:__view];
	}
	
	return self;
}

- (void) dealloc {
	[self setDocument:nil];
	[self setView:nil];
	
	[super dealloc];
}

- (WorkingCopyDocument *)document
{
	return document;
}

- (void)setDocument:(WorkingCopyDocument *)__document
{
	[document autorelease];
	document = [__document retain];
}

- (id)view
{
	return view;
}

- (void)setView:(id)__view
{
	[self setViewDelegate:nil];
	[view autorelease];
	
	if( __view != nil )
	{
		view = [__view retain];
		[self setViewDelegate:self];
	}
}

- (void)setViewDelegate:(id)__delegate
{
	[[self view] setDelegate:__delegate];
}

@end
