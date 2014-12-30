//
//  TCWindow.h
//  Fonster
//
//  Created by Joachim Bengtsson on 2013-10-09.
//  Copyright (c) 2013 ThirdCog. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCWindowDelegate;

@interface TCWindow : UIView
- (id)initWithRootViewController:(UIViewController*)rootViewController;
@property(readonly) UINavigationController *navigationController;
@property(readonly) UIViewController *rootViewController;
@property(weak) id<TCWindowDelegate> delegate;
- (IBAction)close:(id)sender;
- (NSString*)title;
@end

@protocol TCWindowDelegate <NSObject>
- (void)windowRequestsClose:(TCWindow*)window;
- (void)windowRequestsForeground:(TCWindow*)window;
- (UIDynamicAnimator*)animatorForWindow:(TCWindow*)window;
@end