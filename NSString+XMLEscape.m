//
//  NSString+XMLEscape.m
//  SvnDiffParser
//
//  Created by Matt Mower on 05/01/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "NSString+XMLEscape.h"


@implementation NSString (XMLEscape)

- (NSString*)xmlEscape
{
	NSMutableString* escaped = [[self mutableCopy] autorelease];
	[escaped replaceOccurrencesOfString: @"&" withString: @"&amp;"  
								options: 0 range: NSMakeRange (0, [escaped length])];
	[escaped replaceOccurrencesOfString: @"<" withString: @"&lt;" options:  
								0 range: NSMakeRange (0, [escaped length])];
	[escaped replaceOccurrencesOfString: @">" withString: @"&gt;" options:  
								0 range: NSMakeRange (0, [escaped length])];
	[escaped replaceOccurrencesOfString: @"\"" withString: @"&quot;"  
								options: 0 range: NSMakeRange (0, [escaped length])];
	return [escaped copy];
}

@end
