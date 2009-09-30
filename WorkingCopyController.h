/* WorkingCopyController */

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <RBSplitView/RBSplitView.h>

#import "WorkingCopyDocument.h"

@interface WorkingCopyController : NSObject
{
	// Used for the main window
	IBOutlet WorkingCopyDocument* document;
	IBOutlet NSWindow* window;
	IBOutlet RBSplitView* splitView;
	IBOutlet NSTableView* fileTable;
	IBOutlet NSButton* diffButton;
	IBOutlet WebView* diffViewer;
	IBOutlet NSProgressIndicator* progressIndicator;

	// Used to implement the drawer
	IBOutlet NSButton* commitButton;
	IBOutlet NSTextView* commitMessage;
	IBOutlet NSDrawer* drawer;
	
	// Used to implement the toolbar
	IBOutlet NSToolbar* toolbar;
	
	// Used for the commit sheet
	IBOutlet NSWindow* commitWindow;
	IBOutlet NSTextView* commitResults;
	IBOutlet NSProgressIndicator* commitProgress;
	IBOutlet NSButton* commitControlButton;
	
	// Should this even be in the controller?
	BOOL validCommitMessage;
	
	// Used for ensuring tables sort by default
	NSArray* sortDescriptor;
	
	// Used for table column toggling
	NSTableColumn* commitColumn;
}

- (IBAction)diff:(id)sender;
- (IBAction)commit:(id)sender;
- (IBAction)toggleCommit:(id)sender;

- (IBAction)endCommitWindow:(id)sender;

- (void)setupToolbar;

// Delegate Methods

- (NSString*)getStylesheetURL;
- (NSString*)formatAsHTMLMessageWithTitle:(NSString*)title body:(NSString*)body;
- (NSString*)formatStringAsHTML:(NSString*)string;
- (NSString*)formatDiffAsHTML:(Diff*)diff;

- (BOOL)checkValidPreferences;
- (BOOL)checkForValidSubversion;
- (BOOL)checkForValidStylesheet;

- (void)showCommitColumn:(int)show;
- (void)commitFiles:(NSArray*)files withMessage:(NSString*)message;

- (void)commitSheetEnded:(NSWindow*)sheet returnCode:(int)code contextInfo:(void*)contentInfo;

@end
