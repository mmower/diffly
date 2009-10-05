//
//  DiffLine.h
//  SvnDiffParser
//
//  Created by Matt Mower on 06/01/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

typedef enum
{
	CommonLine,
	AddedLine,
	RemovedLine
} LineType;

@interface DiffLine : NSObject {
	LineType	type;
	NSString	*content;
}

- (id)initWithString:(NSString *)line;
- (LineType)type;
- (void)setType:(LineType)lineType;
- (NSString *)content;
- (void)setContent:(NSString *)lineContent;
- (NSString *)toHTML;

@end
