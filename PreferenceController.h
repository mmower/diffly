//
//  PreferenceController.h
//  Diffly
//
//  Created by Matt Mower on 04/01/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "DBPrefsWindowController.h"
#import "prefs.h"

#define STABLE_APPCAST_URL @"http://mattmower.com/diffly/appcast.xml"
#define BETA_APPCAST_URL @"http://mattmower.com/diffly/beta-appcast.xml"

@interface PreferenceController : DBPrefsWindowController {
	IBOutlet NSView			*generalPreferenceView;
	IBOutlet NSView			*subversionPreferenceView;
	IBOutlet NSView			*updatesPreferenceView;
	IBOutlet NSView			*advancedPreferenceView;
	
	IBOutlet NSTextField	*svnPathField;
	IBOutlet NSTextField	*stylesheetPathField;
	IBOutlet NSButton		*useTextMateCheckbox;
	IBOutlet NSButton		*openLastFoldersCheckbox;
	IBOutlet NSButton		*autoCommitParentFoldersCheckbox;
	IBOutlet NSButton		*updateTypeButton;
}

- (IBAction)browseSvnPath:(id)sender;
- (IBAction)browseStylesheetPath:(id)sender;
- (IBAction)changedUpdateType:(id)sender;

@end
