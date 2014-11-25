//
//  TCTaskbarViewController.m
//  Fonster
//
//  Created by Joachim Bengtsson on 2014-11-25.
//  Copyright (c) 2014 ThirdCog. All rights reserved.
//

#import "TCTaskbar.h"

@interface TCTaskbar ()

@end

@implementation TCTaskbar
- (void)loadView
{
	UIView *root = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	root.backgroundColor = [UIColor lightGrayColor];
	
	UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 1)];
	sep.backgroundColor = [UIColor grayColor];
	sep.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
	[root addSubview:sep];
	
	
	
	self.view = root;
}
@end
