//
//  StatusItem.m
//  SvnDiffParser
//
//  Created by Matt Mower on 15/01/2007.
//  Copyright 2007 $MyCompanyName$. All rights reserved.
//

#import "StatusItem.h"

#import "prefs.h"
#import "SubversionTask.h"

NSDictionary	*statusMap;

/*
 * A StatusItem is responsible for a single file (or folder) in a working copy and has
 * operations to work on the file.
 *
 * It can "diff", "add", "show in filemerge", and "get status"
 */
@implementation StatusItem

#pragma mark -
#pragma mark Class initializers

+ (void)initialize
{
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
	
	[dict setObject:[NSNumber numberWithInt:svn_wc_status_none] forKey:@"none"];
	[dict setObject:[NSNumber numberWithInt:svn_wc_status_normal] forKey:@"normal"];
	[dict setObject:[NSNumber numberWithInt:svn_wc_status_added] forKey:@"added"];
	[dict setObject:[NSNumber numberWithInt:svn_wc_status_missing] forKey:@"missing"];
	[dict setObject:[NSNumber numberWithInt:svn_wc_status_incomplete] forKey:@"incomplete"];
	[dict setObject:[NSNumber numberWithInt:svn_wc_status_deleted] forKey:@"deleted"];
	[dict setObject:[NSNumber numberWithInt:svn_wc_status_replaced] forKey:@"replaced"];
	[dict setObject:[NSNumber numberWithInt:svn_wc_status_modified] forKey:@"modified"];
	[dict setObject:[NSNumber numberWithInt:svn_wc_status_merged] forKey:@"merged"];
	[dict setObject:[NSNumber numberWithInt:svn_wc_status_conflicted] forKey:@"conflicted"];
	[dict setObject:[NSNumber numberWithInt:svn_wc_status_obstructed] forKey:@"obstructed"];
	[dict setObject:[NSNumber numberWithInt:svn_wc_status_ignored] forKey:@"ignored"];
	[dict setObject:[NSNumber numberWithInt:svn_wc_status_external] forKey:@"external"];
	[dict setObject:[NSNumber numberWithInt:svn_wc_status_unversioned] forKey:@"unversioned"];
	
	statusMap = dict;
}

+ (NSString *)stringFromStatus:(WorkingCopyStatus)status
{
	switch( status )
	{
		case svn_wc_status_none:        return @"none";
		case svn_wc_status_normal:      return @"normal";
		case svn_wc_status_added:       return @"added";
		case svn_wc_status_missing:     return @"missing";
		case svn_wc_status_incomplete:  return @"incomplete";
		case svn_wc_status_deleted:     return @"deleted";
		case svn_wc_status_replaced:    return @"replaced";
		case svn_wc_status_modified:    return @"modified";
		case svn_wc_status_merged:      return @"merged";
		case svn_wc_status_conflicted:  return @"conflicted";
		case svn_wc_status_obstructed:  return @"obstructed";
		case svn_wc_status_ignored:     return @"ignored";
		case svn_wc_status_external:    return @"external";
		case svn_wc_status_unversioned: return @"unversioned";
	}
	
	NSLog( @"Got invalid SVN status code: %d", status );
	return @"INVALID";
}

+ (NSString *)flagFromStatus:(WorkingCopyStatus)status
{
	switch( status )
    {
		case svn_wc_status_none:        return @" ";
		case svn_wc_status_normal:      return @" ";
		case svn_wc_status_added:       return @"A";
		case svn_wc_status_missing:     return @"!";
		case svn_wc_status_incomplete:  return @"!";
		case svn_wc_status_deleted:     return @"D";
		case svn_wc_status_replaced:    return @"R";
		case svn_wc_status_modified:    return @"M";
		case svn_wc_status_merged:      return @"G";
		case svn_wc_status_conflicted:  return @"C";
		case svn_wc_status_obstructed:  return @"~";
		case svn_wc_status_ignored:     return @"I";
		case svn_wc_status_external:    return @"X";
		case svn_wc_status_unversioned: return @"?";
		default:                        return @"?";
    }
}

+ (WorkingCopyStatus)statusFromString:(NSString *)__string
{
	return [[statusMap objectForKey:__string] intValue];
}

#pragma mark -
#pragma mark Instance initializers

- (id)initWithFile:(NSString *)__relativePath statusString:(NSString *)__statusString workingCopy:(WorkingCopy *)__workingCopy
{
	return [self initWithFile:__relativePath status:[StatusItem statusFromString:__statusString] workingCopy:__workingCopy];
}

