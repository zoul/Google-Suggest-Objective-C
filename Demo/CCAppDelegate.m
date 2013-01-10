#import "CCAppDelegate.h"
#import "CCSearchController.h"
#import "CCWebViewController.h"

@implementation CCAppDelegate

- (BOOL) application: (UIApplication*) application didFinishLaunchingWithOptions: (NSDictionary*) launchOptions
{
    CCSearchController *searchController = [[CCSearchController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:searchController];

    [searchController setCompletion:^(NSURL *targetURL) {
        CCWebViewController *webController = [[CCWebViewController alloc] initWithNibName:nil bundle:nil];
        [webController setInitialURL:targetURL];
        [navigation pushViewController:webController animated:YES];
    }];

    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [_window setRootViewController:navigation];
    [_window makeKeyAndVisible];

    return YES;
}

@end
