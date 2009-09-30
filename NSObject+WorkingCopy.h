//
//  NSObject+WorkingCopy.h
//  Diffly
//
//  Created by Matt Mower on 04/04/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WorkingCopy;

@interface NSObject (NSObject_WorkingCopy)

- (void)workingCopyUpdated:(WorkingCopy *)orkingCopy;

@end
