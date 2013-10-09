//
//  TCWindow.m
//  Fonster
//
//  Created by Joachim Bengtsson on 2013-10-09.
//  Copyright (c) 2013 ThirdCog. All rights reserved.
//

#import "TCWindow.h"

static CGRect gLastFrame;

@interface TCWindow ()

@end

@implementation TCWindow
{
    UIToolbar *_toolbar;
    UIView *_background;
    UIView *_resizeWidget;
    UIButton *_closeWidget;
    CGRect _startFrame;
}

- (id)initWithFrame:(CGRect)frame
{
    if(!CGRectEqualToRect(gLastFrame, CGRectZero))
        frame = gLastFrame;
    
    if(!(self = [super initWithFrame:frame]))
        return nil;
    
    self.backgroundColor = [UIColor clearColor];
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    _background = [[UIView alloc] initWithFrame:self.bounds];
    _background.frame = CGRectInset(_background.frame, -2, -2);
    _background.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
    _background.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _resizeWidget = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _resizeWidget.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.1];
    _closeWidget = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeWidget.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    [_closeWidget addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_background];
    [self addSubview:_toolbar];
    [self addSubview:_resizeWidget];
    [self addSubview:_closeWidget];
    
    UIPanGestureRecognizer *move = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [_toolbar addGestureRecognizer:move];
    
    UIPanGestureRecognizer *resize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resize:)];
    [_resizeWidget addGestureRecognizer:resize];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect toolbarF, contentF;
    CGRectDivide(self.bounds, &toolbarF, &contentF, _toolbar.frame.size.height, CGRectMinYEdge);
    _toolbar.frame = toolbarF;
    self.rootViewController.view.frame = contentF;
    
    CGRect resizeF, _;
    CGRectDivide(toolbarF, &resizeF, &_, _resizeWidget.frame.size.width, CGRectMaxXEdge);
    resizeF.size.height = _resizeWidget.frame.size.height;
    _resizeWidget.frame = resizeF;
    
    CGRect closeF;
    CGRectDivide(toolbarF, &closeF, &_, _resizeWidget.frame.size.width, CGRectMinXEdge);
    _closeWidget.frame = closeF;
}

- (void)move:(UIPanGestureRecognizer*)grec
{
    if(grec.state == UIGestureRecognizerStateBegan) {
        [self makeKeyAndVisible];
        _startFrame = self.frame;
    } else if(grec.state == UIGestureRecognizerStateChanged) {
        CGRect r = self.frame;
        CGPoint diff = [grec translationInView:self];
        r.origin = (CGPoint){
            _startFrame.origin.x + diff.x,
            _startFrame.origin.y + diff.y
        };
        gLastFrame = self.frame = r;
    }
}

- (void)resize:(UIPanGestureRecognizer*)grec
{
    if(grec.state == UIGestureRecognizerStateBegan) {
        [self makeKeyAndVisible];
        _startFrame = self.frame;
    } else if(grec.state == UIGestureRecognizerStateChanged) {
        CGPoint diff = [grec translationInView:self];
        CGRect r2 = CGRectMake(
            _startFrame.origin.x,
            _startFrame.origin.y + diff.y,
            _startFrame.size.width + diff.x,
            _startFrame.size.height - diff.y
        );
        gLastFrame = self.frame = r2;
    }
}

- (IBAction)close:(id)sender
{
    self.closer();
}

@end
