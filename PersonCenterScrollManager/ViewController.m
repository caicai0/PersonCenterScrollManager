//
//  ViewController.m
//  PersonCenterScrollManager
//
//  Created by licaicai on 2019/9/4.
//  Copyright © 2019 licaicai. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "PersonalCenterViewController.h"

@interface ViewController ()

@property (nonatomic, strong)UIButton * nextButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    // Do any additional setup after loading the view.
}

- (void)setupSubViews {
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(200);
    }];
}

- (void)enterCenter {
    PersonalCenterViewController *vc = [[PersonalCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Getters
- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.backgroundColor = UIColor.redColor;
        [_nextButton setTitle:@"进入个人中心" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(enterCenter) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}


@end
