/*
 * This file is part of the BLLandscape package.
 * (c) NewPan <13246884282@163.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * Click https://github.com/newyjp
 * or http://www.jianshu.com/users/e2f2d779c022/latest_articles to contact me.
 */

#import <UIKit/UIKit.h>

// 横竖屏动画执行完的回调.
typedef void(^BLScreenEventsComplete)(void);
// 横竖屏动画执行的回调.
typedef void(^BLScreenEventsAnimations)(void);

@interface UIView (BLLandscape)

typedef NS_ENUM(NSInteger, BLLandscapeViewStatus) {
    BLLandscapeViewStatusPortrait = 0,
    BLLandscapeViewStatusLandscape,
    BLLandscapeViewStatusAnimating
};

/**
 * 横竖屏状态.
 */
@property(nonatomic, readonly) BLLandscapeViewStatus viewStatus;

/**
 * 横屏.
 * @watchout : 当前界面会被添加到窗口 Window 上.
 *
 * @param animated   是否需要动画.
 * @param animations 横屏动画执行过程中需要额外添加的动画代码.
 * @param complete   横屏动画执行完的回调.
 */
- (void)bl_landscapeAnimated:(BOOL)animated animations:(BLScreenEventsAnimations)animations complete:(BLScreenEventsComplete)complete;

/**
 * 竖屏.
 *
 * @param animated   是否需要动画.
 * @param animations 竖屏动画执行过程中需要额外添加的动画代码.
 * @param complete   竖屏动画执行完的回调.
 */
- (void)bl_protraitAnimated:(BOOL)animated animations:(BLScreenEventsAnimations)animations complete:(BLScreenEventsComplete)complete;

@end
