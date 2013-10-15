//
//  TCWindowManager.m
//  Fonster
//
//  Created by Joachim Bengtsson on 2013-10-09.
//  Copyright (c) 2013 ThirdCog. All rights reserved.
//

#import "TCWindowManager.h"
#import "TCWindow.h"
#import "TCDesktopViewController.h"

@interface TCWindowManager () <TCWindowDelegate, UIDynamicAnimatorDelegate>
{
    NSMutableArray *_windows;
    UIDynamicAnimator *_animator;
    int _tabIndex;
}
@end

@implementation TCWindowManager
- (id)init
{
    if(!(self = [super init]))
        return nil;
    _windows = [NSMutableArray new];
    _desktop = [[TCDesktopViewController alloc] init];
    return self;
}

- (void)loadView
{
    UIView *root = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Desktop.jpg"]];
    bg.frame = root.bounds;
    bg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    bg.contentMode = UIViewContentModeScaleAspectFill;
    root.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:_desktop];
    [root addSubview:_desktop.view];
    _desktop.view.frame = root.bounds;
    _desktop.collectionView.backgroundView = bg;
    _desktop.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [_desktop didMoveToParentViewController:self];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:root];
    _animator.delegate = self;
    
    self.view = root;
}

- (void)showWindow:(TCWindow*)w
{
    [_windows addObject:w];
    w.delegate = self;
    [self addChildViewController:w.rootViewController];
    
    w.alpha = 0;
    w.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [self.view addSubview:w];
    [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:1 initialSpringVelocity:40 options:0 animations:^{
        w.transform = CGAffineTransformIdentity;
        w.alpha = 1;
        [w.rootViewController didMoveToParentViewController:self];
        [w becomeFirstResponder];
    } completion:nil];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator;
{
    for(UIDynamicBehavior *behavior in animator.behaviors.copy) {
        if([behavior isKindOfClass:[UIPushBehavior class]])
            [animator removeBehavior:behavior];
    }
}

#pragma mark window delegate

- (void)windowRequestsClose:(TCWindow *)w
{
    [w.rootViewController willMoveToParentViewController:nil];
    [UIView animateWithDuration:0.65 delay:0 usingSpringWithDamping:1 initialSpringVelocity:40 options:0 animations:^{
        w.transform = CGAffineTransformMakeScale(0.7, 0.7);
        w.alpha = 0;
        if(_windows.count > 1)
            [self windowRequestsForeground:_windows[_windows.count-2]];
    } completion:^(BOOL finished) {
        [_windows removeObject:w];
        [w.rootViewController removeFromParentViewController];
    }]; 
}

- (void)windowRequestsForeground:(TCWindow *)window
{
    [self.view addSubview:window];
    [_windows removeObject:window]; [_windows addObject:window];
    [window becomeFirstResponder];
}

- (UIDynamicAnimator*)animatorForWindow:(TCWindow*)window
{
    return nil;
    return _animator;
}

#pragma mark Responder


- (BOOL)canBecomeFirstResponder;
{
    return YES;
}

- (NSArray*)keyCommands
{
    return @[
        [UIKeyCommand keyCommandWithInput:@"\t" modifierFlags:UIKeyModifierCommand action:@selector(cycleWindows:)],
        [UIKeyCommand keyCommandWithInput:@"\t" modifierFlags:UIKeyModifierCommand|UIKeyModifierShift action:@selector(cycleWindowsReverse:)],
    ];
}

- (IBAction)cycleWindows:(id)sender
{
    _tabIndex = (_tabIndex - 1) % _windows.count;
    [self windowRequestsForeground:_windows[_tabIndex]];
}

- (IBAction)cycleWindowsReverse:(id)sender
{
    _tabIndex = (_tabIndex + 1) % _windows.count;
    [self windowRequestsForeground:_windows[_tabIndex]];
}


@end
