typedef void (^CCGoogleSuggestHandler)(NSArray *results, NSError *error);

@interface CCGoogleSuggest : NSObject

+ (void) suggestionsForQuery: (NSString*) query completion: (CCGoogleSuggestHandler) completion;

@end
