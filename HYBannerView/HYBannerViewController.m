//
//  HYBannerViewController.m
//  HYBannerView
//
//  Created by ios on 2018/11/2.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYBannerViewController.h"
#import "HYBannerView.h"

@interface HYBannerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYBannerView *bannerView;

@end

@implementation HYBannerViewController

- (void)dealloc {
    NSLog(@"dealloc_____%@",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self privateInitPropertys];
    [self privateSetupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bannerView.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.bannerView.player.viewControllerDisappear = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.bannerView publicInvalidateTimer];
}

#pragma mark -- Methods
- (void)privateInitPropertys {
    self.title = @"BannerView";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)privateSetupUI {
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.bannerView;
}

#pragma mark -- Property
- (HYBannerView *)bannerView {
    if (!_bannerView) {
        //http://5b0988e595225.cdn.sohucs.com/images/20170826/b6fc1b92d3384f7f96a0e7a7e073d579.jpeg
        //http://hc.yinyuetai.com/uploads/videos/common/461C01651479054A43033420781A1DE6.mp4
        _bannerView = [[HYBannerView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 200.f) withDataArray:@[@"http://hc.yinyuetai.com/uploads/videos/common/461C01651479054A43033420781A1DE6.mp4",@"http://pic29.nipic.com/20130511/9252150_174018365301_2.jpg",@"http://pic37.nipic.com/20140209/2531170_112946779000_2.jpg",@"http://img.zcool.cn/community/019c2958a2b760a801219c77a9d27f.jpg",@"http://pic.58pic.com/58pic/14/15/80/65a58PICQWX_1024.jpg"]];
    }
    return _bannerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsMake(0.f, 16.f, 0.f, 16.f);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 区 第 %ld 行",(long)indexPath.section,(long)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (!_bannerView) {
        return UIStatusBarStyleDefault;
    }
    if (self.bannerView.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    if (!_bannerView) {
        return NO;
    }
    return self.bannerView.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.bannerView.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.bannerView.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
