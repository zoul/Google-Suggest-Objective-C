typedef void (^CCSearchControllerCompletion)(NSURL *targetURL);

@interface CCSearchController : UIViewController

@property(copy) CCSearchControllerCompletion completion;

@end
