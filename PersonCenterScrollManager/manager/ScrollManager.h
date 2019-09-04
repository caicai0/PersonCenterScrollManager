//
//  ScrollManager.h
//  PersonCenterScrollManager
//
//  Created by licaicai on 2019/9/4.
//  Copyright © 2019 licaicai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+ScrollManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScrollManager : NSObject

@property (nonatomic, assign)BOOL enable;//使能
@property (nonatomic, weak)UIScrollView * parentScrollView;
@property (nonatomic, strong)NSMutableArray * childScrollViews;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
