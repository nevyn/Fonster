#import "TCAppDelegate.h"
#import "TCWindowManager.h"
#import "TCWindow.h"

/*
    yess:
    State restoration
    Window titles
    Windows that can't be out of bounds
    Tabs
    Maximize
    Minimize to tab along bottom
    Cycle windows/list of windows/WSO
    Text editor widget
    File browser
    Navigation controller as root of every window
    nicer window widget icons
    Keyboard shortcuts/navigation (switch windows, close, min/max, ...)
 
    eh:
    Exposé
    Spaces :D
    Desktop contents - app icons and file systems
    Desktop exposé
    terminal :P
    pods-based plugin system for apps (like SPFeature)
    drag and drop
*/

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
