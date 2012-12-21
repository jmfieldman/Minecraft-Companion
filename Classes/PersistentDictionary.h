//
//  PersistentDictionary.h
//  

#import <Foundation/Foundation.h>


@interface PersistentDictionary : NSObject {
	NSString *fileName;
	NSString *filePath;
	NSMutableDictionary *dictionary;
}

@property (nonatomic, readonly) NSString   *fileName;
@property (nonatomic, readonly) NSString   *filePath;
@property (nonatomic, readonly) NSMutableDictionary *dictionary;

+ (PersistentDictionary*) dictionaryWithName:(NSString*)name;
+ (void) saveAllDictionaries;
+ (void) clearDictionaryMemCache;
+ (void) clearDictionaryDiskCache;

- (id) initWithFileName:(NSString*)name;
- (void) saveToFile;

@end
