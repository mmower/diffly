//
//  DiffSpec.h
//  Ragel2
//
//  Created by Matt Mower on 01/01/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class Hunk;

@interface Diff : NSObject {
	NSString		*file;
	int				oldRev;
	int				newRev;
	BOOL			isBinary;
	NSMutableString	*currentHunk;
	NSMutableArray	*hunks;
}

- (NSString *)file;
- (void)setFile:(NSString *)file;

- (BOOL)isBinary;
- (void)setIsBinary:(BOOL)binary;

- (int)oldRev;
- (void)setOldRev:(int)oldRev;

- (int)newRev;
- (void)setNewRev:(int)newRev;

- (NSArray *)hunks;
- (void)addHunk:(Hunk *)hunk;
- (int)changeCount;

- (NSString *)toHTML;
- (NSString *)toHTMLwithUrlBase:(NSString *)base path:(NSString *)path;

@end
