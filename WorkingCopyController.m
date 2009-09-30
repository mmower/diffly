#import <Cocoa/Cocoa.h>
#import <SvnDiffParser/DiffParser.h>
#import <SvnDiffParser/StatusItem.h>
#import <SvnDiffParser/Diff.h>
#import <SvnDiffParser/Tsai.h>
#import <RBSplitView/RBSplitView.h>

#import "WorkingCopyController.h"
#import "PreferenceController.h"
#import "NSFileManager+tempFileName.h"
#import "CommitTask.h"
#import "WorkingCopyController+ToolbarDelegate.h"

@implementation WorkingCopyController

- (id)init
{
	if ((self = [super init]) != nil) {
		validCommitMessage = NO;
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)awakeFromNib
{
	// Setup the table
	commitColumn = [[[fileTable tableColumns] objectAtIndex:[fileTable columnWithIdentifier:@"commit"]] retain];
	[self showCommitColumn:NO];
	[self diff:self];
	[commitButton setEnabled:NO];
	[self setupToolbar];
	
//	[[[diffViewer mainFrame] frameView] setAllowsScrolling:YES];
}

- (void)setupToolbar
{
    toolbar = [[NSToolbar alloc] initWithIdentifier:@"toolbar"];
    [toolbar setAllowsUserCustomization:YES];
    [toolbar setAutosavesConfiguration:YES];
    [toolbar setDelegate:self];
	
	[window setToolbar:toolbar];
}

- (IBAction)commit:(id)sender
{
	if( ![document canCommit] )
	{
		[fileTable selectColumn:[fileTable columnWithIdentifier:@"commit"] byExtendingSelection:NO];
		NSBeep();
		return;
	}
	else
	{
		[self commitFiles:[document selectedItems] withMessage:[commitMessage string]];
	}
}

- (IBAction)toggleCommit:(id)sender
{
	[drawer toggle:self];
	[self showCommitColumn:[sender state]];
}

- (IBAction)diff:(id)sender
{
	[progressIndicator startAnimation:self];
	
	if( ![self checkValidPreferences] )
	{
		[progressIndicator stopAnimation:self];
		return;
	}
	
	[fileTable deselectAll:self];
	
	[document update];

	[fileTable deselectAll:self];
	[fileTable selectRow:0 byExtendingSelection:NO];
	[progressIndicator stopAnimation:self];
}

- (IBAction)endCommitWindow:(id)sender
{
	[commitWindow orderOut:sender];
	[NSApp endSheet:commitWindow returnCode:1];
	[self diff:self];
}

- (BOOL)checkValidPreferences
{
	if( ![self checkForValidSubversion] )
	{
		[[NSAlert alertWithMessageText:@"Diffly has a problem"
						 defaultButton:nil
					   alternateButton:nil
						   otherButton:nil
			 informativeTextWithFormat:[NSString stringWithFormat:@"Diffly can't find your copy of svn (which it thinks it at %@) or, if it did, it couldn't run it. Please check your svn path preference.", [[NSUserDefaults standardUserDefaults] objectForKey:DifflySvnPathKey]]] runModal];
		return NO;
	}
	
	if( ![self checkForValidStylesheet] )
	{
		[[NSAlert alertWithMessageText:@"Diffly has a problem"
						 defaultButton:nil
					   alternateButton:nil
						   otherButton:nil
			 informativeTextWithFormat:@"Diffly can't find your custom CSS stylesheet or, if it did, it couldn't read it. Please check your style path preference."] runModal];
		return NO;
	}
	
	return YES;
}

- (BOOL)checkForValidSubversion
{
	NSString* svnPath = [[NSUserDefaults standardUserDefaults] objectForKey:DifflySvnPathKey];
	NSLog( @"SVN PATH = [%@]", svnPath );
	NSLog( @"READABLE = [%@]", [[NSFileManager defaultManager] isReadableFileAtPath:svnPath] ? @"YES" : @"NO" );
	NSLog( @"EXECABLE = [%@]", [[NSFileManager defaultManager] isExecutableFileAtPath:svnPath] ? @"YES" : @"NO" );
	return [[NSFileManager defaultManager] isExecutableFileAtPath:[[NSUserDefaults standardUserDefaults] objectForKey:DifflySvnPathKey]];
}

- (BOOL)checkForValidStylesheet
{
	NSString* stylesheetPath = [[NSUserDefaults standardUserDefaults] objectForKey:DifflyStylesheetPathKey];
	if( stylesheetPath != nil && ![stylesheetPath isEqualToString:@""] )
	{
		return [[NSFileManager defaultManager] isExecutableFileAtPath:stylesheetPath];
	}
	else
	{
		return YES;
	}
}

- (NSString*)getStylesheetURL
{
	NSString* stylesheetPath = [[NSUserDefaults standardUserDefaults] objectForKey:DifflyStylesheetPathKey];
	if( stylesheetPath == nil || [stylesheetPath isEqualToString:@""] )
	{
		stylesheetPath = [[NSBundle mainBundle] pathForResource:@"diffly" ofType:@"css"];
	}
	return stylesheetPath;
}

// To support table sorting

//- (NSArray *)sortDescriptor
//{
//	if(sortDescriptor == nil)
//	{
//		sortDescriptor = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"file" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
//	}
//	
//	return sortDescriptor;
//}
//
//- (void)setSortDescriptor:(NSArray *)newSortDescriptor
//{
//	if( sortDescriptor == newSortDescriptor )
//	{
//		return;
//	}
//	
//	[sortDescriptor autorelease];
//	sortDescriptor = [newSortDescriptor retain];
//}

// HTML formatting (should this live somewhere else?)

- (NSString*)formatDiffAsHTML:(Diff*)diff
{
	if( [[NSUserDefaults standardUserDefaults] boolForKey:DifflyUseTextMateKey] )
	{
		return [NSString stringWithFormat:@"<html><head><link rel='stylesheet' media='screen' type='text/css' href='file://%@'/></head><body>%@</body></html>",
			[self getStylesheetURL],
			[diff toHTMLwithUrlBase:@"txmt://open?url=file://" path:[document fileName]]];
	}
	else
	{
		return [NSString stringWithFormat:@"<html><head><link rel='stylesheet' media='screen' type='text/css' href='file://%@'/></head><body>%@</body></html>",
							[self getStylesheetURL],
							[diff toHTML]];
	}
}

- (NSString*)formatAsHTMLMessageWithTitle:(NSString*)title body:(NSString*)body
{
	NSString* stylesheetPath = [[NSUserDefaults standardUserDefaults] objectForKey:DifflyStylesheetPathKey];
	if( stylesheetPath == nil )
	{
		stylesheetPath = [[NSBundle mainBundle] pathForResource:@"diffly" ofType:@"css"];
	}
	return [NSString stringWithFormat:@"<html><head><link rel='stylesheet' media='screen' type='text/css' href='file://%@'/></head><body><h3>%@</h3>%@</body></html>", [self getStylesheetURL], title, body];
}

- (NSString*)formatStringAsHTML:(NSString*)message
{
	NSString* stylesheetPath = [[NSUserDefaults standardUserDefaults] objectForKey:DifflyStylesheetPathKey];
	if( stylesheetPath == nil )
	{
		stylesheetPath = [[NSBundle mainBundle] pathForResource:@"diffly" ofType:@"css"];
	}
	return [NSString stringWithFormat:@"<html><head><link rel='stylesheet' media='screen' type='text/css' href='file://%@'/></head><body><h2>%@</h2></body></html>", [self getStylesheetURL], message];
}

// UI manipulation

- (void)showCommitColumn:(int)show
{
	if( show == NSOnState )
	{
		NSTableColumn* fileColumn = [[fileTable tableColumns] objectAtIndex:[fileTable columnWithIdentifier:@"filepath"]];
		
		[fileColumn setWidth:([fileColumn width] - [commitColumn width])];
		[fileTable addTableColumn:commitColumn];
	}
	else
	{
		NSTableColumn* fileColumn = [[fileTable tableColumns] objectAtIndex:[fileTable columnWithIdentifier:@"filepath"]];
		[fileTable removeTableColumn:commitColumn];
		[fileColumn setWidth:([fileColumn width] + [commitColumn width])];
	}
}

// SVN activity

- (void)commitFiles:(NSArray*)files withMessage:(NSString*)message
{
	[NSApp beginSheet:commitWindow
	   modalForWindow:window
		modalDelegate:self
	   didEndSelector:@selector(commitSheetEnded:returnCode:contextInfo:)
		  contextInfo:nil];
	
	[commitMessage setString:@""];
	[commitProgress startAnimation:self];
	
	CommitTask *task = [[CommitTask alloc] initWithCurrentPath:[document fileName]
														 files:files
													   message:message];
	[task setDelegate:self];
	[task commit];
}

// CommitTask Delegates

- (void)commitMessageArrived:(NSString*)message
{
	[commitResults setString:[[commitResults string] stringByAppendingString:message]];
}

- (void)commitHasCompleted
{
	[commitProgress stopAnimation:self];
	[commitControlButton setTitle:@"Close"];
}

// TableView Delegates

- (void)tableViewSelectionDidChange:(NSNotification*)notification
{
	int row = [fileTable selectedRow];
	
	NSError	*error = nil;
	
	StatusItem *item = [[document items] objectAtIndex:row];
	NSString* html = [self formatDiffAsHTML:[item diff:&error]];
	
	if( error != nil )
	{
		NSLog( @"Diff Parsing error: %@", [error localizedDescription] );
	}

	[html writeToFile:@"/tmp/diff.html" atomically:NO];
	
	[[diffViewer mainFrame] loadHTMLString:html baseURL:nil];
}

// WebView Delegates

- (NSArray*)webView:(WebView*)sender contextMenuItemsForElement:(NSDictionary*)element defaultMenuItems:(NSArray*)defaultMenuItems
{
	return nil;
}

// RBSplitView Delegates

- (void)splitView:(RBSplitView*)sender wasResizedFrom:(float)oldDimension to:(float)newDimension
{
	float delta = newDimension - oldDimension;
	
	[[sender subviewAtPosition:0] changeDimensionBy:(delta * 0.15) mayCollapse:NO move:NO];
	[[sender subviewAtPosition:1] changeDimensionBy:(delta * 0.85) mayCollapse:NO move:NO];
	
	[sender adjustSubviews];
}

// NSText Delegates

- (void)textDidChange:(NSNotification *)aNotification
{
	[commitButton setEnabled:![[commitMessage string] isEqualToString:@""]];
}

// Sheet Delegates

- (void)commitSheetEnded:(NSWindow*)sheet returnCode:(int)code contextInfo:(void*)contentInfo
{
	[commitProgress stopAnimation:self];
}

@end
