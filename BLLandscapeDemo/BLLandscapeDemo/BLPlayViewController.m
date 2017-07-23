/*
 * This file is part of the BLLandscape package.
 * (c) NewPan <13246884282@163.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * Click https://github.com/newyjp
 * or http://www.jianshu.com/users/e2f2d779c022/latest_articles to contact me.
 */

#import "BLPlayViewController.h"
#import "UIViewController+Landscape.h"

@interface BLPlayViewController ()<UIWebViewDelegate>

/**
 * webView.
 */
@property(nonatomic, strong) UIWebView *webView;

@end

@implementation BLPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.webView.frame = self.view.bounds;
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:@"if(document.getElementsByTagName('video').length>0)document.getElementsByTagName('video').length;"];
    if (result.length && result.integerValue != 0) {
        self.bl_shouldAutoLandscape = YES;
    }
}


#pragma mark - Setup

- (void)setup{
    self.webView = ({
        UIWebView *webView = [UIWebView new];
        [self.view addSubview:webView];
        webView.delegate = self;
        
        webView;
    });
    
    self.title = @"网页中有视频";
    
//    NSString *urlString = @"http://lavaweb-10015286.video.myqcloud.com/%E5%B0%BD%E6%83%85LAVA.mp4";
    NSString *urlString = @"https://www.apple.com/cn/iphone/photography-how-to/";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}


@end
