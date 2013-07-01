//
//  EfficientScrollView.h
//  yibuyiqu
//
//  Created by Yazhi on 19/02/13.
//  Copyright (c) 2013 yibuyiqu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EfficientScrollViewDelegate <NSObject>

- (UIView *)efficientScrollView:(UIScrollView *) scrollView getViewByIndex:(int)index;

@optional
- (void)efficientScrollView:(UIScrollView *) scrollView pageChanged:(int)index;

@end

typedef enum {
    eScrollHorizontally,
    eScrollVertically
} EfficientScrollDirection;

@interface EfficientScrollView : UIScrollView <UIScrollViewDelegate>
{
    NSMutableArray *_viewArray;
}
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) int pageCount;
@property (nonatomic, weak) id<EfficientScrollViewDelegate> efficientDelegate;
@property (nonatomic, assign) EfficientScrollDirection scrollDirection;
@property (nonatomic, assign) int margin;
- (void)reloadView;
- (UIView *)getCurrentView;
@end
