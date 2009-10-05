//
//  WorkingCopyController+Toolbar.h
//  Diffly
//
//  Created by Matt Mower on 29/01/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "WorkingCopyDocument.h";

@interface WorkingCopyDocument (ToolbarDelegate)

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
	 itemForItemIdentifier:(NSString *)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag;

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar;

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar;

@end
