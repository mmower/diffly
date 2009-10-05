//
//  Stack.h
//  SvnDiffParser
//
//  Created by Matt Mower on 05/01/2007.
//  Copyright 2007 Matt Mower. See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>


@interface Stack : NSObject {
	NSMutableArray	*contents;
}

- (void)pushObject:(id)obj;
- (id)popObject;

@end
