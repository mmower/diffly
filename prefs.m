//
//  prefs.m
//  Diffly
//
//  Created by Matt Mower on 25/04/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "prefs.h"

BOOL checkForValidSubversion()
{
	NSString* svnPath = [[NSUserDefaults standardUserDefaults] objectForKey:DifflySvnPathKey];
	NSLog( @"svn='[%@]',read:%@, exec:%@", svnPath, [[NSFileManager defaultManager] isReadableFileAtPath:svnPath] ? @"YES" : @"NO", [[NSFileManager defaultManager] isExecutableFileAtPath:svnPath] ? @"YES" : @"NO" );
	return [[NSFileManager defaultManager] isExecutableFileAtPath:[[NSUserDefaults standardUserDefaults] objectForKey:DifflySvnPathKey]];
}

BOOL checkForValidStylesheet()
{
	NSString* stylesheetPath = [[NSUserDefaults standardUserDefaults] objectForKey:DifflyStylesheetPathKey];
	if( stylesheetPath != nil && ![stylesheetPath isEqualToString:@""] )
	{
		return [[NSFileManager defaultManager] isReadableFileAtPath:stylesheetPath];
	}
	else
	{
		return YES;
	}
}