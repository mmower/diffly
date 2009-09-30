#import <Cocoa/Cocoa.h>

@class Stack;
@class Diff;
@class Hunk;

#define DIFF_PARSER_ERROR_DOMAIN @"com.mattmower.diffly.ErrorDomain"

@interface DiffParser : NSObject {
	// Ragel state variables
	const char	*p;
	const char	*pstart;
	const char	*pmark;
	int			cs;
	
	// Parsing state
	Stack		*stack;
	int			line;
	
	Diff		*diff;
	Hunk		*curHunk;
	
	NSError		*error;
}

- (Diff *)diff:(NSString *)content error:(NSError**)error;

@end
