//
//  DiffLine.m
//  SvnDiffParser
//
//  Created by Matt Mower on 06/01/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "DiffLine.h"

#import "NSString+XMLEscape.h"

@implementation DiffLine

- (id)initWithString:(NSString *)__line
{
	if( ( self = [super init] ) != nil )
	{
		switch( [__line characterAtIndex:0] )
		{
			case ' ':
				[self setType:CommonLine];
				break;
				
			case '+':
				[self setType:AddedLine];
				break;
				
			case '-':
				[self setType:RemovedLine];
				break;
		}
		
		[self setContent:__line];
	}
	
	return self;
}

- (LineType)type
{
	return type;
}

- (void)setType:(LineType)__lineType
{
	type = __lineType;
}

- (NSString *)content
{
	return content;
}

- (void)setContent:(NSString *)__content
{
	[content autorelease];
	content = [__content copy];
}

- (NSString *)toHTML
{
	NSString *style;
	
	switch( type )
	{
		case CommonLine:
			style = @"common-line";
			break;
		case AddedLine:
			style = @"added-line";
			break;
		case RemovedLine:
			style = @"removed-line";
			break;		
		default:
			style = @"";
	}
	
	return [NSString stringWithFormat:@"<span class='%@'>%@</span>", style, [[self content] xmlEscape]];
}

@end
