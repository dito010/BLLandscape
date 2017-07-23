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

#import "BLHomeViewController.h"
#import "BLRecordViewController.h"
#import "BLPlayViewController.h"
#import "BLAnotherWindowViewController.h"

@interface BLHomeViewController ()<UITableViewDelegate, UITableViewDataSource>

/**
 * window.
 */
@property(nonatomic, strong) UIWindow *anotherWindow;

@end

static NSString *kBLHomeViewControllerReuseID = @"com.ibeiliao.home.resue.id";
const CGFloat kBLHomeViewControllerRowHeight = 64.f;
@implementation BLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.anotherWindow.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.anotherWindow.hidden = YES;  
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kBLHomeViewControllerRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        BLRecordViewController *recordVc = [BLRecordViewController new];
        [self presentViewController:recordVc animated:YES completion:nil];
    }
    else if (indexPath.row == 1){
        BLPlayViewController *playVc = [BLPlayViewController new];
        [self.navigationController pushViewController:playVc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBLHomeViewControllerReuseID forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"录制横屏";
    }
    else if (indexPath.row == 1){
        cell.textLabel.text = @"播放横屏";
    }
    
    return cell;
}

- (void)switchValueChanged:(UISwitch *)aswitch{
    if (aswitch.isOn) {
        BLAnotherWindowViewController *vc = [BLAnotherWindowViewController new];
        self.anotherWindow.rootViewController = vc;
        [self.anotherWindow insertSubview:vc.view atIndex:0];
        self.anotherWindow.alpha = 0;
    }
    else{
        self.anotherWindow.rootViewController = nil;
    }
}


#pragma mark - Setup

- (void)setup{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kBLHomeViewControllerReuseID];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self addWindow];
}

- (void)addWindow{
    self.anotherWindow = ({
        UIWindow * window = [UIWindow new];
        window.backgroundColor = [UIColor redColor];
        window.frame = CGRectMake(self.view.bounds.size.width - 140.f, self.view.bounds.size.height - 200.f, 100.f, 100.f);
        
        window;
    });
    
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor blueColor];
    backView.frame = self.anotherWindow.bounds;
    [self.anotherWindow addSubview:backView];
    
    UILabel *label = [UILabel new];
    label.text = @"我是窗口";
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    label.frame = CGRectMake(15.f, 10.f, label.bounds.size.width, label.bounds.size.height);
    [backView addSubview:label];
    
    UILabel *addRootVCLabel = [UILabel new];
    addRootVCLabel.text = @"为窗口添加根控制器";
    addRootVCLabel.textColor = [UIColor whiteColor];
    [addRootVCLabel sizeToFit];
    addRootVCLabel.font = [UIFont systemFontOfSize:10.f];
    addRootVCLabel.frame = CGRectMake(5.f, 30.f, addRootVCLabel.bounds.size.width, addRootVCLabel.bounds.size.height);
    [backView addSubview:addRootVCLabel];
    
    UISwitch *aSwitch = [UISwitch new];
    [aSwitch sizeToFit];
    aSwitch.frame = CGRectMake(15.f, 50.f, 40.f, 40.f);
    [backView addSubview:aSwitch];
    [aSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
}

@end
