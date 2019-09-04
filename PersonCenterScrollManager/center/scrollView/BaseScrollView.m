//
//  BaseScrollView.m
//  PersonCenterScrollManager
//
//  Created by licaicai on 2019/9/4.
//  Copyright © 2019 licaicai. All rights reserved.
//

#import "BaseScrollView.h"

@implementation BaseScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 仅仅让pageViewController区域的多个手势共存, 解决分页以上部分的"横向滑动视图(嵌套UICollectionView)"和scrollView的纵向滑动的手势冲突问题
    return YES;
}

@end
