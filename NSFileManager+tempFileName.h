//
//  NSFileManager+tempFileName.h
//  Diffly
//
//  Created by Matt Mower on 08/01/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSFileManager (tempFileName)

- (NSString*)tempFileNameWithPrefix:(NSString*)prefix;

@end
