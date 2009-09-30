//
//  NSObject+CommitTask.h
//  Diffly
//
//  Created by Matt Mower on 13/01/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSObject (NSObject_CommitTask)

- (void)commitMessageArrived:(NSString*)message;
- (void)commitHasCompleted;

@end
