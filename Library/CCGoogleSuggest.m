#import "CCGoogleSuggest.h"
#import "CCGoogleSuggestResult.h"

static NSString *const CCGoogleSuggestServiceURL = @"http://suggestqueries.google.com/complete/search?output=toolbar&q=";

@interface CCGoogleSuggest () <NSXMLParserDelegate>
@property(strong) NSMutableArray *itemsInProgress;
@property(strong) NSString *currentSearchTerm;
@property(strong) NSString *currentTermScore;
@end

@implementation CCGoogleSuggest

#pragma mark Public API

+ (void) suggestionsForQuery: (NSString*) query completion: (CCGoogleSuggestHandler) completion
{
    if (!completion) {
        completion = ^(NSArray *results, NSError *error) {};
    }

    NSURL *suggestURL = [NSURL URLWithString:
        [CCGoogleSuggestServiceURL stringByAppendingString:
            [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:suggestURL];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        NSHTTPURLResponse *responseInfo = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseInfo error:&error];
        if (!responseData || error) {
            completion(nil, error);
        } else {
            // TODO: This fails for the “ceska” query, maybe some encoding issues?
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseData];
            if (!parser) {
                completion(nil, nil);
                return;
            };
            CCGoogleSuggest *delegate = [[CCGoogleSuggest alloc] init];
            [parser setDelegate:delegate];
            BOOL success = [parser parse];
            if (success) {
                completion([delegate suggestedItemsSortedByPopularity], nil);
            } else {
                completion(nil, [parser parserError]);
            }
        }
    });
}

#pragma mark XML Parsing

/*
http://suggestqueries.google.com/complete/search?output=toolbar&q=foo
<toplevel>
    <CompleteSuggestion>
        <suggestion data="foo"/>
        <num_queries int="42"/>
    </CompleteSuggestion>
</toplevel>
*/

- (void) parserDidStartDocument: (NSXMLParser*) parser
{
    _itemsInProgress = [NSMutableArray array];
}

- (void) parser: (NSXMLParser*) parser didStartElement: (NSString*) elementName
    namespaceURI: (NSString*) namespaceURI qualifiedName: (NSString*) qName
    attributes: (NSDictionary*) attributeDict
{
    if ([elementName isEqualToString:@"suggestion"]) {
        _currentSearchTerm = attributeDict[@"data"];
    } else if ([elementName isEqualToString:@"num_queries"]) {
        _currentTermScore = attributeDict[@"int"];
    }
}

- (void) parser: (NSXMLParser*) parser didEndElement: (NSString*) elementName
    namespaceURI: (NSString*) namespaceURI qualifiedName: (NSString*) qName
{
    if ([elementName isEqualToString:@"CompleteSuggestion"]) {
        if (_currentSearchTerm && _currentTermScore) {
            [_itemsInProgress addObject:[CCGoogleSuggestResult
                resultWithQuery:_currentSearchTerm
                score:@([_currentTermScore longLongValue])]];
        }
    }
}

- (NSArray*) suggestedItemsSortedByPopularity
{
    return [_itemsInProgress sortedArrayUsingComparator:^(id a, id b) {
        return [[b score] compare:[a score]];
    }];
}

@end
