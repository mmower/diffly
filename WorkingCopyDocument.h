//
//  MyDocument.h
//  Diffly
//
//  Created by Matt Mower on 30/12/2006.
//  Copyright Matt Mower 2006 . All rights reserved.
//


#import <Cocoa/Cocoa.h>

#import <WebKit/WebKit.h>
#import <RBSplitView/RBSplitView.h>

#import "WorkingCopy.h"

#import "StatusTable.h"

#import "WorkingCopyWindowDelegate.h"
#import "WorkingCopyWebViewDelegate.h"
#import "WorkingCopyFileTableDelegate.h"
#import "WorkingCopySplitViewDelegate.h"

@interface WorkingCopyDocument : NSDocument
{
	WorkingCopyWindowDelegate		*docWindowDelegate;
	WorkingCopyWebViewDelegate		*docWebViewDelegate;
	WorkingCopyFileTableDelegate	*docFileTableDelegate;
	WorkingCopySplitViewDelegate	*docSplitViewDelegate;
	
	// Used for the main window
	IBOutlet NSWindow				*docWindow;
	IBOutlet RBSplitView			*splitView;
	IBOutlet WebView				*diffViewer;
	IBOutlet NSProgressIndicator	*progressIndicator;
	
	IBOutlet StatusTable			*fileTable;
	IBOutlet NSArrayController		*itemController;
	IBOutlet NSPredicate			*filterPredicate;
	NSArray							*sortDescriptor;
	
	// Used to implement the drawer
	IBOutlet NSButton				*commitButton;
	IBOutlet NSTextView				*commitMessage;
	IBOutlet NSDrawer				*drawer;
	
	// Used to implement the toolbar
	IBOutlet NSToolbar				*toolbar;
	
	// Poor mans status bar
	IBOutlet NSTextField			*statusMessages;
	
	// Used to maintain the menu states
	IBOutlet NSMenu					*docMenu;
	
	// Used for the commit sheet
	IBOutlet NSWindow				*commitWindow;
	IBOutlet NSTextView				*commitResults;
	IBOutlet NSProgressIndicator	*commitProgress;
	IBOutlet NSButton				*commitControlButton;
	
	IBOutlet NSView					*filterFieldView;
	IBOutlet NSSearchField			*filterField;
	
	// Should this even be in the controller?
	BOOL							validCommitMessage;
	
	// Used for table column toggling
	NSTableColumn					*commitColumn;
	
	// UI state
	BOOL							showPaths;
	BOOL							showFolders;
	BOOL							showUnversioned;
	BOOL							showExternals;
	NSString						*searchFilter;
	
	// Subversion gathered info
	NSMutableArray					*items;
	NSMutableArray					*cachedSelections;
	WorkingCopy						*workingCopy;
	
	// Manage the Subversion folder
	NSMutableDictionary				*configuration;
}

// Working Copy Management

- (WorkingCopy *)workingCopy;
- (NSArray *)items;
- (void)setItems:(NSArray *)items;
- (void)updateFilterPredicate;
- (void)updateItems;

- (BOOL)canCommit;
- (NSArray*)markedItems;

- (void)prepareUIComponents;

- (void)workingCopyUpdated:(WorkingCopy *)workingCopy;

//- (void)sortItems:(NSArray*)sortDescriptors;

- (BOOL)readFromFileWrapper:(NSFileWrapper *)fileWrapper ofType:(NSString *)typeName error:(NSError **)outError;

// Main UI actions
- (IBAction)diff:(id)sender;
- (IBAction)commit:(id)sender;
- (IBAction)togglePaths:(id)sender;
- (IBAction)toggleCommit:(id)sender;
- (IBAction)endCommitWindow:(id)sender;
- (IBAction)refreshFile:(id)sender;
- (IBAction)mergeFile:(id)sender;
- (IBAction)addFile:(id)sender;
- (IBAction)removeFile:(id)sender;
- (IBAction)revertFile:(id)sender;
- (IBAction)filterFiles:(id)sender;
- (IBAction)checkSelectedFiles:(id)sender;
- (IBAction)uncheckSelectedFiles:(id)sender;

// Filter toggle actions
- (IBAction)toggleShowNone:(id)sender;
- (IBAction)toggleShowAll:(id)sender;
- (IBAction)toggleShowFolders:(id)sender;
- (IBAction)toggleShowUnversioned:(id)sender;
- (IBAction)toggleShowExternals:(id)sender;

// UI Control

- (WebView *)diffViewer;
- (StatusTable *)statusTable;
- (NSArrayController *)itemController;
- (NSProgressIndicator *)progressIndicator;
- (void)synchFilterMenu;
- (StatusItem *)selectedItem;

- (NSString*)getStylesheetURL;
- (NSString*)formatAsHTMLMessageWithTitle:(NSString*)title body:(NSString*)body;
- (NSString*)formatStringAsHTML:(NSString*)string;

- (BOOL)checkValidPreferences;

- (void)cacheSelections;
- (void)restoreSelections;

- (void)showCommitColumn:(int)show;
- (void)commitFiles:(NSArray*)files withMessage:(NSString*)message;

- (void)createPatch:(NSString *)patchFile forFiles:(NSArray*)selectedFiles;

- (void)commitSheetEnded:(NSWindow*)sheet returnCode:(int)code contextInfo:(void*)contentInfo;

@end
