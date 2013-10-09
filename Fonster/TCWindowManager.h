//
//  TCWindowManager.h
//  Fonster
//
//  Created by Joachim Bengtsson on 2013-10-09.
//  Copyright (c) 2013 ThirdCog. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCWindow;

@interface TCWindowManager : NSObject
- (id)init;
- (void)showWindow:(TCWindow*)w;
@end
