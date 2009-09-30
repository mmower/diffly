//
//  StatusTable.h
//  Diffly
//
//  Created by Matt Mower on 09/04/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "StatusItem.h"

@interface StatusTable : NSTableView {
}

- (unichar)keyFromEvent:(NSEvent *)event;
- (void)keyDown:(NSEvent *)event;

- (NSMenu *)menuForEvent:(NSEvent *)event;

- (void)checkSelected;
- (void)uncheckSelected;
- (void)toggleSelected;

- (void)selectNextRow;

- (StatusItem *)statusItemAtRow:(int)row;

@end
