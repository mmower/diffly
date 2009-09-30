
#line 1 "DiffParser.m.rl"
#import "DiffParser.h"
#import "Diff.h"
#import "Hunk.h"
#import "Stack.h"
#import "DiffLine.h"

#import "assert.h"

//#define LOG_MARK 1
//#define LOG_ACTIONS 1


#line 205 "DiffParser.m.rl"
	

@implementation DiffParser


#line 22 "DiffParser.m.c"
static const char _DiffParser_actions[] = {
	0, 1, 0, 1, 1, 1, 2, 1, 
	4, 1, 8, 1, 9, 1, 11, 1, 
	12, 1, 13, 2, 0, 4, 2, 0, 
	10, 2, 0, 14, 2, 1, 6, 2, 
	1, 7, 2, 1, 16, 2, 3, 6, 
	2, 3, 7, 2, 5, 0, 2, 8, 
	0, 2, 9, 0, 2, 12, 0, 2, 
	15, 12, 2, 15, 13, 3, 15, 12, 
	0
};

static const unsigned char _DiffParser_key_offsets[] = {
	0, 0, 1, 2, 3, 4, 5, 6, 
	7, 8, 9, 10, 11, 12, 13, 14, 
	15, 16, 17, 18, 19, 23, 24, 25, 
	26, 28, 29, 30, 31, 32, 33, 37, 
	38, 39, 40, 41, 42, 43, 44, 45, 
	46, 50, 54, 55, 57, 59, 60, 62, 
	64, 66, 67, 68, 69, 70, 71, 72, 
	73, 74, 76, 79, 80, 81, 82, 83, 
	85, 87, 89, 90, 91, 92, 93, 94, 
	95, 96, 97, 99, 102, 103, 104, 110, 
	112, 116, 120, 126, 128, 132, 137, 142, 
	143, 144, 148, 149, 150, 152, 159, 161, 
	167, 168, 169, 170, 171, 172, 173, 174, 
	175, 176, 177, 178, 179, 180, 181, 182, 
	183, 184, 185, 186, 187, 188, 189, 190, 
	191, 192, 193, 194, 195, 199, 202, 204, 
	206, 206, 212, 214, 217, 220, 227, 229
};

static const char _DiffParser_trans_keys[] = {
	114, 111, 112, 101, 114, 116, 121, 32, 
	99, 104, 97, 110, 103, 101, 115, 32, 
	111, 110, 58, 9, 32, 11, 13, 10, 
	10, 95, 10, 95, 78, 97, 109, 101, 
	58, 9, 32, 11, 13, 10, 10, 10, 
	10, 110, 100, 101, 120, 58, 9, 32, 
	11, 13, 10, 32, 9, 13, 10, 10, 
	61, 10, 61, 45, 10, 40, 10, 40, 
	114, 119, 101, 118, 105, 115, 105, 111, 
	110, 32, 48, 57, 41, 48, 57, 10, 
	43, 43, 43, 10, 40, 10, 40, 114, 
	119, 101, 118, 105, 115, 105, 111, 110, 
	32, 48, 57, 41, 48, 57, 10, 64, 
	9, 32, 43, 45, 11, 13, 48, 57, 
	32, 44, 48, 57, 9, 32, 11, 13, 
	9, 32, 43, 45, 11, 13, 48, 57, 
	32, 44, 48, 57, 9, 32, 64, 11, 
	13, 9, 32, 64, 11, 13, 64, 10, 
	32, 43, 45, 92, 10, 10, 48, 57, 
	9, 32, 64, 11, 13, 48, 57, 48, 
	57, 9, 32, 11, 13, 48, 57, 111, 
	114, 107, 105, 110, 103, 32, 99, 111, 
	112, 121, 41, 111, 114, 107, 105, 110, 
	103, 32, 99, 111, 112, 121, 41, 10, 
	10, 10, 10, 10, 32, 9, 13, 10, 
	73, 80, 10, 80, 10, 78, 10, 39, 
	45, 67, 80, 124, 10, 80, 10, 45, 
	80, 10, 64, 80, 10, 32, 43, 45, 
	64, 80, 92, 10, 80, 10, 80, 114, 
	0
};

static const char _DiffParser_single_lengths[] = {
	0, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 2, 1, 1, 1, 
	2, 1, 1, 1, 1, 1, 2, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	2, 2, 1, 2, 2, 1, 2, 2, 
	2, 1, 1, 1, 1, 1, 1, 1, 
	1, 0, 1, 1, 1, 1, 1, 2, 
	2, 2, 1, 1, 1, 1, 1, 1, 
	1, 1, 0, 1, 1, 1, 4, 0, 
	2, 2, 4, 0, 2, 3, 3, 1, 
	1, 4, 1, 1, 0, 3, 0, 2, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 2, 3, 2, 2, 
	0, 6, 2, 3, 3, 7, 2, 3
};