- (id)initWithFile:(NSString *)__relativePath status:(WorkingCopyStatus)__status workingCopy:(WorkingCopy *)__workingCopy
{
	if( ( self = [super init]) != nil )
	{
		workingCopy = [__workingCopy retain];
		relativePath = [__relativePath copy];
		path = [[[NSString pathWithComponents:[NSArray arrayWithObjects:[__workingCopy workingCopyPath],relativePath,nil]] stringByStandardizingPath] copy];
		fileName = [[[path pathComponents] objectAtIndex:( [[path pathComponents] count] - 1 )] copy];
		status = __status;
	}
	return self;
}

- (void)dealloc {
	[self setDelegate:nil];
	[diffOutput release];
	[workingCopy release];
	[fileName release];
	[path release];
	[relativePath release];
	[diff release];
	[super dealloc];
}

#pragma mark -
#pragma mark Accessors and Mutators

- (NSString *)relativePath
{
	return relativePath;
}

- (NSString *)path
{
	return path;
}

- (NSString *)fileName
{
	return fileName;
}

- (id)delegate
{
	return delegate;
}

- (void)setDelegate:(id)__delegate
{
	delegate = __delegate;
}

- (BOOL)selected
{
	return selected;
}

- (void)setSelected:(BOOL)__selected
{
	selected = __selected;
}

- (BOOL)requiresCommit
{
	switch( status )
	{
		case svn_wc_status_added:
		case svn_wc_status_deleted:
		case svn_wc_status_replaced:
		case svn_wc_status_modified:
		case svn_wc_status_merged:
			return YES;
		default:
			return NO;			
	}
}

- (WorkingCopyStatus)status
{
	return status;
}

- (void)setStatus:(WorkingCopyStatus)__status
{
	status = __status;
}

- (NSString *)statusString
{
	return [StatusItem stringFromStatus:[self status]];
}

- (NSString *)statusFlag
{
	return [StatusItem flagFromStatus:[self status]];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"StatusItem-%@-<%@>", [self statusFlag], [self relativePath]];
}

- (BOOL)directory
{
	BOOL exists;
	BOOL isDirectory;
	
	exists = [[NSFileManager defaultManager] fileExistsAtPath:[self path] isDirectory:&isDirectory];
	
	return exists && isDirectory;
}

- (BOOL)canAdd
{
	return status == svn_wc_status_unversioned;
}

- (BOOL)canRemove
{
	return status != svn_wc_status_unversioned;
}

- (BOOL)canRename
{
	return status != svn_wc_status_unversioned;
}

- (BOOL)canRevert
{
	return status == svn_wc_status_modified || status == svn_wc_status_deleted;
}

#pragma mark -
#pragma mark Actions

/*
 * User requests to add this item to the repository
 */
- (void)addToRepository
{
	SubversionTask *task = [[SubversionTask alloc] initWithSubversion:[workingCopy subversionPath]
														  workingCopy:[workingCopy workingCopyPath]
															arguments:[NSArray arrayWithObjects:@"add",[self relativePath],nil]
														  environment:nil];
	[task setDelegate:self];
	[task launch];
}

/*
 * User requests this item be removed.
 */
- (void)subversionRemove
{
	SubversionTask *task = [[SubversionTask alloc] initWithSubversion:[workingCopy subversionPath]
														  workingCopy:[workingCopy workingCopyPath]
															arguments:[NSArray arrayWithObjects:@"remove",@"--force",[self relativePath],nil]
														  environment:nil];
	[task setDelegate:self];
	[task launch];
}

/*
 * User requests the file be reverted, we keep a safety copy in case
 * this is accidental.
 */
- (void)revertChanges
{
	// First create a copy of the patch for this file, the user
	// can later re-apply if they mistakenly revert a file!
	[self backupChanges];
	
	// Now go ahead and revert
	SubversionTask *task = [[SubversionTask alloc] initWithSubversion:[workingCopy subversionPath]
														  workingCopy:[workingCopy workingCopyPath]
															arguments:[NSArray arrayWithObjects:@"revert",[self relativePath],nil]
														  environment:nil];
	[task setDelegate:self];
	[task launch];
}

/*
 * Called to request the display of the items diff via its delegate which is
 * responsible for the UI. If a cached diff is available it is used, otherwise
 * the Diff is requested from Subversion.
 */
- (void)diff
{
	if( diff != nil )
	{
		[self diffAvailable:diff];
	} else {
		switch( [self status] ) {
			case svn_wc_status_added:
			case svn_wc_status_modified:
			case svn_wc_status_merged:
			case svn_wc_status_conflicted:
				[self updateDiff];
				break;
			default:
				[self diffAvailable:nil];
		}
	}
}

/*
 * The user requests that the file be opened in the FileMerge application to show
 * differences between the current file and the working copy base.
 */
