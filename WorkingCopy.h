//
//  WorkingCopy.h
//  SvnDiffParser
//
//  Created by Matt Mower on 27/01/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class StatusItem;

#import "SubversionTask.h"
#import "NSObject+WorkingCopy.h"

@interface WorkingCopy : NSObject {
	NSString		*subversionPath;
	NSString		*workingCopyPath;
	
	id				delegate;
	NSArray			*items;
	SubversionTask	*task;
}

- (id)initWithSubversion:(NSString *)subversionPath workingCopy:(NSString *)workingCopyPath;

- (id)delegate;
- (void)setDelegate:(id)delegate;

- (NSString *)subversionPath;
- (NSString *)workingCopyPath;

- (NSArray *)items;
- (void)setItems:(NSArray *)items;

- (void)update;
- (NSArray *)status:(NSString *)statusXml;

- (void)taskFinished:(SubversionTask *)task;

@end
