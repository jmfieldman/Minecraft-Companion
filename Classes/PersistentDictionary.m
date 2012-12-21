//
//  PersistentDictionary.m
//  

#import "PersistentDictionary.h"

static NSMutableDictionary *s_dictionaryDictionary = nil;

@implementation PersistentDictionary
@synthesize fileName, filePath, dictionary;


+ (PersistentDictionary*) dictionaryWithName:(NSString*)name {
	if (!s_dictionaryDictionary) {
		s_dictionaryDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];		
	}
	
	PersistentDictionary *dic = [s_dictionaryDictionary valueForKey:name];
	if (!dic) {
		dic = [[[PersistentDictionary alloc] initWithFileName:name] autorelease];
		if (dic) [s_dictionaryDictionary setValue:dic forKey:name];
	}
	return dic;
}



+ (void) saveAllDictionaries {
	if (!s_dictionaryDictionary) return;
	NSArray *dictionaries = [s_dictionaryDictionary allValues];
	for (int i = 0; i < [dictionaries count]; i++) {
		PersistentDictionary *dic = [dictionaries objectAtIndex:i];
		[dic saveToFile];
	}
}

+ (void) clearDictionaryMemCache {
	[s_dictionaryDictionary release];
	s_dictionaryDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
}


+ (void) clearDictionaryDiskCache {
	
	/* Let's create the full path to the dictionary */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/dics", [paths objectAtIndex:0]];

	if ([fileManager fileExistsAtPath:documentsDirectory]) {
		[fileManager removeItemAtPath:documentsDirectory error:nil];
	}
	
}


- (id) initWithFileName:(NSString*)name {
	if (self = [super init]) {
		fileName = [name copy];
		
		/* Let's create the full path to the dictionary */
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [NSString stringWithFormat:@"%@/dics", [paths objectAtIndex:0]];
		[fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
		NSString *dicFilePath = [documentsDirectory stringByAppendingPathComponent:name];
		filePath = [dicFilePath copy];
				
		/* If the file exists, let's reconstruct the dictionary from the file */
		if ([fileManager fileExistsAtPath:dicFilePath]) {
			NSData *propListData = [NSData dataWithContentsOfFile:filePath];
			if (propListData) {
				NSPropertyListFormat format;
				dictionary = [[NSPropertyListSerialization propertyListFromData:propListData mutabilityOption:kCFPropertyListMutableContainersAndLeaves format:&format errorDescription:nil] retain];
			}
		}
	
		/* Now create the dictionary if it's still nil */
		if (!dictionary) {
			dictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
		}
		NSLog(@"LTPersistentDictionary [%@]", name);
	}
	return self;
}



- (void) saveToFile {
	NSData *propListData = [NSPropertyListSerialization dataFromPropertyList:dictionary format:NSPropertyListBinaryFormat_v1_0 errorDescription:nil];
	[propListData writeToFile:filePath atomically:YES];
}



- (void) dealloc {
	[fileName release];
	[filePath release];
	[dictionary release];
	[super dealloc];
}

@end

