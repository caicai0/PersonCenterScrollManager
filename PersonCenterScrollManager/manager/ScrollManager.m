//
//  ScrollManager.m
//  PersonCenterScrollManager
//
//  Created by licaicai on 2019/9/4.
//  Copyright © 2019 licaicai. All rights reserved.
//

#import "ScrollManager.h"

@implementation ScrollManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.childScrollViews = [NSMutableArray array];
        self.enable = YES;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.enable){
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        if (@available(iOS 11.0, *)) {
            edgeInsets = UIEdgeInsetsMake(scrollView.contentInset.top + scrollView.adjustedContentInset.top,
            scrollView.contentInset.left + scrollView.adjustedContentInset.left,
            scrollView.contentInset.bottom + scrollView.adjustedContentInset.bottom,
            scrollView.contentInset.right + scrollView.adjustedContentInset.right);
        }
        if (scrollView == self.parentScrollView) {
            CGFloat contentOffsetY = scrollView.contentOffset.y + edgeInsets.top;
            CGFloat criticalPointOffsetY = scrollView.contentSize.height + edgeInsets.top + edgeInsets.bottom - scrollView.bounds.size.height;
            if (contentOffsetY - criticalPointOffsetY >= FLT_EPSILON) {
                scrollView.canNotScroll = YES;
                scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY - edgeInsets.top);
                [self.childScrollViews enumerateObjectsUsingBlock:^(UIScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.canNotScroll = NO;
                }];
            } else {
                if (scrollView.canNotScroll) {
                    scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY - edgeInsets.top);
                } else {
                    [self.childScrollViews enumerateObjectsUsingBlock:^(UIScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.canNotScroll = YES;
                    }];
                }
            }
        }else{
            if ([self.childScrollViews containsObject:scrollView]) {
                if (!scrollView.canNotScroll) {
                    CGFloat contentOffsetY = scrollView.contentOffset.y + edgeInsets.top;
                    if (contentOffsetY <= 0) {
                        scrollView.canNotScroll = YES;
                        self.parentScrollView.canNotScroll = NO;
                        [self.childScrollViews enumerateObjectsUsingBlock:^(UIScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            obj.contentOffset = CGPointMake(obj.contentOffset.x, -edgeInsets.top);
                            obj.canNotScroll = YES;
                        }];
                    }
                } else {
                    scrollView.canNotScroll = YES;
                    scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -edgeInsets.top);
                }
            }
        }
    }
}

@end
