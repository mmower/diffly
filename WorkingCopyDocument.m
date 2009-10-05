//
//  MyDocument.m
//  Diffly
//
//  Created by Matt Mower on 30/12/2006.
//  Copyright Matt Mower 2006 . All rights reserved.
//

#import "WorkingCopyDocument.h"
#import "PreferenceController.h"

#import "WorkingCopy.h"
#import "StatusItem.h"
#import "Tsai.h"

#import "NSFileManager+tempFileName.h"
#import "CommitTask.h"
#import "WorkingCopyDocument+ToolbarDelegate.h"


/*
 The WorkingCopyDocument owns and manages an instance of WorkingCopy
 that reflects the Subversion status of the files in a working copy
 folder through a set of StatusItem instances.
 
 The WorkingCopyDocument is the delegate of the WorkingCopy and receives
 callbacks via that mechanism. The WorkingCopyDocument retains its
 WorkingCopy.
*/

@implementation WorkingCopyDocument

- (id)init
{
	if( ( self = [super init]) != nil ) {
		validCommitMessage = NO;
		items = nil;
		workingCopy = nil;
		
		searchFilter = @"";
		showPaths = YES;
		showFolders = NO;
		showUnversioned = YES;
		showExternals = NO;
	}
	
	return self;
}

- (void)dealloc
{
	[docWindowDelegate release];
	[docWebViewDelegate release];
	[docFileTableDelegate release];
	[docSplitViewDelegate release];
	
	[cachedSelections release];
	[filterPredicate release];
	[searchFilter release];
	[items release];
	[workingCopy release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Document & window methods

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"WorkingCopyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)__windowController
{
    [super windowControllerDidLoadNib:__windowController];
	
//	NSString *configFileName = [[self fileName] stringByAppendingPathComponent:@".
	
//	NSBundle *svnBundle = [NSBundle bundleWithPath:[[self fileName] stringByAppendingPathComponent:@".svn"] ];
//	configuration = [NSMutableDictionary dictionaryWithDictionary:[svnBundle infoDictionary]];
//	NSLog( @"Configuration: %@", configuration );
	
    [self prepareUIComponents];	
	[self diff:self];
}

- (void)prepareUIComponents
{
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
	commitColumn = [[[fileTable tableColumns] objectAtIndex:[fileTable columnWithIdentifier:@"commit"]] retain];
	[self showCommitColumn:NO];
	[commitButton setEnabled:NO];
	
	docWindowDelegate = [[WorkingCopyWindowDelegate alloc] initWithDocument:self view:docWindow];
	docWebViewDelegate = [[WorkingCopyWebViewDelegate alloc] initWithDocument:self view:diffViewer];
	docFileTableDelegate = [[WorkingCopyFileTableDelegate alloc] initWithDocument:self view:fileTable];
	docSplitViewDelegate = [[WorkingCopySplitViewDelegate alloc] initWithDocument:self view:splitView];
	
	toolbar = [[NSToolbar alloc] initWithIdentifier:@"toolbar"];
    [toolbar setAllowsUserCustomization:YES];
    [toolbar setAutosavesConfiguration:YES];
    [toolbar setDelegate:self];
	
	[docWindow setToolbar:toolbar];
	
	[itemController setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"relativePath" ascending:YES]]];}

- (BOOL)readFromFileWrapper:(NSFileWrapper *)fileWrapper ofType:(NSString *)typeName error:(NSError **)outError
{
	return YES;
}

- (void)close
{
	NSLog( @"Document %@ closing.", [self fileName] );
	[super close];
}

#pragma mark -
#pragma mark Accessors

- (WebView *)diffViewer
{
	return diffViewer;
}

- (StatusTable *)statusTable
{
	return fileTable;
}

- (NSArrayController *)itemController
{
	return itemController;
}

- (NSProgressIndicator *)progressIndicator
{
	return progressIndicator;
}

#pragma mark -
#pragma mark Status Item filtering

- (NSPredicate *)filterPredicate
{
	return filterPredicate;
}

- (void)setFilterPredicate:(NSPredicate *)__filterPredicate
{
	[self willChangeValueForKey:@"filterPredicate"];
	
	NSLog( @"New filter predicate is: %@", __filterPredicate );

	[filterPredicate release];
	filterPredicate = [__filterPredicate retain];
	
	[self didChangeValueForKey:@"filterPredicate"];
}

