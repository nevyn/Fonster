//
//  TCDesktopViewController.h
//  Fonster
//
//  Created by Joachim Bengtsson on 2013-10-10.
//  Copyright (c) 2013 ThirdCog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCDesktopViewController : UICollectionViewController
- (id)init;
- (void)addIcon:(UIImage*)icon title:(NSString*)title target:(id)target action:(SEL)action;
@end
