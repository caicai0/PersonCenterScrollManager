//
//  PersonalCenterViewController.m
//  PersonCenterScrollManager
//
//  Created by licaicai on 2019/9/4.
//  Copyright © 2019 licaicai. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import <Masonry.h>
#import <SGPagingView.h>
#import "SubViewController.h"
#import "BaseScrollView.h"
#import "ScrollManager.h"

@interface PersonalCenterViewController () <UIScrollViewDelegate,SGPageTitleViewDelegate,SGPageContentScrollViewDelegate>

@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)SGPageTitleView *pageTitleView;
@property (nonatomic, strong)SGPageContentScrollView *pageContentScrollView;
@property (nonatomic, strong)ScrollManager * scrollManager;

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollManager = [[ScrollManager alloc]init];
    self.scrollView = [[BaseScrollView alloc]init];
    self.scrollView.delegate = self;
    self.scrollManager.parentScrollView = self.scrollView;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    UIView * contentView = [[UIView alloc]init];
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
    }];
    UIView * headerView = [[UIView alloc]init];
    [contentView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(contentView);
        make.height.mas_equalTo(100);
    }];
    
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    /// pageTitleView
    NSArray *titles = @[@"主页", @"动态", @"关注", @"粉丝"];
    SGPageTitleView *pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectZero delegate:self titleNames:titles configure:configure];
    [self.view addSubview:pageTitleView];
    
    /// pageContent
    NSMutableArray *controllers = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++) {
        SubViewController *controller = [[SubViewController alloc]initWithNibName:nil bundle:nil];
        controller.scrollManager = self.scrollManager;
        [controllers addObject:controller];
    }
    SGPageContentScrollView *pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectZero parentVC:self childVCs:controllers];
    pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:pageContentScrollView];
    
    self.pageTitleView = pageTitleView;
    self.pageContentScrollView = pageContentScrollView;
    
    [contentView addSubview:pageTitleView];
    [pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(contentView);
        make.top.mas_equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    [contentView addSubview:pageContentScrollView];
    [pageContentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(contentView);
        make.top.mas_equalTo(pageTitleView.mas_bottom);
        make.bottom.mas_equalTo(contentView);
        make.height.mas_equalTo(self.view).mas_offset(-88-34-45);
    }];
    // Do any additional setup after loading the view.
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.scrollManager scrollViewDidScroll:scrollView];
}

@end