- (void)updateFilterPredicate
{
	//	NSLog( @"updateFilterPredicate" );
	NSMutableArray *predicates = [[[NSMutableArray alloc] init] autorelease];
	
	[predicates addObject:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"status != %u", svn_wc_status_none]]];
	
	if( ![searchFilter isEqualToString:@""] ) {
		[predicates addObject:[NSPredicate predicateWithFormat:@"%K CONTAINS[c] %@", @"relativePath", searchFilter]];
	}
	
	if( !showFolders )
	{
		[predicates addObject:[NSPredicate predicateWithFormat:@"directory != true"]];
	}
	
	if( !showUnversioned )
	{
		[predicates addObject:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"status != %u", svn_wc_status_unversioned]]];
	}
	
	if( !showExternals )
	{
		[predicates addObject:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"status != %u", svn_wc_status_external]]];
	}
	
	if( [predicates count] > 1 )
	{
		[self setFilterPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates]];
	}
	else if( [predicates count] > 0 )
	{
		[self setFilterPredicate:[predicates objectAtIndex:0]];
	}
	
	[statusMessages setStringValue:[NSString stringWithFormat:@"%d items visible.", [[itemController arrangedObjects] count]]];
}

#pragma mark -
#pragma mark Working copy management

- (NSArray *)items
{
	return items;
}

- (void)setItems:(NSArray *)__items
{
	[self willChangeValueForKey:@"items"];
	[items autorelease];
	items = [__items copy];
	[self didChangeValueForKey:@"items"];
}
	
- (void)updateItems
{
	[fileTable deselectAll:self];
	[self setItems:[[self workingCopy] items]];
	[itemController rearrangeObjects];
	[fileTable selectRow:0 byExtendingSelection:NO];
	[statusMessages setStringValue:[NSString stringWithFormat:@"%d items visible.", [[itemController arrangedObjects] count]]];
}

- (BOOL)canCommit
{
	return [[self markedItems] count] > 0;
}

- (WorkingCopy *)workingCopy
{
	if( workingCopy == nil ) {
		workingCopy = [[WorkingCopy alloc] initWithSubversion:[[NSUserDefaults standardUserDefaults] objectForKey:DifflySvnPathKey] 
												  workingCopy:[self fileName]];
		[workingCopy setDelegate:self];
	}
	
	return workingCopy;
}

