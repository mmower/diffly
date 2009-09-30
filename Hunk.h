//
//  Hunk.h
//  Ragel2
//
//  Created by Matt Mower on 01/01/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DiffLine;

//
// A hunk represents a contiguous region of changes in a diff
// output patch
//

@interface Hunk : NSObject {
	int				oldFirstLine;
	int				oldExtent;
	int				newFirstLine;
	int				newExtent;
	
	NSMutableArray	*lines;
}

- (NSString *)spec;

- (void)setOldFirstLine:(int)line;
- (void)setNewFirstLine:(int)line;
- (void)setOldExtent:(int)extent;
- (void)setNewExtent:(int)extent;

- (void)addLine:(DiffLine *)line;
- (NSArray *)lines;
- (NSString *)toHTMLwithStyle:(NSString* )style;
- (NSString *)toHTMLwithUrlBase:(NSString *)base path:(NSString *)path file:(NSString *)file style:(NSString *)style;

@end
