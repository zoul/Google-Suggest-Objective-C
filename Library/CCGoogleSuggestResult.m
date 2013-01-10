#import "CCGoogleSuggestResult.h"

static NSString *const GoogleSearchURL = @"http://www.google.com/search?q=";

@implementation CCGoogleSuggestResult

- (id) initWithQuery: (NSString*) query score: (NSNumber*) score
{
    self = [super init];
    if (query && score) {
        _query = query;
        _score = score;
        NSString *searchString = [GoogleSearchURL stringByAppendingString:
            [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        _searchURL = [NSURL URLWithString:searchString];
        return self;
    } else {
        return nil;
    }
}

+ (id) resultWithQuery: (NSString*) query score: (NSNumber*) score
{
    return [[self alloc] initWithQuery:query score:score];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"<%@ 0x%p: %@/%@>", [self class], self, _query, _score];
}

@end
