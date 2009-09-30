//
//  StatusItem.h
//  SvnDiffParser
//
//  Created by Matt Mower on 15/01/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DiffParser.h"
#import "Diff.h"

#import "WorkingCopy.h"
#import "NSObject+SubversionTask.h"
#import "NSObject+StatusItem.h"

typedef enum svn_wc_status_kind
{
    /** does not exist */
    svn_wc_status_none = 1,
	
    /** is not a versioned thing in this wc */
    svn_wc_status_unversioned,
	
    /** exists, but uninteresting */
    svn_wc_status_normal,
	
    /** is scheduled for addition */
    svn_wc_status_added,
	
    /** under v.c., but is missing */
    svn_wc_status_missing,
	
    /** scheduled for deletion */
    svn_wc_status_deleted,
	
    /** was deleted and then re-added */
    svn_wc_status_replaced,
	
    /** text or props have been modified */
    svn_wc_status_modified,
	
    /** local mods received repos mods */
    svn_wc_status_merged,
	
    /** local mods received conflicting repos mods */
    svn_wc_status_conflicted,
	
    /** is unversioned but configured to be ignored */
    svn_wc_status_ignored,
	
    /** an unversioned resource is in the way of the versioned resource */
    svn_wc_status_obstructed,
	
    /** an unversioned path populated by an svn:externals property */
    svn_wc_status_external,
	
    /** a directory doesn't contain a complete entries list */
    svn_wc_status_incomplete
} WorkingCopyStatus;

@interface StatusItem : NSObject {
	WorkingCopy			*workingCopy;
	NSString			*fileName;
	NSString			*relativePath;
	NSString			*path;
	WorkingCopyStatus	status;
	Diff				*diff;
	BOOL				selected;
	
	id					delegate;
	NSMutableString		*diffOutput;
}

+ (WorkingCopyStatus)statusFromString:(NSString *)string;
+ (NSString *)stringFromStatus:(WorkingCopyStatus)status;
+ (NSString *)flagFromStatus:(WorkingCopyStatus)status;

- (id)initWithFile:(NSString *)file statusString:(NSString *)statusString workingCopy:(WorkingCopy *)workingCopy;
- (id)initWithFile:(NSString *)file status:(WorkingCopyStatus)status workingCopy:(WorkingCopy *)workingCopy;

- (id)delegate;
- (void)setDelegate:(id)delegate;

- (NSString *)fileName;
- (NSString *)path;
- (NSString *)relativePath;
- (BOOL)directory;

- (BOOL)selected;
- (void)setSelected:(BOOL)selected;

- (BOOL)requiresCommit;

- (WorkingCopyStatus)status;
- (void)setStatus:(WorkingCopyStatus)status;
- (NSString *)statusString;
- (NSString *)statusFlag;

- (BOOL)canAdd;
- (BOOL)canRemove;
- (BOOL)canRename;
- (BOOL)canRevert;

- (void)addToRepository;
- (void)subversionRemove;
- (void)revertChanges;
- (void)diff;
- (void)showInFileMerge;
- (void)updateDiff;
- (void)diffAvailable:(Diff *)diff;
- (void)updateStatus;
- (WorkingCopyStatus)parseStatusFromXML:(NSString *)xml;
- (void)backupChanges;

- (void)diffTaskComplete:(SubversionTask *)task;
- (void)addTaskComplete:(SubversionTask *)task;
- (void)removeTaskComplete:(SubversionTask *)task;
- (void)statusTaskComplete:(SubversionTask *)task;
- (void)revertTaskComplete:(SubversionTask *)task;

- (void)taskOutput:(NSString *)output fromTask:(SubversionTask *)task;
- (void)taskStarted:(SubversionTask *)task;
- (void)taskFinished:(SubversionTask *)task;

- (NSDictionary *)environmentWithLocale;

@end
