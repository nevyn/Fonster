#import "TCAppDelegate.h"
#import "TCWindowManager.h"
#import "TCWindow.h"

@implementation TCAppDelegate
{
    TCWindowManager *_wm;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    _wm = [TCWindowManager new];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _wm;
    [self.window makeKeyAndVisible];
    
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeSystem];
    [plus addTarget:self action:@selector(newWindow) forControlEvents:UIControlEventTouchUpInside];
    [plus setTitle:@"+" forState:0];
    plus.frame = CGRectMake(50, 50, 50, 50);
    [_wm.view addSubview:plus];
    return YES;
}

- (IBAction)newWindow
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TCBrowser" bundle:nil];
    TCWindow *w = [[TCWindow alloc]
        initWithFrame:CGRectMake(50, 50, 300, 400)
        rootViewController:[storyboard instantiateInitialViewController]
    ];
    [_wm showWindow:w];
}
@end
