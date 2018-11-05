//
//  ViewController.m
//  HYBannerView
//
//  Created by 艾信超 on 2018/11/3.
//  Copyright © 2018年 aixinchao. All rights reserved.
//

#import "ViewController.h"
#import "HYBannerViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self privateSetupUI];
    
}

#pragma mark -- Methods
- (void)privateInitPropertys {
    self.title = @"Title";
}

- (void)privateSetupUI {
    [self.view addSubview:self.button];
}

- (void)buttonClick:(UIButton *)sender {
    HYBannerViewController *bannerVC = [[HYBannerViewController alloc] init];
    [self.navigationController pushViewController:bannerVC animated:YES];
}


#pragma mark -- Property
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(50.f, 250.f, self.view.frame.size.width - 100.f, 50.f);
        _button.backgroundColor = [UIColor orangeColor];
        _button.layer.cornerRadius = 10;
        _button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        [_button setTitle:@"立即提现" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
