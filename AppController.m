//
//  AppController.m
//  Diffly
//
//  Created by Matt Mower on 04/01/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Tsai.h"

#import "AppController.h"

#import "PreferenceController.h"

@implementation AppController

+ (void)initialize
{
	NSMutableDictionary* defaultValues = [NSMutableDictionary dictionary];
	[defaultValues setObject:@"/usr/local/bin/svn"
					  forKey:DifflySvnPathKey];
	[defaultValues setObject:@""
					  forKey:DifflyStylesheetPathKey];
	[defaultValues setObject:[NSNumber numberWithBool:NO]
					  forKey:DifflyUseTextMateKey];
	[defaultValues setObject:[NSNumber numberWithBool:NO]
					  forKey:DifflyOpenLastFoldersKey];
	[defaultValues setObject:[NSNumber numberWithBool:NO]
					  forKey:DifflyAutoCommitParentFoldersKey];
	[defaultValues setObject:@"Stable" 
					  forKey:DifflyUpdateTypeKey];
	[defaultValues setObject:STABLE_APPCAST_URL
					  forKey:DifflyUpdateFeedKey];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)awakeFromNib
{
	[[NSApplication sharedApplication] setDelegate:self];
}

- (IBAction)openWorkingCopy:(id)sender
{
	NSOpenPanel* browser = [NSOpenPanel openPanel];
	
	[browser setCanChooseFiles:NO];
	[browser setCanChooseDirectories:YES];
	[browser setPrompt:@"Choose working copy"];
	[browser setAllowsMultipleSelection:NO];
	if( [browser runModal] != NSCancelButton )
	{
		[self openWorkingCopyDocument:[[browser filenames] objectAtIndex:0]];
	}
}

- (IBAction)showPreferencePanel:(id)sender
{
	[[PreferenceController sharedPrefsWindowController] showWindow:nil];
}

- (void)dealloc
{
	[preferenceController release];
	[super dealloc];
}

- (id)openWorkingCopyDocument:(NSString*)docFolder
{
	NSError* error;
	NSURL *url = [NSURL fileURLWithPath:docFolder];
	id obj = [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:url display:YES error:&error];
	if( obj == nil )
	{
		NSLog( @"Cannot open %@ : %@", docFolder, [error localizedDescription] );
	}
	return obj;
}

- (NSArray*)openFolderList
{
	NSArray* documents = [[NSDocumentController sharedDocumentController] documents];
	NSMutableArray* folders = [[[NSMutableArray alloc] initWithCapacity:[documents count]] autorelease];
	
	foreach( document, documents )
	{
		[folders addObject:[document fileName]];
	}
	
	return folders;
}

// Application delegate methods

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
	return [self openWorkingCopyDocument:filename] != nil ? YES : NO;
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
	if( !checkForValidSubversion() )
	{
		[[NSAlert alertWithMessageText:@"Diffly has a problem"
						 defaultButton:nil
					   alternateButton:nil
						   otherButton:nil
			 informativeTextWithFormat:[NSString stringWithFormat:@"Diffly can't find your copy of svn or, if it did, it couldn't run it. Please check your svn path preference.", [[NSUserDefaults standardUserDefaults] objectForKey:DifflySvnPathKey]]] runModal];
		[self showPreferencePanel:self];
	}
	else if( [[NSUserDefaults standardUserDefaults] boolForKey:DifflyOpenLastFoldersKey] )
	{
		NSArray* folders = [[NSUserDefaults standardUserDefaults] objectForKey:DifflyLastFolderListKey];
		if( folders != nil )
		{
			foreach( folder, folders )
			{
				NSLog( @"Opening previous folder %@", folder );
				[self openWorkingCopyDocument:folder];
			}
		} else {
			NSLog( @"No folders to open from the last session." );
		}
	} else {
		NSLog( @"No preference key: %@", [[NSUserDefaults standardUserDefaults] boolForKey:DifflyOpenLastFoldersKey] );
	}
	
	return NO;
}

// When the application terminates, if we're to open our documents next time, we need
// to save a list of the open documents now!
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
	if( [[NSUserDefaults standardUserDefaults] boolForKey:DifflyOpenLastFoldersKey] )
	{
		[[NSUserDefaults standardUserDefaults] setObject:[self openFolderList] forKey:DifflyLastFolderListKey];
	}
	else
	{
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:DifflyLastFolderListKey];
	}
	
	return NSTerminateNow;
}

@end