- (void)showInFileMerge
{
	// Jimmy the Locale to be en_US for diffs otherwise we may end up parsing stuff like
	// "Arbeitskopie" coming from svn trying to do a de.de localization!
	NSMutableDictionary *environment = [NSMutableDictionary dictionaryWithDictionary:[[NSProcessInfo processInfo] environment]];
	[environment setObject:@"en_US.UTF-8" forKey:@"LC_ALL"];
	
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:[workingCopy subversionPath]];
	[task setEnvironment:environment];
	[task setCurrentDirectoryPath:[workingCopy workingCopyPath]];
	
	NSArray *args = [NSArray arrayWithObjects:@"diff",@"-r",@"base",@"--diff-cmd",[[NSBundle mainBundle] pathForResource:@"fmdiff" ofType:@"sh"],[self relativePath],nil];
	[task setArguments:args];
	
//	NSLog( @"Task = %@", task );
	
	[task launch];
}

/*
 * Invoked in response to a request for the diff of this item where the diff
 * has not been obtained yet (or where the diff needs to be up to date).
 */
- (void)updateDiff
{
//	NSLog( @"Calling out to SVN for diff" );
	
	NSDictionary *environment = [self environmentWithLocale];

	diffOutput = [[NSMutableString alloc] init];
	SubversionTask *task = [[SubversionTask alloc] initWithSubversion:[workingCopy subversionPath]
														  workingCopy:[workingCopy workingCopyPath]
															arguments:[NSArray arrayWithObjects:@"diff",@"--diff-cmd",@"diff",@"--non-interactive",[self relativePath],nil]
														  environment:environment];
	[task setDelegate:self];
	[task launch];
}

/*
 * This method is invoked when there is a diff available for the item. It
 * presents the diff to the items delegate for display.
 */
- (void)diffAvailable:(Diff *)__diff
{
	NSLog( @"Updated diff is available." );
	if( [delegate respondsToSelector:@selector(diffAvailable:forItem:)] )
	{
		[delegate diffAvailable:__diff forItem:self];
	}
}

#pragma mark -
#pragma mark Task support

/*
 * SubversionTask call-back received when the task receives output. When doing
 * an item diff we buffer this output locally. For other tasks we do not and
 * depend upon the items internal buffer.
 */
- (void)taskOutput:(NSString *)output fromTask:(SubversionTask *)__task
{
	if( [__task action] == @"diff" )
	{
		[diffOutput appendString:output];
	}
}

/*
 * SubversionTask call-back received when the task has been launched. We've
 * nothing to do at this point.
 */
- (void)taskStarted:(SubversionTask *)task
{
}

/*
 * SubversionTask call-back received when the task has finished and all
 * output has been captured. We use the task action to decide what to do.
 */
- (void)taskFinished:(SubversionTask *)__task
{
//	NSLog( @"taskFinished:%@", __task );
	if( [__task action] == @"diff" ) {
		[self diffTaskComplete:__task];
	} else if( [__task action] == @"add" ) {
		[self addTaskComplete:__task];
	} else if( [__task action] == @"remove" ) {
		[self removeTaskComplete:__task];
	} else if( [__task action] == @"status" ) {
		[self statusTaskComplete:__task];
	} else if( [__task action] == @"revert" ) {
		[self revertTaskComplete:__task];
	}
}

/*
 * When a diff task is complete the delegate must be notified so
 * that the GUI diff can be refreshed.
 */
- (void)diffTaskComplete:(SubversionTask *)__task
{
	NSError *error;
	DiffParser *parser = [[[DiffParser alloc] init] autorelease];
	diff = [parser diff:diffOutput error:&error];
	[self diffAvailable:diff];
}

/*
 * When an add task is complete the delegate must be notified so that
 * the GUI file table & diff can be updated.
 */
- (void)addTaskComplete:(SubversionTask *)__task
{
	if( [[__task output] hasPrefix:@"svn warning:"] )
	{
		[NSAlert alertWithMessageText:[__task output]
						defaultButton:@"Ok"
					  alternateButton:nil
						  otherButton:nil
			informativeTextWithFormat:nil];
	}
	else
	{
		if( [self directory] ) {
			if( [delegate respondsToSelector:@selector(refreshAll)] ) {
				[delegate refreshAll];
			} else {
				NSLog( @"StatusItem cannot send refreshAll message to delegate because it will not respond!" );
			}
		} else {
			[self updateStatus];
		}
	}
}

- (void)removeTaskComplete:(SubversionTask *)__task
{
	if( [[__task output] hasPrefix:@"svn warning:"] ) {
		[NSAlert alertWithMessageText:[__task output]
						defaultButton:@"Ok"
					  alternateButton:nil
						  otherButton:nil
			informativeTextWithFormat:nil];
	} else {
		if( [delegate respondsToSelector:@selector(refreshAll)] ) {
			[delegate refreshAll];
		} else {
			NSLog( @"StatusItem cannot send refreshAll message to delegate because it will not respond!" );
		}
	}
}

