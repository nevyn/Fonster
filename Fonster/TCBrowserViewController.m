//
//  TCBrowserViewController.m
//  Fonster
//
//  Created by Joachim Bengtsson on 2013-10-09.
//  Copyright (c) 2013 ThirdCog. All rights reserved.
//

#import "TCBrowserViewController.h"

@interface TCBrowserViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TCBrowserViewController
- (void)viewDidLoad
{
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
}

- (IBAction)navigateTo:(UITextField *)sender {
    NSString *s = sender.text;
    if(![s hasPrefix:@"http"])
        s = [@"http://" stringByAppendingString:s];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:s]]];
}

- (BOOL)textFieldShouldReturn:(UITextField*)field
{
    [field endEditing:YES];
    [self navigateTo:field];
    return NO;
}
@end
