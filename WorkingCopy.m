//
//  WorkingCopy.m
//  SvnDiffParser
//
//  Created by Matt Mower on 27/01/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import "WorkingCopy.h"

#import "StatusItem.h"

#import "Tsai.h"

@implementation WorkingCopy

- (id)initWithSubversion:(NSString *)__subversionPath workingCopy:(NSString *)__workingCopyPath
{
	if( __subversionPath == nil || __workingCopyPath == nil )
	{
		return nil;
	}
	
	if( ( self = [super init]) != nil )
	{
		subversionPath = [__subversionPath copy];
		workingCopyPath = [__workingCopyPath copy];
		items = nil;
		task = nil;
	}
	return self;
}

- (void)dealloc
{
	[self setDelegate:nil];
	
	[items release];
	[subversionPath release];
	[workingCopyPath release];
	
	[super dealloc];
}

- (id)delegate
{
	return delegate;
}

- (void)setDelegate:(id)__delegate
{
	delegate = __delegate;
}

- (NSString *)subversionPath
{
	return subversionPath;
}

- (NSString *)workingCopyPath
{
	return workingCopyPath;
}

- (void)dumpItems
{
	NSLog( @"WorkingCopy::Items" );
	foreach( item, items )
	{
		NSLog( @"item-%@", item );
	}
}

- (NSArray *)items
{
//	[self dumpItems];
	return items;
}

- (void)setItems:(NSArray *)__items
{
	[self willChangeValueForKey:@"items"];
	[items autorelease];
	items = [__items copy];
	[self didChangeValueForKey:@"items"];
}

- (void)update
{
	if( task != nil )
	{
		NSLog( @"Attempt to start one update task while another is still running." );
		return;
	}
	
	// Not passing an environment here, hopefully pick up whatever is the default
	task = [[SubversionTask alloc] initWithSubversion:[self subversionPath] 
										  workingCopy:[self workingCopyPath]
											arguments:[NSArray arrayWithObjects:@"status",@"--xml",@"--non-interactive",nil]
										  environment:nil];
	[task setDelegate:self];
	[task launch];
}

- (void)taskFinished:(SubversionTask *)__task
{
	[self setItems:[self status:[task output]]];
	
	[task autorelease];
	task = nil;
	
	if( [delegate respondsToSelector:@selector(workingCopyUpdated:)] )
	{
		[delegate workingCopyUpdated:self];
	}
}

- (NSArray *)status:(NSString *)__statusXml
{
	NSError *error;
	
	NSXMLDocument *document = [[NSXMLDocument alloc] initWithXMLString:__statusXml options:nil error:&error];
	if( document == nil )
	{
		return nil;
	}
	
	NSArray *entryElements = [document nodesForXPath:@".//entry" error:&error];
	if( entryElements == nil )
	{
		return nil;
	}
	
	NSMutableArray *statusItems = [[[NSMutableArray alloc] init] autorelease];
	
	foreach( entry, entryElements )
	{
		NSArray *attributes = nil;
		
		attributes = [entry nodesForXPath:@"@path" error:&error];
		if( attributes == nil )
		{
			return nil;
		}
		NSString* filePath = [[attributes objectAtIndex:0] stringValue];
		
		attributes = [entry nodesForXPath:@"./wc-status[1]/@item" error:&error];
		if( attributes == nil )
		{
			return nil;
		}
		NSString* fileStatus = [[attributes objectAtIndex:0] stringValue];
		
		[statusItems addObject:[[StatusItem alloc] initWithFile:filePath
												   statusString:fileStatus
													workingCopy:self]];
	}
	
	return statusItems;
}

@end
