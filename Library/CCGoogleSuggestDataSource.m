#import "CCGoogleSuggestDataSource.h"
#import "CCGoogleSuggestResult.h"
#import "CCGoogleSuggest.h"

@interface CCGoogleSuggestDataSource ()
@property(strong) dispatch_queue_t reloadQueue;
@property(strong) NSArray *suggestions;
@end

@implementation CCGoogleSuggestDataSource

#pragma mark Initialization

- (id) init
{
    self = [super init];
    _reloadQueue = dispatch_queue_create("com.github.zoul.CCGoogleSuggestDataSource", NULL);
    return self;
}

#pragma mark UITableViewDataSource

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection: (NSInteger) section
{
    return [_suggestions count];
}

- (UITableViewCell*) tableView: (UITableView*) tableView cellForRowAtIndexPath: (NSIndexPath*) indexPath
{
    static NSString *const CellID = @"googleSuggestCellID";
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
    CCGoogleSuggestResult *result = [_suggestions objectAtIndex:[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    [[cell textLabel] setText:[result query]];
    return cell;
}

#pragma mark Controls

- (void) loadSuggestionsForQuery: (NSString*) query completion: (dispatch_block_t) completion
{
    [CCGoogleSuggest suggestionsForQuery:query completion:^(NSArray *results, NSError *error) {
        dispatch_async(_reloadQueue, ^{
            _suggestions = results;
            if (completion) {
                completion();
            }
        });
    }];
}

- (NSURL*) suggestionURLAtIndexPath: (NSIndexPath*) indexPath
{
    return [[_suggestions objectAtIndex:[indexPath row]] searchURL];
}

@end
