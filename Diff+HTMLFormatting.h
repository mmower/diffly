//
//  Diff+HTMLFormatting.h
//  Diffly
//
//  Created by Matt Mower on 03/02/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Diff.h"

@interface Diff (HTMLFormatting)

- (NSString *)formatAsHTMLPageWithStylesheet:(NSString *)styleSheetURL;
- (NSString *)formatAsLinkedHTMLUsingStyleSheet:(NSString *)styleSheetURL path:(NSString *)path;

@end
