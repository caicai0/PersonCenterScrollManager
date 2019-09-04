//
//  UIScrollView+ScrollManager.m
//  PersonCenterScrollManager
//
//  Created by licaicai on 2019/9/4.
//  Copyright © 2019 licaicai. All rights reserved.
//

#import "UIScrollView+ScrollManager.h"
#import "objc/runtime.h"

@implementation UIScrollView (ScrollManager)

- (void)setCanNotScroll:(BOOL)canScroll{
    NSNumber * number = [NSNumber numberWithBool:canScroll];
    objc_setAssociatedObject(self, @selector(canNotScroll), number, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)canNotScroll{
    NSNumber * number  = objc_getAssociatedObject(self, @selector(canNotScroll));
    return [number boolValue];
}

@end
