//
//  NSFileManager+tempFileName.m
//  Diffly
//
//  Created by Matt Mower on 08/01/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "NSFileManager+tempFileName.h"


@implementation NSFileManager (tempFileName)

- (NSString*)tempFileNameWithPrefix:(NSString*)prefix
{
	NSString*   tempDir = NSTemporaryDirectory();
	NSString*   fname = nil;
	NSString*	tempName;
	
	if( !tempDir )
	{
		// EEK!
		return nil;
	}
	
	do
	{
		tempName = [NSString stringWithFormat:@"diffly_%@_%d.tmp", prefix, rand()];
		fname = [tempDir stringByAppendingPathComponent:tempName];
	} while( fname == nil || [self fileExistsAtPath:fname] );
	
	return fname;
}

@end
