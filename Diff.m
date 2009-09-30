//
//  DiffSpec.m
//  Ragel2
//
//  Created by Matt Mower on 01/01/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Diff.h"
#import "Hunk.h"

#import "Tsai.h"

@implementation Diff

- (id)init
{
	if( ( self = [super init] ) != nil )
	{
		hunks = [[NSMutableArray alloc] init];
		isBinary = NO;
	}
	return self;
}

- (void)dealloc
{
	[file release];
	[hunks release];
	[super dealloc];
}

- (NSString *)file
{
	return file;
}

- (void)setFile:(NSString *)__file
{
	[file autorelease];
	file = [__file copy];
}

- (int)oldRev
{
	return oldRev;
}

- (NSString *)oldRevString
{
	if( oldRev == -1 )
	{
		return @"working copy";
	}
	else
	{
		return [NSString stringWithFormat:@"revision %d", oldRev];
	}
}

- (void)setOldRev:(int)__oldRev
{
	oldRev = __oldRev;
}

- (int)newRev
{
	return newRev;
}

- (NSString *)newRevString
{
	if( newRev == -1 )
	{
		return @"working copy";
	}
	else
	{
		return [NSString stringWithFormat:@"revision %d", newRev];
	}
}

- (void)setNewRev:(int)__newRev
{
	newRev = __newRev;
}

- (BOOL)isBinary
{
	return isBinary;
}

- (void)setIsBinary:(BOOL)__isBinary
{
	isBinary = __isBinary;
}

- (NSArray *)hunks
{
	return hunks;
}

- (int)changeCount
{
	return [hunks count];
}

- (void)addHunk:(Hunk *)__hunk
{
	[hunks addObject:__hunk];
}

- (NSString *)toHTML
{
	NSMutableString *html = [[[NSMutableString alloc] init] autorelease];
	BOOL odd = YES;
	
	[html appendString:@"<div class='diff'>"];
	
	if( isBinary )
	{
		[html appendString:@"<p>Binary Diff</p>\n"];
	}
	else if( [hunks count] == 0 )
	{
		[html appendString:@"<p>Empty file</p>\n"];
	}
	else
	{
		[html appendString:[NSString stringWithFormat:@"<div class='hunk removed-line'>--- %@</div><div class='hunk added-line'>+++ %@</div>", [self oldRevString], [self newRevString]]];
		foreach( hunk, hunks )
		{
			[html appendString:[hunk toHTMLwithStyle:(odd ? @"hunk odd" : @"hunk even")]];
			[html appendString:@"<br/>\n"];
			odd = !odd;
		}
	}
	
	[html appendString:@"</div>"];
	
	return html;
}

- (NSString *)toHTMLwithUrlBase:(NSString *)__base path:(NSString *)__path
{
	NSMutableString *html = [[[NSMutableString alloc] init] autorelease];
	BOOL odd = YES;
	
	[html appendString:@"<div class='diff'>"];
	
	if( isBinary )
	{
		[html appendString:@"<h1>Binary Diff</h1><br/>\n"];
	}
	else if( [hunks count] == 0 )
	{
		[html appendString:@"<p>Empty file</p>\n"];
	}
	else
	{
		[html appendString:[NSString stringWithFormat:@"<div class='hunk removed-line'>--- %@</div><div class='hunk added-line'>+++ %@</div>", [self oldRevString], [self newRevString]]];
		foreach( hunk, hunks )
		{
			[html appendString:[hunk toHTMLwithUrlBase:__base path:__path file:[self file] style:(odd ? @"hunk odd-row" : @"hunk even-row")]];
			[html appendString:@"<br/>\n"];
			odd = !odd;
		}
	}
	
	[html appendString:@"</div>"];
	
	return html;
}

@end
