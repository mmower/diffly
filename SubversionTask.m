//
//  SubversionTask.m
//  Diffly
//
//  Created by Matt Mower on 18/02/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import "SubversionTask.h"

#import "NSObject+SubversionTask.h"

@implementation SubversionTask

- (id)initWithSubversion:(NSString *)subversionPath workingCopy:(NSString *)workingCopyPath arguments:(NSArray *)arguments environment:(NSDictionary *)environment
{
	if( ( self = [super init]) != nil )
	{
		buffer = [[NSMutableString alloc] init];
		
		action = [arguments objectAtIndex:0];
		
		NSMutableArray *taskArgs = [[NSMutableArray alloc] init];
		[taskArgs addObject:subversionPath];
		[taskArgs addObject:workingCopyPath];
		[taskArgs addObjectsFromArray:arguments];
		wrapper = [[TaskWrapper alloc] initWithController:self arguments:taskArgs environment:environment];
	}
	
	return self;
}

- (void)dealloc
{
	[self setDelegate:nil];
	[wrapper release];
	[buffer release];
	
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

- (NSString *)action
{
	return action;
}

- (void)launch
{
	[wrapper startProcess];
}

- (NSString *)output
{
	return [[buffer copy] autorelease];
}

- (void)appendOutput:(NSString *)__output
{
	[buffer appendString:__output];
	if( [delegate respondsToSelector:@selector(taskOutput:fromTask:)] )
	{
		[delegate taskOutput:__output fromTask:self];
	}
}

- (void)processStarted
{
	if( [delegate respondsToSelector:@selector(taskStarted:)] )
	{
		[delegate taskStarted:self];
	}
}

- (void)processFinished
{
	if( [delegate respondsToSelector:@selector(taskFinished:)] )
	{
		[delegate taskFinished:self];
	}	
}

@end
