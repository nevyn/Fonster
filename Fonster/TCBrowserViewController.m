//
//  TCBrowserViewController.m
//  Fonster
//
//  Created by Joachim Bengtsson on 2013-10-09.
//  Copyright (c) 2013 ThirdCog. All rights reserved.
//

#import "TCBrowserViewController.h"

@interface TCBrowserViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation TCBrowserViewController
- (void)viewDidLoad
{
    UITextField *f = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 28)];
    f.borderStyle = UITextBorderStyleRoundedRect;
    f.autocorrectionType = UITextAutocorrectionTypeNo;
    f.autocapitalizationType = UITextAutocapitalizationTypeNone;
    f.keyboardType = UIKeyboardTypeURL;
    f.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:f];
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
