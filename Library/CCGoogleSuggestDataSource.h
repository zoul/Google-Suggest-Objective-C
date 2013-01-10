@interface CCGoogleSuggestDataSource : NSObject <UITableViewDataSource>

- (void) loadSuggestionsForQuery: (NSString*) query completion: (dispatch_block_t) completion;
- (NSURL*) suggestionURLAtIndexPath: (NSIndexPath*) indexPath;

@end
