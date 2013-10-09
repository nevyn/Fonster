#import "TCAppDelegate.h"
#import "TCWindow.h"

@implementation TCAppDelegate
{
    NSMutableArray *_windows;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    _windows = [NSMutableArray new];
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

- (IBAction)newWindow
{
    TCWindow *w = [[TCWindow alloc] initWithFrame:CGRectMake(50, 50, 300, 400)];
    w.backgroundColor = [UIColor grayColor];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TCBrowser" bundle:nil];
    w.rootViewController = [storyboard instantiateInitialViewController];
    __weak id weakSelf = self; __weak TCWindow *weakW = w;
    w.closer = ^{
        [UIView animateWithDuration:0.65 delay:0 usingSpringWithDamping:1 initialSpringVelocity:40 options:0 animations:^{
            weakW.transform = CGAffineTransformMakeScale(0.7, 0.7);
            weakW.alpha = 0;
        } completion:^(BOOL finished) {
            [[weakSelf valueForKey:@"windows"] removeObject:weakW];
        }];
    };
    [_windows addObject:w];
    w.alpha = 0;
    w.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [w makeKeyAndVisible];
    [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:1 initialSpringVelocity:40 options:0 animations:^{
        w.transform = CGAffineTransformIdentity;
        w.alpha = 1;
    } completion:nil];
}
@end
