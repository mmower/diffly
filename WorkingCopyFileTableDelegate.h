//
//  WorkingCopyDocumentFileTableDelegate.h
//  Diffly
//
//  Created by Matt Mower on 03/02/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "WorkingCopyUIDelegate.h"

@interface WorkingCopyFileTableDelegate : WorkingCopyUIDelegate {
}

- (void)updateDiffView:(NSString *)html halt:(BOOL)halt;

@end
