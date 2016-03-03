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
#import "TCTaskbar.h"

@interface TCWindowManager () <TCWindowDelegate, UIDynamicAnimatorDelegate>
{
    int _tabIndex;
	NSMutableArray *_windows;
}
@end

@implementation TCWindowManager
- (id)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.itemSize = CGSizeMake(300, 300);
    if(!(self = [super initWithCollectionViewLayout:layout]))
        return nil;

	_windows = [NSMutableArray new];
    _desktop = [[TCDesktopViewController alloc] init];
	_taskbar = [[TCTaskbar alloc] initWithWindowManager:self];
	
	[self.collectionView registerClass:[TCWindowCell class] forCellWithReuseIdentifier:@"WindowCell"];
    return self;
}

- (void)showWindow:(TCWindow*)w
{
    [[self mutableArrayValueForKey:@"windows"] addObject:w];
    w.delegate = self;
    [self addChildViewController:w.navigationController];
	
	[self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_windows.count-1 inSection:0]]];
	
	[w.navigationController didMoveToParentViewController:self];
	[w becomeFirstResponder];
}

#pragma mark window delegate

- (void)windowRequestsClose:(TCWindow *)w
{
    [w.navigationController willMoveToParentViewController:nil];
	
	NSUInteger oldIndex = [_windows indexOfObject:w];
	[[self mutableArrayValueForKey:@"windows"] removeObject:w];
	[w.navigationController removeFromParentViewController];
	
	[self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:oldIndex inSection:0]]];
	
	if(_windows.count > 1)
		[self windowRequestsForeground:_windows.lastObject];
}

- (void)windowRequestsForeground:(TCWindow *)window
{
	[self moveWindowToForeground:window];
}
- (void)moveWindowToForeground:(TCWindow*)window
{
	// TODO
    [window becomeFirstResponder];
}

#pragma mark Collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _windows.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TCWindow *window = _windows[indexPath.item];
	TCWindowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WindowCell" forIndexPath:indexPath];
	window.frame = cell.frame;
	window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
	[cell.contentView addSubview:window];
    return cell;
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
	// TODO
    //_tabIndex = (_tabIndex - 1) % _windows.count;
    //[self moveWindowToForeground:_windows[_tabIndex]];
}

- (IBAction)cycleWindowsReverse:(id)sender
{
	// TODO
    //_tabIndex = (_tabIndex + 1) % _windows.count;
    //[self moveWindowToForeground:_windows[_tabIndex]];
}

@end
