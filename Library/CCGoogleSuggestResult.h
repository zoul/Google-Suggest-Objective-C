@interface CCGoogleSuggestResult : NSObject

@property(strong, readonly) NSString *query;
@property(assign, readonly) NSNumber *score;
@property(strong, readonly) NSURL *searchURL;

+ (id) resultWithQuery: (NSString*) query score: (NSNumber*) score;

@end
