//
//  TCWindowManager.h
//  Fonster
//
//  Created by Joachim Bengtsson on 2013-10-09.
//  Copyright (c) 2013 ThirdCog. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCWindow;
@class TCDesktopViewController;
@class TCTaskbar;

@interface TCWindowManager : UIViewController
@property(readonly) TCDesktopViewController *desktop;
@property(readonly) TCTaskbar *taskbar;

- (id)init;
- (void)showWindow:(TCWindow*)w;
@end
