//
//  NSObject+StatusItem.h
//  Diffly
//
//  Created by Matt Mower on 18/02/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class Diff;
@class StatusItem;

@interface NSObject (NSObject_StatusItem)

- (void)diffAvailable:(Diff *)diff forItem:(StatusItem *)item;
- (void)refreshItem:(StatusItem *)item;
- (void)refreshAll;

@end
