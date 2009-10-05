//
//  Stack.m
//  SvnDiffParser
//
//  Created by Matt Mower on 05/01/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import "Stack.h"


@implementation Stack

- (id)init
{
	if( ( self = [super init]) != nil )
	{
		contents = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[contents release];
	[super dealloc];
}

- (void)pushObject:(id)__obj
{
	[contents addObject:__obj];
}

- (id)popObject
{
	id object = [contents lastObject];
	[contents removeLastObject];
	return object;
}

@end
