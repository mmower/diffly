//
//  WorkingCopyDocumentFileTableDelegate.m
//  Diffly
//
//  Created by Matt Mower on 03/02/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "WorkingCopyFileTableDelegate.h"
#import "StatusItem.h"
#import "WorkingCopyDocument.h"
#import "Diff+HTMLFormatting.h"
#import "PreferenceController.h"

@implementation WorkingCopyFileTableDelegate

- (StatusItem *)statusTable:(StatusTable *)__table itemAtRow:(int)__row
{
	return [[[[self document] itemController] arrangedObjects] objectAtIndex:__row];
}

- (void)tableViewSelectionDidChange:(NSNotification*)notification
{
	int row = [[notification object] selectedRow];
	int numRows = [[[[self document] itemController] arrangedObjects] count];
	if( row < 0 || row > numRows )
	{
		// We always seem to get an invalid (-1) row number here after a refresh
		[self updateDiffView:@"<html><body></body></html>" halt:YES];
		return;
	}

	StatusItem *item = [[[[self document] itemController] arrangedObjects] objectAtIndex:row];
	NSLog( @"item-status=%u,%@", [item status], [item statusString] );
	
	if( [item directory] )
	{
		[self updateDiffView:@"<html><body><h3>This is a directory.</h3></body></html>" halt:YES];
	}
	else if( [item status] == svn_wc_status_none )
	{
		[self updateDiffView:@"<html><body><h3>This file has not been modified.</h3></body></html>" halt:YES];
	}
	else if( [item status] == svn_wc_status_unversioned )
	{
		[self updateDiffView:@"<html><body><h3>This file is unversioned.</h3></body></html>" halt:YES];
	}
	else if( [item status] == svn_wc_status_missing )
	{
		[self updateDiffView:@"<html><body><h3>This file is missing.</h3></body></html>" halt:YES];
	}
	else if( [item status] == svn_wc_status_deleted )
	{
		[self updateDiffView:@"<html><body><h3>This file was deleted.</h3></body></html>" halt:YES];
	}
	else if( [item status] == svn_wc_status_external )
	{
		[self updateDiffView:@"<html><body><h3>This file is external.</h3></body></html>" halt:YES];
	}
	else
	{
		[[document progressIndicator] startAnimation:self];
		[self updateDiffView:@"<html><body><h3>Waiting for Subversion...</h3></body></html>" halt:NO];
		[item retain];
		[item setDelegate:self];
		[item diff];
	}
}

- (void)updateDiffView:(NSString *)__html halt:(BOOL)__halt
{
	if( __html == nil )
	{
		NSLog( @"updateDiffView: was called without an html chunk" );
	}
	else
	{
		[[[[self document] diffViewer] mainFrame] loadHTMLString:__html baseURL:nil];
	}
	
	if( __halt )
	{
		[[document progressIndicator] stopAnimation:self];
	}
}

- (void)diffAvailable:(Diff *)__diff forItem:(StatusItem *)__item
{
	if( [[NSUserDefaults standardUserDefaults] boolForKey:DifflyUseTextMateKey] )
	{
		[self updateDiffView:[__diff formatAsLinkedHTMLUsingStyleSheet:[document getStylesheetURL] path:[document fileName]] halt:YES];
	}
	else
	{
		[self updateDiffView:[__diff formatAsHTMLPageWithStylesheet:[document getStylesheetURL]] halt:YES];
	}
}

- (void)refreshAll
{
	[[self document] diff:self];
}

- (void)refreshItem:(StatusItem *)__item
{
	NSLog( @"Item[%@,%u,%@] refresh", [__item relativePath], [__item status], [__item statusString] );
	StatusTable *statusTable = [[self document] statusTable];
	[statusTable reloadData];
	
	if( [__item status] != svn_wc_status_none )
	{
		[__item setDelegate:self];
		[__item updateDiff];
		[__item setDelegate:nil];
	}
	
	[[[self document] itemController] rearrangeObjects];
}

@end
