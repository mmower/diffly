//
//  WorkingCopyUIDelegate.h
//  Diffly
//
//  Created by Matt Mower on 03/02/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class WorkingCopyDocument;

@interface WorkingCopyUIDelegate : NSObject {
	WorkingCopyDocument	*document;
	id					view;
}

- (id)initWithDocument:(WorkingCopyDocument *)document view:(id)view;

- (WorkingCopyDocument *)document;
- (void)setDocument:(WorkingCopyDocument *)document;

- (id)view;
- (void)setView:(id)view;

- (void)setViewDelegate:(id)delegate;

@end
