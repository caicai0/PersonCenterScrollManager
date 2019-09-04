//
//  SubViewController.m
//  PersonCenterScrollManager
//
//  Created by licaicai on 2019/9/4.
//  Copyright © 2019 licaicai. All rights reserved.
//

#import "SubViewController.h"
#import <Masonry/Masonry.h>

@interface SubViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView * tableview;
@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.tableview = [[UITableView alloc]init];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.scrollManager.childScrollViews addObject:self.tableview];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = indexPath.description;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.scrollManager scrollViewDidScroll:scrollView];
}

@end
