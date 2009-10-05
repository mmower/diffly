//
//  NSObject+SubversionTask.h
//  Diffly
//
//  Created by Matt Mower on 18/02/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class SubversionTask;

@interface NSObject (NSObject_SubversionTask)

- (void)taskOutput:(NSString *)output fromTask:(SubversionTask *)task;
- (void)taskStarted:(SubversionTask *)task;
- (void)taskFinished:(SubversionTask *)task;

@end
