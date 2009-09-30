//
//  Hunk.m
//  Ragel2
//
//  Created by Matt Mower on 01/01/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Tsai.h"

#import "Hunk.h"
#import "DiffLine.h"

@implementation Hunk

- (id)init
{
	if( ( self = [super init] ) != nil )
	{
		lines = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[lines release];
	
	[super dealloc];
}

- (NSString *)spec
{
	return [NSString stringWithFormat:@"@@ -%d,%d %d,%d @@", oldFirstLine, oldExtent, newFirstLine, newExtent];
}

- (void)setOldFirstLine:(int)__line
{
	oldFirstLine = __line;
}

- (void)setNewFirstLine:(int)__line
{
	newFirstLine = __line;
}

- (void)setOldExtent:(int)__extent
{
	oldExtent = __extent;
}

- (void)setNewExtent:(int)__extent
{
	newExtent = __extent;
}

- (void)addLine:(DiffLine *)__line
{
	[lines addObject:__line];
}

- (NSArray *)lines
{
	return lines;
}

- (NSString *)toCodeBlock
{
	NSMutableString *text = [[[NSMutableString alloc] init] autorelease];
	foreach( line, lines )
	{
		[text appendString:[line toHTML]];
		[text appendString:@"\n"];		
	}
	return text;
}

- (NSString *)toHTMLwithStyle:(NSString *)__style
{
	return [NSString stringWithFormat:@"<div class='%@'><p>Begins on line: %d</p><pre><code>%@</code></pre></div>", __style, newFirstLine, [self toCodeBlock]];
}

- (NSString *)toHTMLwithUrlBase:(NSString *)__base path:(NSString *)__path file:(NSString *)__file style:(NSString *)__style
{
	return [NSString stringWithFormat:@"<div class='%@'><p><a href='%@/%@/%@&line=%d'>Begins on line: %d</a></p><pre><code>%@</code></pre></div>", __style, __base, __path, __file, newFirstLine, newFirstLine, [self toCodeBlock]];
}

@end
