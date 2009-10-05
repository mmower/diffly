//
//  Diff+HTMLFormatting.m
//  Diffly
//
//  Created by Matt Mower on 03/02/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import "Diff+HTMLFormatting.h"

@implementation Diff (HTMLFormatting)

- (NSString *)formatAsHTMLPageWithStylesheet:(NSString *)styleSheetURL
{
	return [NSString stringWithFormat:@"<html>\n<head>\n<link rel='stylesheet' media='screen' type='text/css' href='file://%@'/>\n</head>\n<body>\n%@\n</body>\n</html>",
		styleSheetURL,
		[self toHTML]];
}

- (NSString *)formatAsLinkedHTMLUsingStyleSheet:(NSString *)styleSheetURL path:(NSString *)path
{
	return [NSString stringWithFormat:@"<html>\n<head>\n<link rel='stylesheet' media='screen' type='text/css' href='file://%@'/>\n</head>\n<body>\n%@\n</body>\n</html>",
		styleSheetURL,
		[self toHTMLwithUrlBase:@"txmt://open?url=file://" path:path]];
}

@end
