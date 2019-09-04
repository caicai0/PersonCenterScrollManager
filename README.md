# PersonCenterScrollManager
嵌套滑动问题简单化处理

1. 公司最近项目中出现类似个人中想这样的交互设计，对于开发来说是有点难度的，于是开始网上搜索解决方案。找到的文章有：
[iOS开发实战 - 解决UIScrollView嵌套滑动手势冲突](https://www.jianshu.com/p/8b87837d9e3a)
但是发现一个严重的问题，作者的解决方案太过复杂耦合。给我们直接照搬带来了很大困难。手势冲突的解决代码分散在多个类的多个方法，互相配合实现功能。反复仔细研读后发现其实处理滑动冲突的原理还是很简单的，理论上简单的东西如果实际上不简单，那就一定掺入了不该掺入的东西。我接下来的目的就是解开这个节。
2. 基本原理：
    1. 首先实现两层UIScrollView都响应滑动手势。

            - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
                return YES;
            }
    2. 在滑动过程中控制其中一个UIScrollView不动，由于在第一部已经实现了两个UIScrollView都响应滑动手势，最终就会得到同一时间内只有一个UIScrollView在滑动的效果。我的主要工作也就是把这部分代码集中到一起。直接上代码

            - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
                if(self.enable){
                    if (scrollView == self.parentScrollView) {
                        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(scrollView.contentInset.top + scrollView.adjustedContentInset.top,
                                                                   scrollView.contentInset.left + scrollView.adjustedContentInset.left,
                                                                   scrollView.contentInset.bottom + scrollView.adjustedContentInset.bottom,
                                                                   scrollView.contentInset.right + scrollView.adjustedContentInset.right);
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
                                if (scrollView.contentOffset.y <= 0) {
                                    scrollView.canNotScroll = YES;
                                    self.parentScrollView.canNotScroll = NO;
                                    [self.childScrollViews enumerateObjectsUsingBlock:^(UIScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        obj.contentOffset = CGPointMake(obj.contentOffset.x, -obj.contentInset.top);
                                        obj.canNotScroll = YES;
                                    }];
                                }
                            } else {
                                scrollView.canNotScroll = YES;
                                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top);
                            }
                        }
                    }
                }
            }
代码中enable作为使能开关，parentScrollView最底层的UIScrollView，childScrollViews所有子UIScrollView的数组。canNotScroll是给UIScrollView做的扩展属性。- (void)scrollViewDidScroll:(UIScrollView *)scrollView；是所有UIScrollView的回调方法加入到UIScrollViewDelegate中调用即可达到目的。

3. 这样做最大的优点是最小量的代码掺入到业务逻辑和UI架构中，使得本来就复杂的项目相对简单清晰一些。

4. 使用方法：生成一个实例，赋值parentScrollView，childScrollViews直接addObject；然后

        - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
           [self.scrollManager scrollViewDidScroll:scrollView];
        }

github:https://github.com/caicai0/PersonCenterScrollManager
