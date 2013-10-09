//
//  TCWindowManager.m
//  Fonster
//
//  Created by Joachim Bengtsson on 2013-10-09.
//  Copyright (c) 2013 ThirdCog. All rights reserved.
//

#import "TCWindowManager.h"
#import "TCWindow.h"

@interface TCWindowManager () <TCWindowDelegate>
{
    NSMutableArray *_windows;
}
@end

@implementation TCWindowManager
- (id)init
{
    if(!(self = [super init]))
        return nil;
    _windows = [NSMutableArray new];
    return self;
}

- (void)loadView
{
    UIView *root = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Bristle Grass.jpg"]];
    bg.frame = root.bounds;
    bg.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    bg.contentMode = UIViewContentModeScaleAspectFill;
    [root addSubview:bg];
    root.backgroundColor = [UIColor whiteColor];
    
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
    } completion:nil];
}

- (void)windowRequestsClose:(TCWindow *)w
{
    [w.rootViewController willMoveToParentViewController:nil];
    [UIView animateWithDuration:0.65 delay:0 usingSpringWithDamping:1 initialSpringVelocity:40 options:0 animations:^{
        w.transform = CGAffineTransformMakeScale(0.7, 0.7);
        w.alpha = 0;
    } completion:^(BOOL finished) {
        [_windows removeObject:w];
        [w.rootViewController removeFromParentViewController];
    }]; 
}

- (void)windowRequestsForeground:(TCWindow *)window
{
    [self.view addSubview:window];
}
@end
