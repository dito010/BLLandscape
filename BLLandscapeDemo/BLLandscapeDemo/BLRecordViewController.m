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

#import "BLRecordViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+BLLandscape.h"

@interface BLRecordViewController ()

/**
 * 要横屏的 view.
 */
@property(nonatomic, strong) UIView *previewView;

/**
 * 开始横屏按钮.
 */
@property(nonatomic, strong) UIButton *landscapeButton;

@end

@implementation BLRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}


- (void)closeButtonDidClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)landscapeButtonDidClick{
    if (self.previewView.viewStatus == BLLandscapeViewStatusPortrait) {
        
        [self.previewView bl_landscapeAnimated:YES animations:^{
            
            self.landscapeButton.frame = CGRectMake(20.f, self.previewView.bounds.size.height - 80.f, self.previewView.bounds.size.width - 40.f, 50.f);
            [self.landscapeButton setTitle:@"回到竖屏" forState:UIControlStateNormal];
            
        } complete:^{
            
        }];
    }
    else if (self.previewView.viewStatus == BLLandscapeViewStatusLandscape){
        
        [self.previewView bl_protraitAnimated:YES animations:^{
            
            self.landscapeButton.frame = CGRectMake(20.f, self.previewView.bounds.size.height - 80.f, self.previewView.bounds.size.width - 40.f, 50.f);
            [self.landscapeButton setTitle:@"开始横屏" forState:UIControlStateNormal];
            
        } complete:^{
            
        }];
    }
}


#pragma mark - Setup

- (void)setup{
    self.view.backgroundColor = [UIColor blackColor];
    self.previewView = ({
        UIView *view = [UIView new];
        view.frame = self.view.bounds;
        view.backgroundColor = [UIColor redColor];
        [self.view addSubview:view];
        
        view;
    });
    
    self.landscapeButton = ({
        UIButton *landscapeBtn = [UIButton new];
        landscapeBtn.backgroundColor = self.view.tintColor;
        [landscapeBtn setTitle:@"开始横屏" forState:UIControlStateNormal];
        [landscapeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [landscapeBtn addTarget:self action:@selector(landscapeButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [landscapeBtn sizeToFit];
        landscapeBtn.frame = CGRectMake(20.f, self.previewView.bounds.size.height - 80.f, self.previewView.bounds.size.width - 40.f, 50.f);
        landscapeBtn.layer.cornerRadius = 4.f;
        [self.previewView addSubview:landscapeBtn];
        
        landscapeBtn;
    });
    
    UIButton *closeBtn = [UIButton new];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn sizeToFit];
    closeBtn.frame = CGRectMake(self.view.bounds.size.width - 60.f, 30.f, closeBtn.bounds.size.width, closeBtn.bounds.size.height);
    [self.view addSubview:closeBtn];
}

@end
