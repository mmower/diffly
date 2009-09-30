//
//  prefs.h
//  Diffly
//
//  Created by Matt Mower on 25/04/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString* DifflySvnPathKey;
extern NSString* DifflyStylesheetPathKey;
extern NSString* DifflyUseTextMateKey;
extern NSString* DifflyCheckUpdatesAtStartupKey;
extern NSString* DifflyOpenLastFoldersKey;
extern NSString* DifflyLastFolderListKey;
extern NSString* DifflyAutoCommitParentFoldersKey;
extern NSString* DifflyUpdateTypeKey;
extern NSString* DifflyUpdateFeedKey;

BOOL checkForValidSubversion();
BOOL checkForValidStylesheet();