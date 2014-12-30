//
//  TCTaskbarViewController.m
//  Fonster
//
//  Created by Joachim Bengtsson on 2014-11-25.
//  Copyright (c) 2014 ThirdCog. All rights reserved.
//

#import "TCTaskbar.h"
#import "TCWindowManager.h"
#import "TCWindow.h"

static void *const kWindowsContext;

@interface TCTaskbarButtonCell : UICollectionViewCell
@property(nonatomic) NSString *text;
@end

@interface TCTaskbar ()
@property(weak, nonatomic) TCWindowManager *wm;
@end

@interface TCTaskbarLayout : UICollectionViewLayout
@property(nonatomic) int count;
@property(nonatomic) CGSize size;
@end

@implementation TCTaskbar
- (instancetype)initWithWindowManager:(TCWindowManager*)wm
{
	if(!(self = [super initWithCollectionViewLayout:[TCTaskbarLayout new]]))
		return nil;
	self.wm = wm;
	[self.collectionView registerClass:[TCTaskbarButtonCell class] forCellWithReuseIdentifier:@"WindowButton"];
	[wm addObserver:self forKeyPath:@"windows" options:0 context:kWindowsContext];
	return self;
}
- (void)dealloc
{
	[self.wm removeObserver:self forKeyPath:@"windows" context:kWindowsContext];
}
- (void)viewDidLoad
{
	[super viewDidLoad];
	self.collectionView.backgroundColor = [UIColor colorWithWhite:0.663 alpha:1.000];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if(context == kWindowsContext) {
		[self windowsChanged];
	} else return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}
- (void)windowsChanged
{
	((TCTaskbarLayout*)self.collectionViewLayout).count = [[self.wm valueForKey:@"windows"] count];
	[self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [[self.wm valueForKeyPath:@"windows"] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	TCTaskbarButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WindowButton" forIndexPath:indexPath];
	TCWindow *window = [self.wm valueForKey:@"windows"][indexPath.row];
	
	cell.contentMode = UIViewContentModeRedraw;
	cell.text = window.navigationController.navigationBar.topItem.title;
	
	return cell;
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	((TCTaskbarLayout*)self.collectionViewLayout).size = self.view.frame.size;
}

@end

@implementation TCTaskbarLayout
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSMutableArray *ar = [NSMutableArray new];
	for(int i = 0; i < self.count; i++) {
		[ar addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
	}
	return [ar copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static const float kMargin = 2;
	UICollectionViewLayoutAttributes *attrs = [[self.class layoutAttributesClass] layoutAttributesForCellWithIndexPath:indexPath];
	CGRect r = (CGRect){.size=self.size};
	r.size.width /= self.count;
	r.size.width = MIN(200, r.size.width - kMargin*(self.count+2));
	r.origin.x = kMargin + (r.size.width + kMargin)*indexPath.item;
	r.size.height -= kMargin*2;
	r.origin.y += kMargin;
	attrs.frame = r;
	return attrs;
}

- (CGSize)collectionViewContentSize
{
	return self.size;
}

@end

@implementation TCTaskbarButtonCell
- (void)drawRect:(CGRect)rect
{
	CGRect pen = self.bounds;

	[[UIColor colorWithWhite:0.827 alpha:1.000] setFill];
	[[UIBezierPath bezierPathWithRect:pen] fill];
	
	pen.origin.x += 2;
	pen.origin.y += 2;
	[[UIColor colorWithWhite:0.133 alpha:1.000] setFill];
	[[UIBezierPath bezierPathWithRect:pen] fill];
	pen.origin.x -= 2;
	pen.origin.y -= 2;
	
	pen = CGRectInset(pen, 2, 2);
	[[UIColor lightGrayColor] setFill];
	[[UIBezierPath bezierPathWithRect:pen] fill];

	
	pen = CGRectInset(pen, 2, 2);
	[[UIColor blackColor] setFill];
	[self.text drawInRect:pen withAttributes:@{
		NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
	}];
}
@end