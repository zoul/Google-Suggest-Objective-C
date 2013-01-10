#import "CCWebViewController.h"

@implementation CCWebViewController

- (void) loadView
{
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:appFrame];
    [self setView:webView];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
    [(UIWebView*) [self view] loadRequest:[NSURLRequest requestWithURL:_initialURL]];
}

@end
