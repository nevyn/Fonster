#import "TCAppDelegate.h"
#import "TCWindowManager.h"
#import "TCWindow.h"
#import "TCDesktopViewController.h"
#import "TCDirectoryViewController.h"
#import "TCTextViewerController.h"

/*
    yess:
    State restoration
    Windows that can't be out of bounds
    Tabs
    Minimize to tab along bottom
    Cycle windows/list of windows/WSO
    File browser
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
    
    done:
    Text editor widget √
    Maximize √
    Window titles √
    Navigation controller as root of every window √
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
    [_wm.desktop addIcon:[UIImage imageNamed:@"TextEdit"] title:@"TextEdit" target:self action:@selector(newEditor)];
	
	[self newDocumentsFinder];
    
    return YES;
}

- (IBAction)newBrowser
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TCBrowser" bundle:nil];
    TCWindow *w = [[TCWindow alloc] initWithRootViewController:[storyboard instantiateInitialViewController]];
    [_wm showWindow:w];
}

- (void)showFinderForPath:(NSURL*)path
{
    TCDirectoryViewController *dir = [[TCDirectoryViewController alloc] initWithURL:path error:NULL];
    dir.delegate = self;
    TCWindow *w = [[TCWindow alloc] initWithRootViewController:dir];
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
    TCWindow *w = [[TCWindow alloc] initWithRootViewController:document];
    [_wm showWindow:w];
    return NO;
}

- (IBAction)newEditor
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create document named" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != [alertView firstOtherButtonIndex])
        return;
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[alertView textFieldAtIndex:0].text];
    if([[path pathExtension] isEqual:@""])
        path = [path stringByAppendingPathExtension:@"txt"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path contents:[NSData data] attributes:nil];
    }
    TCTextViewerController *vc = [[TCTextViewerController alloc] initWithURL:[NSURL fileURLWithPath:path] error:NULL];
    TCWindow *window = [[TCWindow alloc] initWithRootViewController:vc];
    [_wm showWindow:window];
}

@end
