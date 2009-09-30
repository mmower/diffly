//
//  WorkingCopyWebViewDelegate.m
//  Diffly
//
//  Created by Matt Mower on 03/02/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "WorkingCopyWebViewDelegate.h"

@implementation WorkingCopyWebViewDelegate

- (void)setViewDelegate:(id)__delegate
{
	[[self view] setUIDelegate:__delegate];	
}

- (NSArray*)webView:(WebView*)sender contextMenuItemsForElement:(NSDictionary*)element defaultMenuItems:(NSArray*)defaultMenuItems
{
	return nil;
}


@end
