#import "TCAppDelegate.h"
#import "TCWindowManager.h"
#import "TCWindow.h"
#import "TCDesktopViewController.h"
#import "TCDirectoryViewController.h"

/*
    yess:
    Maximize
    State restoration
    Window titles
    Windows that can't be out of bounds
    Tabs
    Minimize to tab along bottom
    Cycle windows/list of windows/WSO
    Text editor widget
    File browser
    Navigation controller as root of every window
    nicer window widget icons
    Keyboard shortcuts/navigation (switch windows √, close √, min/max, ...)
    Swipe in from the side to switch between windows
 
    eh:
    Exposé
    Spaces :D
    Desktop contents - app icons and file systems
    Desktop exposé
    terminal :P
    pods-based plugin system for apps (like SPFeature)
    drag and drop
*/

@interface TCAppDelegate () <TCDirectoryViewerControllerDelegate>
@end

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
    
    [_wm.desktop addIcon:[UIImage imageNamed:@"GenericDeviceIcon"] title:[NSString stringWithFormat:@"My %@", [[UIDevice currentDevice] localizedModel]] target:self action:@selector(newRootFinder)];
    [_wm.desktop addIcon:[UIImage imageNamed:@"HomeIcon"] title:@"Me" target:self action:@selector(newDocumentsFinder)];
    [_wm.desktop addIcon:[UIImage imageWithContentsOfFile:@"/Applications/MobileSafari.app/icon@2x~ipad.png"] title:@"Safari" target:self action:@selector(newBrowser)];
    
    return YES;
}

- (IBAction)newBrowser
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TCBrowser" bundle:nil];
    TCWindow *w = [[TCWindow alloc]
        initWithFrame:CGRectMake(50, 50, 300, 400)
        rootViewController:[storyboard instantiateInitialViewController]
    ];
    [_wm showWindow:w];
}

- (void)showFinderForPath:(NSURL*)path
{
    TCDirectoryViewController *dir = [[TCDirectoryViewController alloc] initWithURL:path error:NULL];
    dir.delegate = self;
    TCWindow *w = [[TCWindow alloc]
        initWithFrame:CGRectMake(50, 50, 300, 400)
        rootViewController:dir
    ];
    [_wm showWindow:w];
}

- (IBAction)newRootFinder
{
    [self showFinderForPath:[NSURL fileURLWithPath:@"/"]];
}

- (IBAction)newDocumentsFinder
{
    [self showFinderForPath:[NSURL fileURLWithPath:NSHomeDirectory()]];
}

- (BOOL)directoryViewer:(TCDirectoryViewController*)vc shouldPresentContentViewController:(TCDocumentViewerController*)document
{
    TCWindow *w = [[TCWindow alloc]
        initWithFrame:CGRectMake(50, 50, 300, 400)
        rootViewController:document
    ];
    [_wm showWindow:w];
    return NO;
}
@end
