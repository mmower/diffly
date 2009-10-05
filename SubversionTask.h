//
//  SubversionTask.h
//  Diffly
//
//  Created by Matt Mower on 18/02/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "TaskWrapper.h"

@interface SubversionTask : NSObject <TaskWrapperController> {
	id delegate;
	
	TaskWrapper *wrapper;
	NSMutableString *buffer;
	NSString *action;
}

- (id)initWithSubversion:(NSString *)subversionPath workingCopy:(NSString *)workingCopyPath arguments:(NSArray *)arguments environment:(NSDictionary *)environment;

- (id)delegate;
- (void)setDelegate:(id)delegate;

- (void)launch;
- (NSString *)output;

- (NSString *)action;

- (void)appendOutput:(NSString *)output;
- (void)processStarted;
- (void)processFinished;

@end
