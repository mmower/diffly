/*
 * Tsai.h
 *
 * foreach macro by Michael Tsai
 * http://mjtsai.com/blog/2003/12/08/cocoa_enumeration
 *
 */

#define foreachGetEnumerator(c) \
([c respondsToSelector:@selector(objectEnumerator)] ? \
 [c objectEnumerator] : \
 c)

#define foreacht(type, object, collection) \
for ( id foreachCollection = collection; \
      foreachCollection; \
      foreachCollection = nil ) \
for ( id foreachEnum = foreachGetEnumerator(foreachCollection); \
	  foreachEnum; \
	  foreachEnum = nil ) \
for ( IMP foreachNext = [foreachEnum methodForSelector:@selector(nextObject)]; \
	  foreachNext; \
	  foreachNext = NULL ) \
for ( type object = foreachNext(foreachEnum, @selector(nextObject)); \
	  object; \
	  object = foreachNext(foreachEnum, @selector(nextObject)) )

#define foreach(object, collection) foreacht(id, object, (collection))