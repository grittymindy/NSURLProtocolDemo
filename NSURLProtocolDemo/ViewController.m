//
//  ViewController.m
//  NSURLProtocolDemo
//
//  Created by Mindy on 15/10/21.
//  Copyright © 2015年 Mindy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIWebView *webview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.webview];
    
    
    NSString *url = @"http://www.baidu.com";
    NSURLRequest * request = [[NSURLRequest alloc]  initWithURL:[NSURL URLWithString:url]];
    [self.webview loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
