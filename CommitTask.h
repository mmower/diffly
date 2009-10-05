//
//  CommitTask.h
//  Diffly
//
//  Created by Matt Mower on 08/01/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "NSObject+CommitTask.h"


@interface CommitTask : NSObject {
	NSTask			*task;
	NSPipe			*stdoutPipe, *stderrPipe;
	NSFileHandle	*stdoutHandle, *stderrHandle;
	
	id				delegate;
}

- (id)delegate;
- (void)setDelegate:(id)delegate;

- (id)initWithCurrentPath:(NSString*)currentPath files:(NSArray*)files message:(NSString*)message;
- (void)commit;
- (NSString*)fileNamesForDiffList:(NSArray*)diffList;

// NSFileHandle notifications
- (void)taskDataAvailable:(NSNotification*)notification;
- (void)taskCompleted:(NSNotification*)Notification;

@end
