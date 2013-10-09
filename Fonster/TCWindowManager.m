//
//  TCWindowManager.m
//  Fonster
//
//  Created by Joachim Bengtsson on 2013-10-09.
//  Copyright (c) 2013 ThirdCog. All rights reserved.
//

#import "TCWindowManager.h"
#import "TCWindow.h"

@implementation TCWindowManager
{
    NSMutableArray *_windows;
}

- (id)init
{
    if(!(self = [super init]))
        return nil;
    _windows = [NSMutableArray new];
    return self;
}

- (void)showWindow:(TCWindow*)w
{
    [_windows addObject:w];
    
    __weak id weakSelf = self; __weak TCWindow *weakW = w;
    w.closer = ^{
        [UIView animateWithDuration:0.65 delay:0 usingSpringWithDamping:1 initialSpringVelocity:40 options:0 animations:^{
            weakW.transform = CGAffineTransformMakeScale(0.7, 0.7);
            weakW.alpha = 0;
        } completion:^(BOOL finished) {
            [[weakSelf valueForKey:@"windows"] removeObject:weakW];
        }];
    };
    
    w.alpha = 0;
    w.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [w makeKeyAndVisible];
    [UIView animateWithDuration:0.45 delay:0 usingSpringWithDamping:1 initialSpringVelocity:40 options:0 animations:^{
        w.transform = CGAffineTransformIdentity;
        w.alpha = 1;
    } completion:nil];
}
@end
