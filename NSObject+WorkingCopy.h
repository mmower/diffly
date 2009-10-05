//
//  NSObject+WorkingCopy.h
//  Diffly
//
//  Created by Matt Mower on 04/04/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class WorkingCopy;

@interface NSObject (NSObject_WorkingCopy)

- (void)workingCopyUpdated:(WorkingCopy *)orkingCopy;

@end