- (void)revertTaskComplete:(SubversionTask *)__task
{
	if( [[__task output] hasPrefix:@"svn warning:"] )
	{
		[NSAlert alertWithMessageText:[__task output]
						defaultButton:@"Ok"
					  alternateButton:nil
						  otherButton:nil
			informativeTextWithFormat:nil];
	}
	else
	{
		if( [delegate respondsToSelector:@selector(refreshAll)] ) {
			[delegate refreshAll];
		} else {
			NSLog( @"StatusItem cannot send refreshAll message to delegate because it will not respond!" );
		}
	}
}

- (void)statusTaskComplete:(SubversionTask *)__task
{
	[self setStatus:[self parseStatusFromXML:[__task output]]];
	
	if( [delegate respondsToSelector:@selector(refreshItem:)] )
	{
		[delegate refreshItem:self];
	}
	else
	{
		NSLog( @"%@ delegate %@ does not respond to refreshItem:", self, [self delegate] );
	}
}

- (WorkingCopyStatus)parseStatusFromXML:(NSString *)__xml
{
	NSError *error;
	
	NSXMLDocument *document = [[NSXMLDocument alloc] initWithXMLString:__xml options:nil error:&error];
	if( document == nil )
	{
		NSLog( @"Cannot parse status XML for: %@", [self relativePath] );
		return svn_wc_status_none;
	}
	
	NSArray *entryElements = [document nodesForXPath:@".//entry" error:&error];
	if( entryElements == nil || [entryElements count] == 0 )
	{
		NSLog( @"No entry (unmodified) for: %@", [self relativePath] );
		return svn_wc_status_none;
	}
	
	NSXMLNode *entry = [entryElements objectAtIndex:0];
	NSArray *attributes = [entry nodesForXPath:@"./wc-status[1]/@item" error:&error];
	if( attributes == nil )
	{
		NSLog( @"Cannot parse attributes for status item: %@", [self relativePath] );
		return svn_wc_status_none;
	}
	
	return [StatusItem statusFromString:[[attributes objectAtIndex:0] stringValue]];
}

/*
 * Update the status of this individual file (status information is obtained for the whole working
 * copy as a rule because it's more efficient.
 */
- (void)updateStatus
{
	NSArray *args = [NSArray arrayWithObjects:@"status",@"--xml",@"--non-interactive",[self relativePath],nil];
	SubversionTask *task = [[SubversionTask alloc] initWithSubversion:[workingCopy subversionPath] 
														 workingCopy:[workingCopy workingCopyPath]
														   arguments:args
														 environment:nil];
	[task setDelegate:self];
	[task launch];
}

- (void)backupChanges
{
	NSTask *task = [[[NSTask alloc] init] autorelease];
	[task setLaunchPath:[[NSBundle mainBundle] pathForResource:@"export" ofType:@"sh"]];
	NSLog( @"Launch: %@", [task launchPath] );
	
	[task setEnvironment:[self environmentWithLocale]];
	[task setCurrentDirectoryPath:[workingCopy workingCopyPath]];
	
	NSMutableArray *args = [[[NSMutableArray alloc] init] autorelease];
	[args addObject:[[NSUserDefaults standardUserDefaults] objectForKey:DifflySvnPathKey]];
	
	// Create a path in temp for the backup diff
	NSString *difflyBackupPath = [NSString pathWithComponents:[NSArray arrayWithObjects:NSTemporaryDirectory(),@"diffly",nil]];
	if( ![[NSFileManager defaultManager] fileExistsAtPath:difflyBackupPath] )
	{
		if( ![[NSFileManager defaultManager] createDirectoryAtPath:difflyBackupPath attributes:nil] )
		{
			NSLog( @"Was unable to create revert undo folder: %@", difflyBackupPath );
			return;
		}
	}
	
	// Export a patch for this file to re-create the reverted changes
	NSString *patchFile = [NSString pathWithComponents:[NSArray arrayWithObjects:difflyBackupPath,[self fileName]]];	
	[args addObject:patchFile];
	[args addObject:[self relativePath]];
	[task setArguments:args];
	
	[task launch];
	[task waitUntilExit];
}

- (NSDictionary *)environmentWithLocale
{
	// Jimmy the Locale to be en_US for diffs otherwise we may end up parsing stuff like
	// "Arbeitskopie" coming from svn trying to do a de.de localization!
	NSMutableDictionary *environment = [NSMutableDictionary dictionaryWithDictionary:[[NSProcessInfo processInfo] environment]];
	[environment setObject:@"en_US.UTF-8" forKey:@"LC_ALL"];
	return environment;
}

@end
