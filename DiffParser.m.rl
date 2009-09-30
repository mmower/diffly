#import "DiffParser.h"
#import "Diff.h"
#import "Hunk.h"
#import "Stack.h"
#import "DiffLine.h"

#import "assert.h"

//#define LOG_MARK 1
//#define LOG_ACTIONS 1

%%{
	machine DiffParser;
	
### actions

	action record_state	{
		if( *p > 31 && *p < 127 ) {
			NSLog( [NSString stringWithFormat:@"%02x %c -> state: %d", *p, *p, cs] );
		} else {
			NSLog( [NSString stringWithFormat:@"%02x ~ -> state: %d", *p, cs] );
		}
		
		if( cs == DiffParser_error ) {
			NSLog( @"ERROR" );
		}
	}

	action count_line {
		line += 1;
	}

	action push {
		NSString* item = [self copyMarkedString];
		#if LOG_ACTIONS
			NSLog( @"    Pushing: '%@'", item );
		#endif
		[stack pushObject:item];
	}
	
	action push_zero {
		#if LOG_ACTIONS
			NSLog( @"    Pushing: 0" );
		#endif
		[stack pushObject:@"0"];
	}
	
	action push_minus_one {
		#if LOG_ACTIONS
			NSLog( @"    Pushing: -1" );
		#endif
		[stack pushObject:@"-1"];
	}

	action mark {
		#if LOG_MARK
			NSLog( @"Marking @ %p '%c'", p, *p );
		#endif
		pmark = p;
	}
	
	action copy_to_filespec {
		NSString* fileSpec = [self copyMarkedString];
		#if LOG_ACTIONS
			NSLog( @"  filespec: %@", fileSpec );
		#endif
		[diff setFile:fileSpec];
	}
	
	action pop_old_rev {
		int rev = [[stack popObject] intValue];
		#if LOG_ACTIONS
			NSLog( @"  oldRev: %d", rev );
		#endif
		[diff setOldRev:rev];
	}
	
	action pop_new_rev {
		int rev = [[stack popObject] intValue];
		#if LOG_ACTIONS
			NSLog( @"  newRev: %d", rev );
		#endif
		[diff setNewRev:rev];
	}
	
	action binary_diff {
		#if LOG_ACTIONS
			NSLog( @"  BINARY DIFF" );
		#endif
		[diff setIsBinary:YES];
	}
	
	action empty_diff {
		#if LOG_ACTIONS
			NSLog( @"  EMPTY DIFF" );
		#endif
	}
	
	action add_line {
		[curHunk addLine:[[DiffLine alloc] initWithString:[self copyMarkedString]]];
	}

	action enter_diff {
		#if LOG_ACTIONS
			NSLog( @"begin_diff" );
		#endif
		diff = [[Diff alloc] init];
	}
	
	action exit_diff {
		#if LOG_ACTIONS
			NSLog( @"end_diff" );
		#endif
	}
	
	action enter_hunk {
		#if LOG_ACTIONS
			NSLog( @"  begin_hunk" );
		#endif
		curHunk = [[Hunk alloc] init];
	}
	
	action pop_hunk_spec {
		[curHunk setNewExtent:[[stack popObject] intValue]];
		[curHunk setNewFirstLine:[[stack popObject] intValue]];
		[curHunk setOldExtent:[[stack popObject] intValue]];
		[curHunk setOldFirstLine:[[stack popObject] intValue]];
	}
	
	action exit_hunk {
		#if LOG_ACTIONS
			NSLog( @"  end_hunk" );
		#endif
		[diff addHunk:curHunk];
	}
	
	action error {
		char c = *p;
		if( c == '\n' )
		{
			c = '¤';
		}
		
		int i = p - pstart;
	
		NSMutableDictionary *userInfo = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
		[userInfo setValue:[NSString stringWithFormat:@"Error: Character '%c' was not expected in state: %d (char:%d)", c, fcurs, i] forKey:@"message"];
		error = [NSError errorWithDomain:DIFF_PARSER_ERROR_DOMAIN code:1 userInfo:userInfo];
		NSLog( @"Error: '%c' (%x) not expected in at %d:%d whilst in state: %d [%s]", c, c, line, i, fcurs, p );
	}
	
	action track {
		char c = *p;
		if( c == '\n' )
			c = '±';
		NSLog( @"Tracking %d -> '%c' -> %d", fcurs, c, ftargs );
	}
	
### expressions

	nl = '\n' @count_line;

	sp = space - nl;
	lineChar = extend - '\n';

	number = digit+ >mark %push;
	
	diffLine = ( '\\' lineChar* nl ) | ( ' ' | '-' | '+' ) >mark lineChar* nl @add_line;
	
	separator = '='+ nl %/empty_diff;
	
	revision = ( ( "working copy" %push_minus_one ) | ( "revision " number ) );
	
	oldFile = '---' ( lineChar - '(' )+ '(' revision %pop_old_rev ')' nl;
	newFile = '+++' ( lineChar - '(' )+ '(' revision %pop_new_rev ')' nl;
	
	range = ( '-' | '+' ) number ( ' ' %push_zero @{ fhold; }  | ',' number );
	
	hunkHeader = '@@' sp* range sp+ range sp* '@@' nl @pop_hunk_spec %count_line;
	
	hunkBody = diffLine+;
	
	hunk = hunkHeader >enter_hunk hunkBody %exit_hunk %/exit_hunk;
	
	fileName = ( lineChar+ ) >mark %copy_to_filespec;
	
	fileSpec = "Index:" sp+ fileName nl+;
	
	diffHeader = fileSpec separator;
	
	diffBody = hunk* %exit_diff %/exit_diff;
	
	binaryDiff = 'C' lineChar+ nl lineChar+ nl %binary_diff;
	
	textDiff = oldFile newFile diffBody;
	
	emptyDiff = ( any - ['-'|'C'] @{ fhold; } )? %empty_diff;
	
	diff = diffHeader >enter_diff ( binaryDiff | textDiff | emptyDiff );
	
	property = 'Name' ':' sp lineChar+ nl lineChar+ nl;
 	properties = 'Property changes on' ':' sp fileName nl '_'+ nl property+ nl?;
	
	main := diff? nl* properties?;
}%%	

@implementation DiffParser

%% write data;

- (NSString*)copyMarkedString
{
	assert( p );
	assert( pmark );
	
	int size = p - pmark;
	assert( size > 0 );
	
	char* buffer = malloc( ( size + 1 ) * sizeof(char) );
	assert( buffer );
	
	memset( buffer, 0x00, size + 1 );
	strncpy( buffer, pmark, size );
	if( *( buffer + size ) == '\n' )
		*( buffer + size ) = 0x00; // Jettison trailing '\n'
		
	NSString* content = [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
	free( buffer );
	return content;
}

- (id)init
{
	if ((self = [super init]) != nil) {
		stack = [[Stack alloc] init];
		line = 1;
		error = nil;
	
		%% write init;
	}
	return self;
}

- (void)dealloc
{
	[stack release];
	[super dealloc];
}

- (void)finish
{
	%% write eof;
}

- (Diff *)diff:(NSString *)__content error:(NSError **)__error
{
	p = pstart = [__content UTF8String];
	const char* pe = p + [__content length];

	%% write exec;
	
	[self finish];
	
	if( cs == DiffParser_error )
	{
		NSLog( @"Parser finished with an error." );
	}
	
	if( __error != nil )
	{
		*__error = error;
	}
	
	return diff;
}

@end