static const char _DiffParser_range_lengths[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 1, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 1, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	1, 1, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 1, 1, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 1, 1, 0, 0, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 0, 
	0, 0, 0, 0, 1, 2, 1, 2, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 1, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0
};

static const short _DiffParser_index_offsets[] = {
	0, 0, 2, 4, 6, 8, 10, 12, 
	14, 16, 18, 20, 22, 24, 26, 28, 
	30, 32, 34, 36, 38, 42, 44, 46, 
	48, 51, 53, 55, 57, 59, 61, 65, 
	67, 69, 71, 73, 75, 77, 79, 81, 
	83, 87, 91, 93, 96, 99, 101, 104, 
	107, 110, 112, 114, 116, 118, 120, 122, 
	124, 126, 128, 131, 133, 135, 137, 139, 
	142, 145, 148, 150, 152, 154, 156, 158, 
	160, 162, 164, 166, 169, 171, 173, 179, 
	181, 185, 189, 195, 197, 201, 206, 211, 
	213, 215, 220, 222, 224, 226, 232, 234, 
	239, 241, 243, 245, 247, 249, 251, 253, 
	255, 257, 259, 261, 263, 265, 267, 269, 
	271, 273, 275, 277, 279, 281, 283, 285, 
	287, 289, 291, 293, 295, 299, 303, 306, 
	309, 310, 317, 320, 324, 328, 336, 339
};

static const unsigned char _DiffParser_indicies[] = {
	0, 1, 2, 1, 3, 1, 4, 1, 
	5, 1, 6, 1, 7, 1, 8, 1, 
	9, 1, 10, 1, 11, 1, 12, 1, 
	13, 1, 14, 1, 15, 1, 16, 1, 
	17, 1, 18, 1, 19, 1, 20, 20, 
	20, 1, 1, 21, 23, 22, 24, 1, 
	25, 24, 1, 26, 1, 27, 1, 28, 
	1, 29, 1, 30, 1, 31, 31, 31, 
	1, 1, 32, 33, 32, 1, 34, 35, 
	34, 36, 1, 37, 1, 38, 1, 39, 
	1, 40, 1, 41, 41, 41, 1, 1, 
	43, 43, 42, 45, 44, 46, 47, 1, 
	48, 47, 1, 49, 1, 1, 1, 50, 
	1, 51, 50, 52, 53, 1, 54, 1, 
	55, 1, 56, 1, 57, 1, 58, 1, 
	59, 1, 60, 1, 61, 1, 62, 1, 
	63, 64, 1, 65, 1, 66, 1, 67, 
	1, 68, 1, 1, 1, 69, 1, 70, 
	69, 71, 72, 1, 73, 1, 74, 1, 
	75, 1, 76, 1, 77, 1, 78, 1, 
	79, 1, 80, 1, 81, 1, 82, 83, 
	1, 84, 1, 85, 1, 85, 85, 86, 
	86, 85, 1, 87, 1, 88, 89, 90, 
	1, 91, 91, 91, 1, 92, 92, 93, 
	93, 92, 1, 94, 1, 95, 96, 97, 
	1, 98, 98, 99, 98, 1, 100, 100, 
	101, 100, 1, 102, 1, 103, 1, 104, 
	104, 104, 105, 1, 107, 106, 109, 108, 
	110, 1, 111, 111, 113, 111, 112, 1, 
	114, 1, 115, 115, 115, 116, 1, 117, 
	1, 118, 1, 119, 1, 120, 1, 121, 
	1, 122, 1, 123, 1, 124, 1, 125, 
	1, 126, 1, 127, 1, 128, 1, 129, 
	1, 130, 1, 131, 1, 132, 1, 133, 
	1, 134, 1, 135, 1, 136, 1, 137, 
	1, 138, 1, 139, 1, 140, 1, 1, 
	141, 142, 141, 1, 143, 144, 143, 45, 
	43, 43, 42, 145, 146, 147, 1, 145, 
	147, 1, 148, 26, 1, 1, 150, 1, 
	151, 152, 153, 1, 149, 154, 155, 1, 
	154, 156, 155, 1, 157, 158, 159, 1, 
	160, 161, 161, 161, 162, 163, 108, 1, 
	164, 165, 1, 154, 155, 0, 1, 0
};

