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
    [self.window makeKeyAndVisible];
    
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Bristle Grass.jpg"]];
    bg.frame = _window.bounds;
    bg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    bg.contentMode = UIViewContentModeScaleAspectFill;
    [self.window addSubview:bg];
    self.window.backgroundColor = [UIColor whiteColor];

    
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeSystem];
    [plus addTarget:self action:@selector(newWindow) forControlEvents:UIControlEventTouchUpInside];
    [plus setTitle:@"+" forState:0];
    plus.frame = CGRectMake(50, 50, 50, 50);
    [self.window addSubview:plus];
    return YES;
}

// TODO: Make a UIViewController container that contains "windows" instead, with a single UIWindow in-app

- (IBAction)newWindow
{
    TCWindow *w = [[TCWindow alloc] initWithFrame:CGRectMake(50, 50, 300, 400)];
    w.backgroundColor = [UIColor grayColor];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TCBrowser" bundle:nil];
    w.rootViewController = [storyboard instantiateInitialViewController];
    [_wm showWindow:w];
}
@end
