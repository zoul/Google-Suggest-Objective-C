This is a simple library for interfacing with the Google Suggest service. You supply a search term, you get a list of suggested terms along with their popularity back:

    [CCGoogleSuggest suggestionsForQuery:query completion:^(NSArray *results, NSError *error) {
        for (CCGoogleSuggestResult *result in results) {
            NSLog(@"%@: %@", [result query], [result score]);
        }
    }];

See the demo project for details. Suggestions welcome.