static const unsigned char _DiffParser_trans_targs[] = {
	2, 0, 3, 4, 5, 6, 7, 8, 
	9, 10, 11, 12, 13, 14, 15, 16, 
	17, 18, 19, 20, 21, 22, 22, 23, 
	24, 25, 26, 27, 28, 29, 30, 31, 
	32, 33, 34, 127, 36, 37, 38, 39, 
	40, 41, 42, 124, 42, 43, 43, 44, 
	129, 46, 47, 48, 49, 108, 50, 51, 
	52, 53, 54, 55, 56, 57, 58, 59, 
	58, 60, 61, 62, 63, 64, 65, 66, 
	96, 67, 68, 69, 70, 71, 72, 73, 
	74, 75, 76, 75, 132, 78, 79, 80, 
	81, 94, 80, 82, 82, 83, 84, 85, 
	92, 84, 86, 87, 86, 87, 88, 89, 
	90, 91, 90, 133, 91, 133, 93, 86, 
	93, 87, 95, 82, 95, 97, 98, 99, 
	100, 101, 102, 103, 104, 105, 106, 107, 
	76, 109, 110, 111, 112, 113, 114, 115, 
	116, 117, 118, 119, 59, 121, 122, 123, 
	134, 126, 35, 1, 128, 130, 130, 131, 
	120, 135, 126, 1, 45, 126, 77, 1, 
	126, 90, 77, 1, 126, 1
};

static const char _DiffParser_trans_actions[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 7, 0, 43, 
	0, 1, 0, 0, 0, 0, 0, 0, 
	0, 1, 0, 1, 0, 0, 0, 0, 
	0, 0, 7, 7, 0, 43, 1, 0, 
	1, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 7, 28, 
	0, 1, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 7, 31, 0, 1, 0, 0, 7, 
	34, 3, 0, 5, 0, 0, 7, 34, 
	3, 0, 5, 5, 0, 0, 0, 25, 
	19, 1, 0, 22, 0, 1, 7, 3, 
	0, 3, 7, 3, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	40, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 37, 0, 1, 0, 
	1, 1, 13, 0, 1, 0, 49, 0, 
	0, 11, 49, 11, 0, 52, 17, 15, 
	61, 7, 58, 55, 46, 9
};

static const char _DiffParser_eof_actions[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 11, 11, 11, 15, 55, 9, 11
};

static const int DiffParser_start = 125;
static const int DiffParser_first_final = 125;
static const int DiffParser_error = 0;

static const int DiffParser_en_main = 125;


#line 210 "DiffParser.m.rl"

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
	
		
#line 300 "DiffParser.m.c"
	{
	cs = DiffParser_start;
	}

#line 240 "DiffParser.m.rl"
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
	
#line 319 "DiffParser.m.c"

#line 253 "DiffParser.m.rl"
}

