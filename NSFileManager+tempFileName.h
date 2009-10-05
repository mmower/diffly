//
//  NSFileManager+tempFileName.h
//  Diffly
//
//  Created by Matt Mower on 08/01/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@interface NSFileManager (tempFileName)

- (NSString*)tempFileNameWithPrefix:(NSString*)prefix;

@end