- (NSArray*)markedItems
{
	return [items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == true"]];
}

- (NSArray *)unmarkedItems
{
	return [[[self workingCopy] items] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == false"]];
}

#pragma mark -
#pragma mark Commit files action

/*
 Look through the list of selected items and find those items for which there is
 a parent directory item that is not selected and add it to the list.
 */
- (NSArray *)filesForCommit
{
	NSMutableArray *commitTargets = [[NSMutableArray alloc] init];
	
	if( [[NSUserDefaults standardUserDefaults] objectForKey:DifflyAutoCommitParentFoldersKey] ) {
		foreach( item, [self markedItems] )
		{
			[commitTargets addObject:item];
			
			// Is there an unselected item which is a parent directory of this item?
			foreacht( StatusItem*, potential, [self unmarkedItems] )
			{
				if( [potential directory] && [potential requiresCommit] && [[item path] hasPrefix:[potential path]] )
				{
					[commitTargets addObject:potential];
				}
			}
		}
	}
	
	return commitTargets;
}

- (IBAction)commit:(id)sender
{
	if( ![self canCommit] )
	{
		[fileTable selectColumn:[fileTable columnWithIdentifier:@"commit"] byExtendingSelection:NO];
		NSBeep();
		return;
	}
	else
	{
		[self commitFiles:[self filesForCommit] withMessage:[commitMessage string]];
	}
}

- (IBAction)toggleCommit:(id)sender
{
	[drawer toggle:self];
	[self showCommitColumn:( [drawer state] == NSDrawerOpenState || [drawer state] == NSDrawerOpeningState )];
}

- (void)commitFiles:(NSArray*)files withMessage:(NSString*)message
{
	[NSApp beginSheet:commitWindow
	   modalForWindow:docWindow
		modalDelegate:self
	   didEndSelector:@selector(commitSheetEnded:returnCode:contextInfo:)
		  contextInfo:nil];
	
	[commitControlButton setTitle:@"Cancel"];
	[commitResults setString:@""];
	[commitProgress startAnimation:self];
	
	CommitTask *task = [[CommitTask alloc] initWithCurrentPath:[self fileName]
														 files:files
													   message:message];
	[task setDelegate:self];
	[task commit];
}

// The endCommitWindow: action is received after a commit has
// been completed and the user closes the commit window. The
// sheet used for commit progress is hidden and the working
// copy is automatically updated.

- (IBAction)endCommitWindow:(id)sender
{
	[commitWindow orderOut:sender];
	[NSApp endSheet:commitWindow returnCode:1];
	[commitResults setString:@""];
	[self diff:self];
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

// Sheet Delegate
- (void)commitSheetEnded:(NSWindow*)sheet returnCode:(int)code contextInfo:(void*)contentInfo
{
	[commitProgress stopAnimation:self];
}

#pragma mark -
#pragma mark Filering actions

- (IBAction)togglePaths:(id)__sender
{
	showPaths = !showPaths;
	
	NSTableColumn *fileColumn = [fileTable tableColumnWithIdentifier:@"filepath"];
	NSDictionary *bindingOptions = [[fileColumn infoForBinding:@"value"] objectForKey:@"NSOptions"];
	if( showPaths )
	{
		[fileColumn bind:@"value" toObject:itemController withKeyPath:@"arrangedObjects.relativePath" options:bindingOptions];
	}
	else
	{
		[fileColumn bind:@"value" toObject:itemController withKeyPath:@"arrangedObjects.fileName" options:bindingOptions];
	}
}

- (IBAction)toggleShowNone:(id)__sender
{
	showFolders = NO;
	showUnversioned = NO;
	showExternals = NO;
	[self updateFilterPredicate];	
	[self synchFilterMenu];
}

- (IBAction)toggleShowAll:(id)__sender
{
	showFolders = YES;
	showUnversioned = YES;
	showExternals = YES;
	[self updateFilterPredicate];
	[self synchFilterMenu];
}

- (IBAction)toggleShowFolders:(id)__sender
{
	showFolders = !showFolders;
	[self updateFilterPredicate];
	[self synchFilterMenu];
}

- (IBAction)toggleShowUnversioned:(id)__sender
{
	showUnversioned = !showUnversioned;
	[self updateFilterPredicate];	
	[self synchFilterMenu];
}

- (IBAction)toggleShowExternals:(id)__sender
{
	showExternals = !showExternals;
	[self updateFilterPredicate];	
	[self synchFilterMenu];
}

- (IBAction)filterFiles:(id)__sender
{
	[searchFilter release];
	searchFilter = [[__sender stringValue] copy];
	[self updateFilterPredicate];
}

- (IBAction)checkSelectedFiles:(id)sender
{
	[fileTable checkSelected];
}

- (IBAction)uncheckSelectedFiles:(id)sender
{
	[fileTable uncheckSelected];
}

#pragma mark -
#pragma mark Working copy actions

// The diff action triggers a call to svn to update the status
// of the items in the working copy. The Document is assumed to
// be the delegate of the WorkingCopy instance and receives a
// workingCopyUpdated: message when the svn processing has been
// completed

- (IBAction)diff:(id)sender
{
	if( ![self checkValidPreferences] )
	{
		return;
	}
	
	[self cacheSelections];
	
	[progressIndicator startAnimation:self];
	[[self workingCopy] update];
}

#pragma mark -
#pragma mark Check mark preservation

// Cache the current selections so we can restore them
// after the update (if applicable)
- (void)cacheSelections
{
	cachedSelections = [[NSMutableArray alloc] init];
	
	foreach( item, [self markedItems] )
	{
		[cachedSelections addObject:[item relativePath]];
	}
}

- (void)restoreSelections
{
	if( cachedSelections && !([cachedSelections count] == 0) )
	{
		foreach( item, items )
		{
			if( [cachedSelections containsObject:[item relativePath]] )
			{
				[item setSelected:YES];
			}
		}
	}
}

- (void)workingCopyUpdated:(WorkingCopy *)__workingCopy
{
	[self updateItems];
	[self restoreSelections];
	
	[self synchFilterMenu];
	
	[progressIndicator stopAnimation:self];
}

#pragma mark -
#pragma mark Item management

- (StatusItem *)selectedItem
{
	return [[itemController arrangedObjects] objectAtIndex:[fileTable selectedRow]];
}

#pragma mark -
#pragma mark File actions

- (IBAction)refreshFile:(id)sender
{
	[[self selectedItem] setDelegate:docFileTableDelegate];
	[[self selectedItem] updateDiff];
}

- (IBAction)mergeFile:(id)sender
{
	[[self selectedItem]  showInFileMerge];
}

- (IBAction)addFile:(id)sender
{
	StatusItem *item = [[itemController arrangedObjects] objectAtIndex:[fileTable selectedRow]];
	if( [item status] != svn_wc_status_unversioned ) {
		NSBeep();
		return;
	}
	
	[item setDelegate:docFileTableDelegate];
	[item addToRepository];
}

- (IBAction)removeFile:(id)sender
{
	if( [[self selectedItem] canRemove] ) {
		if( NSRunAlertPanel( @"Force Remove",
							 @"This action will remove the item from the repository and file system and cannot be undone.",
							 @"Proceed",
							 @"Cancel",
							 nil
							 ) == NSAlertDefaultReturn ) {
			[[self selectedItem] setDelegate:docFileTableDelegate];
			[[self selectedItem] subversionRemove];
		}
	} else {
		NSBeep();
	}
}

- (IBAction)renameFile:(id)sender
{
}

- (IBAction)revertFile:(id)sender
{
	if( [[self selectedItem] canRevert] ) {
		[[self selectedItem] setDelegate:docFileTableDelegate];
		[[self selectedItem] revertChanges];
	} else {
		NSBeep();
	}
}

#pragma mark -
#pragma mark Create patch action

// Export Diffs

- (IBAction)exportChanges:(id)sender
{
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	if( [savePanel runModalForDirectory:[workingCopy workingCopyPath] file:@"patch"] == NSOKButton )
	{
		[self createPatch:[savePanel filename] forFiles:[self markedItems]];
	}
}

- (void)createPatch:(NSString *)patchFile forFiles:(NSArray*)selectedFiles
{
	// Jimmy the Locale to be en_US for diffs otherwise we may end up parsing stuff like
	// "Arbeitskopie" coming from svn trying to do a de.de localization!
	NSMutableDictionary *environment = [NSMutableDictionary dictionaryWithDictionary:[[NSProcessInfo processInfo] environment]];
	[environment setObject:@"en_US.UTF-8" forKey:@"LC_ALL"];
	
	NSTask *task = [[[NSTask alloc] init] autorelease];
	[task setLaunchPath:[[NSBundle mainBundle] pathForResource:@"export" ofType:@"sh"]];
	NSLog( @"Launch: %@", [task launchPath] );
	
	[task setEnvironment:environment];
	[task setCurrentDirectoryPath:[workingCopy workingCopyPath]];
	
	NSMutableArray *args = [[[NSMutableArray alloc] init] autorelease];
	[args addObject:[[NSUserDefaults standardUserDefaults] objectForKey:DifflySvnPathKey]];
	[args addObject:patchFile];
	foreach( file, selectedFiles )
	{
		[args addObject:[file relativePath]];
	}
	[task setArguments:args];
	
	[task launch];
}


#pragma mark -
#pragma mark UI Support

// UI Activation

- (void)synchFilterMenu
{
	NSMenu *filterMenu = [[[NSApp menu] itemWithTitle:@"Filters"] submenu];
	[[filterMenu itemWithTitle:@"Folders"] setState:!showFolders];
	[[filterMenu itemWithTitle:@"Unversioned"] setState:!showUnversioned];
	[[filterMenu itemWithTitle:@"Externals"] setState:!showExternals];
}

- (BOOL)checkValidPreferences
{
	if( !checkForValidSubversion() )
	{
		[[NSAlert alertWithMessageText:@"Diffly has a problem"
						 defaultButton:nil
					   alternateButton:nil
						   otherButton:nil
			 informativeTextWithFormat:[NSString stringWithFormat:@"Diffly can't find your copy of svn (which it thinks it at %@) or, if it did, it couldn't run it. Please check your svn path preference.", [[NSUserDefaults standardUserDefaults] objectForKey:DifflySvnPathKey]]] runModal];
		return NO;
	}
	
	if( !checkForValidStylesheet() )
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

- (NSString*)getStylesheetURL
{
	NSString* stylesheetPath = [[NSUserDefaults standardUserDefaults] objectForKey:DifflyStylesheetPathKey];
	if( stylesheetPath == nil || [stylesheetPath isEqualToString:@""] )
	{
		stylesheetPath = [[NSBundle mainBundle] pathForResource:@"diffly" ofType:@"css"];
	}
	return stylesheetPath;
}

#pragma mark -
#pragma mark HTML message formatting

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

#pragma mark -
#pragma mark UI Manipulation

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

#pragma mark -
#pragma mark NSText delegate

- (void)textDidChange:(NSNotification *)aNotification
{
	[commitButton setEnabled:![[commitMessage string] isEqualToString:@""]];
}


@end