- (Diff *)diff:(NSString *)__content error:(NSError **)__error
{
	p = pstart = [__content UTF8String];
	const char* pe = p + [__content length];

	
#line 330 "DiffParser.m.c"
	{
	int _klen;
	unsigned int _trans;
	const char *_acts;
	unsigned int _nacts;
	const char *_keys;

	if ( p == pe )
		goto _test_eof;
	if ( cs == 0 )
		goto _out;
_resume:
	_keys = _DiffParser_trans_keys + _DiffParser_key_offsets[cs];
	_trans = _DiffParser_index_offsets[cs];

	_klen = _DiffParser_single_lengths[cs];
	if ( _klen > 0 ) {
		const char *_lower = _keys;
		const char *_mid;
		const char *_upper = _keys + _klen - 1;
		while (1) {
			if ( _upper < _lower )
				break;

			_mid = _lower + ((_upper-_lower) >> 1);
			if ( (*p) < *_mid )
				_upper = _mid - 1;
			else if ( (*p) > *_mid )
				_lower = _mid + 1;
			else {
				_trans += (_mid - _keys);
				goto _match;
			}
		}
		_keys += _klen;
		_trans += _klen;
	}

	_klen = _DiffParser_range_lengths[cs];
	if ( _klen > 0 ) {
		const char *_lower = _keys;
		const char *_mid;
		const char *_upper = _keys + (_klen<<1) - 2;
		while (1) {
			if ( _upper < _lower )
				break;

			_mid = _lower + (((_upper-_lower) >> 1) & ~1);
			if ( (*p) < _mid[0] )
				_upper = _mid - 2;
			else if ( (*p) > _mid[1] )
				_lower = _mid + 2;
			else {
				_trans += ((_mid - _keys)>>1);
				goto _match;
			}
		}
		_trans += _klen;
	}

_match:
	_trans = _DiffParser_indicies[_trans];
	cs = _DiffParser_trans_targs[_trans];

	if ( _DiffParser_trans_actions[_trans] == 0 )
		goto _again;

	_acts = _DiffParser_actions + _DiffParser_trans_actions[_trans];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 )
	{
		switch ( *_acts++ )
		{
	case 0:
#line 29 "DiffParser.m.rl"
	{
		line += 1;
	}
	break;
	case 1:
#line 33 "DiffParser.m.rl"
	{
		NSString* item = [self copyMarkedString];
		#if LOG_ACTIONS
			NSLog( @"    Pushing: '%@'", item );
		#endif
		[stack pushObject:item];
	}
	break;
	case 2:
#line 41 "DiffParser.m.rl"
	{
		#if LOG_ACTIONS
			NSLog( @"    Pushing: 0" );
		#endif
		[stack pushObject:@"0"];
	}
	break;
	case 3:
#line 48 "DiffParser.m.rl"
	{
		#if LOG_ACTIONS
			NSLog( @"    Pushing: -1" );
		#endif
		[stack pushObject:@"-1"];
	}
	break;
	case 4:
#line 55 "DiffParser.m.rl"
	{
		#if LOG_MARK
			NSLog( @"Marking @ %p '%c'", p, *p );
		#endif
		pmark = p;
	}
	break;
	case 5:
#line 62 "DiffParser.m.rl"
	{
		NSString* fileSpec = [self copyMarkedString];
		#if LOG_ACTIONS
			NSLog( @"  filespec: %@", fileSpec );
		#endif
		[diff setFile:fileSpec];
	}
	break;
	case 6:
#line 70 "DiffParser.m.rl"
	{
		int rev = [[stack popObject] intValue];
		#if LOG_ACTIONS
			NSLog( @"  oldRev: %d", rev );
		#endif
		[diff setOldRev:rev];
	}
	break;
	case 7:
#line 78 "DiffParser.m.rl"
	{
		int rev = [[stack popObject] intValue];
		#if LOG_ACTIONS
			NSLog( @"  newRev: %d", rev );
		#endif
		[diff setNewRev:rev];
	}
	break;
	case 8:
#line 86 "DiffParser.m.rl"
	{
		#if LOG_ACTIONS
			NSLog( @"  BINARY DIFF" );
		#endif
		[diff setIsBinary:YES];
	}
	break;
	case 9:
#line 93 "DiffParser.m.rl"
	{
		#if LOG_ACTIONS
			NSLog( @"  EMPTY DIFF" );
		#endif
	}
	break;
	case 10:
#line 99 "DiffParser.m.rl"
	{
		[curHunk addLine:[[DiffLine alloc] initWithString:[self copyMarkedString]]];
	}
	break;
	case 11:
#line 103 "DiffParser.m.rl"
	{
		#if LOG_ACTIONS
			NSLog( @"begin_diff" );
		#endif
		diff = [[Diff alloc] init];
	}
	break;
	case 12:
#line 110 "DiffParser.m.rl"
	{
		#if LOG_ACTIONS
			NSLog( @"end_diff" );
		#endif
	}
	break;
	case 13:
#line 116 "DiffParser.m.rl"
	{
		#if LOG_ACTIONS
			NSLog( @"  begin_hunk" );
		#endif
		curHunk = [[Hunk alloc] init];
	}
	break;
	case 14:
#line 123 "DiffParser.m.rl"
	{
		[curHunk setNewExtent:[[stack popObject] intValue]];
		[curHunk setNewFirstLine:[[stack popObject] intValue]];
		[curHunk setOldExtent:[[stack popObject] intValue]];
		[curHunk setOldFirstLine:[[stack popObject] intValue]];
	}
	break;
	case 15:
#line 130 "DiffParser.m.rl"
	{
		#if LOG_ACTIONS
			NSLog( @"  end_hunk" );
		#endif
		[diff addHunk:curHunk];
	}
	break;
	case 16:
#line 177 "DiffParser.m.rl"
	{ p--; }
	break;
#line 548 "DiffParser.m.c"
		}
	}

_again:
	if ( cs == 0 )
		goto _out;
	if ( ++p != pe )
		goto _resume;
	_test_eof: {}
	if ( p == eof )
	{
	const char *__acts = _DiffParser_actions + _DiffParser_eof_actions[cs];
	unsigned int __nacts = (unsigned int) *__acts++;
	while ( __nacts-- > 0 ) {
		switch ( *__acts++ ) {
	case 8:
#line 86 "DiffParser.m.rl"
	{
		#if LOG_ACTIONS
			NSLog( @"  BINARY DIFF" );
		#endif
		[diff setIsBinary:YES];
	}
	break;
	case 9:
#line 93 "DiffParser.m.rl"
	{
		#if LOG_ACTIONS
			NSLog( @"  EMPTY DIFF" );
		#endif
	}
	break;
	case 12:
#line 110 "DiffParser.m.rl"
	{
		#if LOG_ACTIONS
			NSLog( @"end_diff" );
		#endif
	}
	break;
	case 15:
#line 130 "DiffParser.m.rl"
	{
		#if LOG_ACTIONS
			NSLog( @"  end_hunk" );
		#endif
		[diff addHunk:curHunk];
	}
	break;
#line 598 "DiffParser.m.c"
		}
	}
	}

	_out: {}
	}

#line 261 "DiffParser.m.rl"
	
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
