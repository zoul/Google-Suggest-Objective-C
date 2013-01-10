#import "CCSearchController.h"
#import "CCGoogleSuggestDataSource.h"

@interface CCSearchController () <UISearchBarDelegate, UITableViewDelegate>
@property(strong) IBOutlet UITableView *tableView;
@property(strong) IBOutlet UISearchBar *searchBar;
@property(strong) CCGoogleSuggestDataSource *dataSource;
@end

@implementation CCSearchController

- (void) viewDidLoad
{
    [super viewDidLoad];
    [_searchBar setDelegate:self];
    [self setDataSource:[[CCGoogleSuggestDataSource alloc] init]];
    [_tableView setDataSource:_dataSource];
    [_tableView setDelegate:self];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:animated];
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear:animated];
    [_searchBar becomeFirstResponder];
}

#pragma mark UISearchBarDelegate

- (void) searchBar: (UISearchBar*) searchBar textDidChange: (NSString*) newText
{
    [_dataSource loadSuggestionsForQuery:newText completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    }];
}

#pragma mark UITableViewDelegate

- (void) tableView: (UITableView*) tableView didSelectRowAtIndexPath: (NSIndexPath*) indexPath
{
    if (_completion) {
        [_tableView deselectRowAtIndexPath:indexPath animated:NO];
        _completion([_dataSource suggestionURLAtIndexPath:indexPath]);
    }
}

@end
