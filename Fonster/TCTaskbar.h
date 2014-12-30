//
//  TCTaskbarViewController.h
//  Fonster
//
//  Created by Joachim Bengtsson on 2014-11-25.
//  Copyright (c) 2014 ThirdCog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCWindowManager;

@interface TCTaskbar : UICollectionViewController
- (instancetype)initWithWindowManager:(TCWindowManager*)wm;
@end
