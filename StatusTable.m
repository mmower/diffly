//
//  StatusTable.m
//  Diffly
//
//  Created by Matt Mower on 09/04/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "StatusTable.h"
#import "StatusTableDelegate.h"

@implementation StatusTable

- (unichar)keyFromEvent:(NSEvent *)__event
{
	if( [[__event characters] length] < 1 ) {
		return 0;
	} else {
		return [[__event characters] characterAtIndex:0];
	}
}

- (void)keyDown:(NSEvent *)__event
{
	switch( [self keyFromEvent:__event] ) {
		case 'n':
		case 0x2A:
			[self selectNextRow];
			break;
			
		case ' ':
		case 0x2B: // +
			[self checkSelected];
			break;
			
		case 'd':
		case 0x2D: // -
			[self uncheckSelected];
			break;
			
		case 't':
		case 0x03: // ENTER
			[self toggleSelected];
			break;
			
		default:
			//NSLog( @"%02x", [self keyFromEvent:__event] );
			[super keyDown:__event];
	}
}

- (NSMenu *)menuForEvent:(NSEvent *)__event
{
    NSPoint mousePoint = [self convertPoint:[__event locationInWindow] fromView:nil];
    int row = [self rowAtPoint:mousePoint];
    if (row >= 0)
    {
		[self selectRow:row byExtendingSelection:NO];
    }
    else
    {
		// you can disable this if you don't want clicking on an empty space to deselect all rows
		[self deselectAll:self];
    }
	
	// make sure you return something!
	return [super menuForEvent:__event];
}

#pragma mark -
#pragma mark Selection control

- (void)checkSelected
{
	NSIndexSet *indexes = [self selectedRowIndexes];
	
	int index = [indexes firstIndex];
	while( index != NSNotFound ) {
		[[self statusItemAtRow:index] setSelected:YES];
		index = [indexes indexGreaterThanIndex:index];
	}
	
	[self selectNextRow];
}

- (void)uncheckSelected
{
	NSIndexSet *indexes = [self selectedRowIndexes];
	
	int index = [indexes firstIndex];
	while( index != NSNotFound ) {
		[[self statusItemAtRow:index] setSelected:NO];
		index = [indexes indexGreaterThanIndex:index];
	}
	
	[self selectNextRow];
}

- (void)toggleSelected
{
	NSIndexSet *indexes = [self selectedRowIndexes];
	
	int index = [indexes firstIndex];
	while( index != NSNotFound ) {
		StatusItem *item = [self statusItemAtRow:index];
		[item setSelected:![item selected]];
		
		index = [indexes indexGreaterThanIndex:index];
	}
	
	[self selectNextRow];
}

#pragma mark -
#pragma mark Table manipulations

- (void)selectNextRow
{
	NSIndexSet *indexes = [self selectedRowIndexes];
	
	if( [indexes count] == 1 ) {
		[self selectRow:[indexes firstIndex]+1 byExtendingSelection:NO];
	}
}

#pragma mark -
#pragma mark Delegate communication

- (StatusItem *)statusItemAtRow:(int)__rowIndex
{
	if( [[self delegate] respondsToSelector:@selector(statusTable:itemAtRow:)] ) {
		return [[self delegate] statusTable:self itemAtRow:__rowIndex];
	} else {
		return nil;
	}
}


@end
