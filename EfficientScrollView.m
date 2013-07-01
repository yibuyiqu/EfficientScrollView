//
//  EfficientScrollView.m
//  yibuyiqu
//
//  Created by Yazhi on 19/02/13.
//  Copyright (c) 2013 yibuyiqu. All rights reserved.
//

#import "EfficientScrollView.h"

@implementation EfficientScrollView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentIndex = 0;
        _viewArray = [[NSMutableArray alloc] init];
        self.pagingEnabled = YES;
        self.delegate = self;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _currentIndex = 0;
        _viewArray = [[NSMutableArray alloc] init];
        self.pagingEnabled = YES;
        self.delegate = self;
    }
    return self;
}

- (UIView *)getCurrentView {
    for (UIView *view in _viewArray) {
        if (view.tag == _currentIndex) {
            return view;
        }
    }
    return nil;
}

-(void)setCurrentIndex:(int)index {
    _currentIndex = index;
    [_viewArray removeAllObjects];
    [self reloadView];
    int page = 0;
    if (_currentIndex == 0) {
        page = 0;
    }
    else if (_currentIndex == _pageCount - 1) {
        page = MIN(2, _currentIndex);
    }
    else {
        page = 1;
    }
    
    if (_scrollDirection == eScrollHorizontally) {
        self.contentOffset = CGPointMake(page * self.frame.size.width, 0);
    }
    else {
        self.contentOffset = CGPointMake(0, page * self.frame.size.height);
    }
    
    if ([_efficientDelegate respondsToSelector:@selector(efficientScrollView:pageChanged:)]) {
        [_efficientDelegate efficientScrollView:self pageChanged:_currentIndex];
    }
}

-(void)reloadView {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    int startIndex;
    if (_currentIndex == 0) {
        startIndex = _currentIndex;
    }
    else if(_currentIndex == _pageCount - 1) {
        startIndex = MAX(_currentIndex-2, 0);
    }
    else {
        startIndex = _currentIndex-1;
    }
    NSArray *array = [NSArray arrayWithArray:_viewArray];
    [_viewArray removeAllObjects];
    
    // x means y in vertical mode.
    int x = _margin;
    for (int i = startIndex; i < MIN(startIndex+3, _pageCount); i++) {
        
        UIView *view = nil;
        for (UIView *v in array) {
            if (v.tag == i) {
                view = v;
//                if ([view isKindOfClass:[EfficientScrollView class]] && i != _currentIndex) {
//                    [((EfficientScrollView *)view) setCurrentIndex:0];
//                }
                break;
            }
        }
        if (!view) {
            view = [_efficientDelegate efficientScrollView:self getViewByIndex:i];
            
        }
        view.tag = i;
        if (_scrollDirection == eScrollHorizontally) {
            view.frame = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
            x += self.frame.size.width;
        }
        else {
            view.frame = CGRectMake(0, x, self.frame.size.width, self.frame.size.height);
            x += self.frame.size.height;
        }
        [self addSubview:view];
        [_viewArray addObject:view];
    }
    if (_scrollDirection == eScrollHorizontally) {
        self.contentSize = CGSizeMake((MIN(3, _pageCount) * self.frame.size.width), self.frame.size.height);
    }
    else {
        self.contentSize = CGSizeMake(self.frame.size.width, (MIN(3, _pageCount) * self.frame.size.height));
    }
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = 0;
    if (_scrollDirection == eScrollHorizontally) {
        page = self.contentOffset.x / self.frame.size.width;
    }
    else {
        page = self.contentOffset.y / self.frame.size.height;
    }
    if (_currentIndex == 0) {
        if (page == 0) {
            
        }
        else if (page == 1) {
            _currentIndex++;
            [self reloadView];
        }
        else if (page == 2) {
            _currentIndex += 2;
            [self reloadView];
            if (_currentIndex != _pageCount - 1) {
                if (_scrollDirection == eScrollHorizontally) {
                    self.contentOffset = CGPointMake(self.frame.size.width, 0);
                }
                else {
                    self.contentOffset = CGPointMake(0, self.frame.size.height);
                }
            }
        }
    }
    else if (_currentIndex == _pageCount - 1) {
        if (page == 0) {
            _currentIndex = MAX(_currentIndex-2, 0);
            [self reloadView];
            if (_scrollDirection == eScrollHorizontally) {
                self.contentOffset = CGPointMake(MIN(1, _currentIndex) * self.frame.size.width, 0);
            }
            else {
                self.contentOffset = CGPointMake(0, MIN(1, _currentIndex) * self.frame.size.height);

            }
        }
        else if (page == 1 && _currentIndex != page) {
            _currentIndex--;
            [self reloadView];
        }
        else if (page == 2) {
            
        }
    }
    else {
        if (page == 0) {
            _currentIndex--;
            [self reloadView];
        }
        else if (page == 2) {
            _currentIndex++;
            [self reloadView];
        }
        if (_currentIndex != 0 && _currentIndex != _pageCount - 1) {
            if (_scrollDirection == eScrollHorizontally) {
                self.contentOffset = CGPointMake(self.frame.size.width, 0);
            }
            else {
                self.contentOffset = CGPointMake(0, self.frame.size.height);
            }
        }
    }
    
    if ([_efficientDelegate respondsToSelector:@selector(efficientScrollView:pageChanged:)]) {
        [_efficientDelegate efficientScrollView:self pageChanged:_currentIndex];
    }
}

@end
