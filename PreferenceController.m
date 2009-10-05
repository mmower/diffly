//
//  PreferenceController.m
//  Diffly
//
//  Created by Matt Mower on 04/01/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import "PreferenceController.h"

NSString	*DifflySvnPathKey = @"SvnPath";
NSString	*DifflyStylesheetPathKey = @"StylesheetPath";
NSString	*DifflyUseTextMateKey = @"UseTextMate";
NSString	*DifflyOpenLastFoldersKey = @"OpenLastFolders";
NSString	*DifflyLastFolderListKey = @"LastFolderList";
NSString	*DifflyAutoCommitParentFoldersKey = @"AutoCommitParentFolders";

NSString	*DifflyUpdateTypeKey = @"UpdateType";
NSString	*DifflyUpdateFeedKey = @"SUFeedURL";

@implementation PreferenceController

- (void)setupToolbar
{
	[self addView:generalPreferenceView label:@"General"];
	[self addView:subversionPreferenceView label:@"Subversion"];
	[self addView:updatesPreferenceView label:@"Updates"];
	[self addView:advancedPreferenceView label:@"Advanced" image:[NSImage imageNamed:@"AdvancedPrefs"]];
	
	// Optional configuration settings.
	[self setCrossFade:[[NSUserDefaults standardUserDefaults] boolForKey:@"fade"]];
	[self setShiftSlowsAnimation:[[NSUserDefaults standardUserDefaults] boolForKey:@"shiftSlowsAnimation"]];
}

- (IBAction)browseSvnPath:(id)sender
{
	NSOpenPanel* browser = [NSOpenPanel openPanel];
	
	[browser setCanChooseFiles:YES];
	[browser setCanChooseDirectories:NO];
	[browser setAllowsMultipleSelection:NO];
	if( [browser runModal] != NSCancelButton )
	{
		[[NSUserDefaults standardUserDefaults] setObject:[[browser filenames] objectAtIndex:0] forKey:DifflySvnPathKey];
	}
}

- (IBAction)browseStylesheetPath:(id)sender
{
	NSOpenPanel* browser = [NSOpenPanel openPanel];
	
	[browser setCanChooseFiles:YES];
	[browser setCanChooseDirectories:NO];
	[browser setAllowsMultipleSelection:NO];
	if( [browser runModal] != NSCancelButton )
	{
		[[NSUserDefaults standardUserDefaults] setObject:[[browser filenames] objectAtIndex:0] forKey:DifflyStylesheetPathKey];
	}
}

- (IBAction)changedUpdateType:(id)sender
{
	if( [[updateTypeButton title] isEqualToString:@"Stable"] ) {
		[[NSUserDefaults standardUserDefaults] setObject:STABLE_APPCAST_URL
												  forKey:DifflyUpdateFeedKey];
	} else if( [[updateTypeButton title] isEqualToString:@"Beta"] ) {
		[[NSUserDefaults standardUserDefaults] setObject:BETA_APPCAST_URL
												  forKey:DifflyUpdateFeedKey];
	} else {
		NSLog( @"Oops, how did this happen... changed update feed type to %@", [updateTypeButton title] );
	}
}

@end
