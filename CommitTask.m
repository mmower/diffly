//
//  CommitTask.m
//  Diffly
//
//  Created by Matt Mower on 08/01/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import "Tsai.h"
#import "CommitTask.h"
#import "PreferenceController.h"

#import "NSFileManager+tempFileName.h"

@implementation CommitTask

- (id)initWithCurrentPath:(NSString*)currentPath files:(NSArray*)files message:(NSString*)message
{
	self = [super init];
	
	// Store the commit message in a temporary file
	NSString* messageFileName = [[NSFileManager defaultManager] tempFileNameWithPrefix:@"message"];
	[message writeToFile:messageFileName atomically:NO];
	
	// Store files to check in to a temporary file
	NSString* targetFileName = [[NSFileManager defaultManager] tempFileNameWithPrefix:@"targets"];
	[[self fileNamesForDiffList:files] writeToFile:targetFileName atomically:NO];
	
	NSArray *commitArgs = [NSArray arrayWithObjects:@"ci",@"--non-interactive",@"--file",messageFileName,@"--targets",targetFileName,nil];
	NSLog( @"CommitTask Arguments: %@", commitArgs );
		
	task = [[NSTask alloc] init];
	[task setLaunchPath:[[NSUserDefaults standardUserDefaults] objectForKey:DifflySvnPathKey]];
	[task setCurrentDirectoryPath:currentPath];
	[task setArguments:commitArgs];
	
	stdoutPipe = [NSPipe pipe];
	[task setStandardOutput:stdoutPipe];
	stdoutHandle = [stdoutPipe fileHandleForReading];
	[stdoutHandle readInBackgroundAndNotify];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(taskDataAvailable:)
												 name:NSFileHandleReadCompletionNotification
											   object:stdoutHandle];
	
	stderrPipe = [NSPipe pipe];
	[task setStandardError:stderrPipe];
	stderrHandle = [stderrPipe fileHandleForReading];
	[stderrHandle readInBackgroundAndNotify];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(taskDataAvailable:)
												 name:NSFileHandleReadCompletionNotification
											   object:stderrHandle];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(taskCompleted:)
												 name:NSTaskDidTerminateNotification
											   object:task];
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (id)delegate
{
	return delegate;
}

- (void)setDelegate:(id)theDelegate
{
	delegate = theDelegate;
}

- (NSString*)fileNamesForDiffList:(NSArray*)diffList
{
	NSMutableString* text = [[NSMutableString alloc] init];
	
	foreach( diff, diffList )
	{
		[text appendString:[NSString stringWithFormat:@"%@\n", [diff relativePath]]];
	}
	
	return text;
}

- (void)commit
{
	[task launch];
	NSLog( @"CommitTask launched." );
}

- (void)taskDataAvailable:(NSNotification*)notification
{
	//NSLog( @"taskDataAvailable: [object=%@]", [notification object] );
	NSData *data = [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem];
	if( data && [data length] > 0 )
	{
		NSString* text = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		//NSLog( @"text=[%@]", text );

		if( [delegate respondsToSelector:@selector(commitMessageArrived:)] )
		{
			[delegate commitMessageArrived:text];
		}
		else
		{
			NSLog( @"CommitTask delegate (%@) does not respond to selector commitMessageArrived:" );
		}
		
//		[messageView setString:[[messageView string] stringByAppendingString:text]];
		[[notification object] readInBackgroundAndNotify];
	}
}

- (void)taskCompleted:(NSNotification*)Notification
{
//	NSLog( @"CommitTask completed." );
	if( [delegate respondsToSelector:@selector(commitHasCompleted)] )
	{
		[delegate commitHasCompleted];
	}
}

@end
