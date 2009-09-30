/*
 *  StatusTableDelegate.h
 *  Diffly
 *
 *  Created by Matt Mower on 04/07/2007.
 *  Copyright 2007 __MyCompanyName__. All rights reserved.
 *
 */

@interface NSObject (StatusTableDelegates)

- (StatusItem *)statusTable:(StatusTable *)table itemAtRow:(int)row;

@end