//
//  WorkingCopyController+Toolbar.m
//  Diffly
//
//  Created by Matt Mower on 29/01/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "WorkingCopyDocument+ToolbarDelegate.h"

@implementation WorkingCopyDocument (ToolbarDelegate)

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
	
	if( [itemIdentifier isEqualToString:@"Refresh"] )
	{
		[item setLabel:@"Refresh"];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"reload"]];
		[item setTarget:self];
		[item setAction:@selector(diff:)];
	} else if( [itemIdentifier isEqualToString:@"Edit"] ) {
		[item setLabel:@"Check In"];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"Drawer"]];
		[item setTarget:self];
		[item setAction:@selector(toggleCommit:)];
	} else if( [itemIdentifier isEqualToString:@"ShowFolders"] ) {
		[item setLabel:@"Paths"];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"Folder"]];
		[item setTarget:self];
		[item setAction:@selector(togglePaths:)];
	} else if( [itemIdentifier isEqualToString:@"Filter"] ) {
		[item setLabel:@"Filter"];
		[item setPaletteLabel:[item label]];
		[item setView:filterFieldView];
		[item setMinSize:NSMakeSize( 32.0, 32.0 )];
		[item setMaxSize:NSMakeSize( 196.0, 32.0 )];
	} else if( [itemIdentifier isEqualToString:@"Select"] ) {
		[item setLabel:@"Select"];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"Add"]];
		[item setTarget:self];
		[item setAction:@selector(checkSelectedFiles:)];
	} else if( [itemIdentifier isEqualToString:@"Deselect"] ) {
		[item setLabel:@"Deselect"];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"Remove"]];
		[item setTarget:self];
		[item setAction:@selector(uncheckSelectedFiles:)];
	} else if( [itemIdentifier isEqualToString:@"Add"] ) {
		[item setLabel:@"Add"];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"add_file_32"]];
		[item setTarget:self];
		[item setAction:@selector(addFile:)];
	} else if( [itemIdentifier isEqualToString:@"Remove"] ) {
		[item setLabel:@"Remove"];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"delete_file_32"]];
		[item setTarget:self];
		[item setAction:@selector(removeFile:)];
	} else if( [itemIdentifier isEqualToString:@"Revert"] ) {
		[item setLabel:@"Revert"];
		[item setPaletteLabel:[item label]];
		[item setImage:[NSImage imageNamed:@"rewind_32"]];
		[item setTarget:self];
		[item setAction:@selector(revertFile:)];
	}
	
    return [item autorelease];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    return [NSArray arrayWithObjects:NSToolbarSeparatorItemIdentifier,
		NSToolbarSpaceItemIdentifier,
		NSToolbarFlexibleSpaceItemIdentifier,
		NSToolbarCustomizeToolbarItemIdentifier,
		@"Refresh",
		@"Edit",
		@"ShowFolders",
		@"Filter",
		@"Select",
		@"Deselect",
		@"Add",
		@"Remove",
		@"Revert",
		nil];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return [NSArray arrayWithObjects:@"Refresh",
		@"Edit",
		@"ShowFolders",
		NSToolbarFlexibleSpaceItemIdentifier,
		@"Revert",
		@"Add",
		@"Remove",
		NSToolbarFlexibleSpaceItemIdentifier,
		@"Select",
		@"Deselect",
		@"Toogle",
		NSToolbarFlexibleSpaceItemIdentifier,
		@"Filter",
		NSToolbarFlexibleSpaceItemIdentifier,
		NSToolbarCustomizeToolbarItemIdentifier,
		nil];
}


@end
