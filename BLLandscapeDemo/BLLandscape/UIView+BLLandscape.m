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

#import "UIView+BLLandscape.h"
#import "BLSubstituteObject.h"
#import <objc/runtime.h>

@interface UIView ()

/**
 * 横竖屏状态.
 */
@property(nonatomic) BLLandscapeViewStatus viewStatus;

/**
 * Frame of self before enter full screen.
 */
@property(nonatomic)NSValue *frame_beforeFullScreen;

/**
 * 动画之前 self 在 superview 的索引.
 */
@property(nonatomic) NSInteger indexBeforeAnimation;

@end

@implementation UIView (BLLandscape)

- (void)bl_landscapeAnimated:(BOOL)animated animations:(BLScreenEventsAnimations)animations complete:(BLScreenEventsComplete)complete{
    if (self.viewStatus != BLLandscapeViewStatusPortrait) {
        return;
    }
    
    self.viewStatus = BLLandscapeViewStatusAnimating;
    
    self.parentViewBeforeFullScreenSubstitute.anyObject = self.superview;
    self.frame_beforeFullScreen = [NSValue valueWithCGRect:self.frame];
    NSArray *subviews = self.superview.subviews;
    if (subviews.count == 1) {
        self.indexBeforeAnimation = 0;
    }
    else{
        for (int i = 0; i < subviews.count; i++) {
            id object = subviews[i];
            if (object == self) {
                self.indexBeforeAnimation = i;
                break;
            }
        }
    }
    
    CGRect rectInWindow = [self.superview convertRect:self.frame toView:nil];
    [self removeFromSuperview];
    self.frame = rectInWindow;
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    if (animated) {
        [UIView animateWithDuration:0.35 animations:^{
            
            [self landscapeExecute];
            if (animations) {
                animations();
            }
            
        } completion:^(BOOL finished) {
            
            [self landscpeFinishedComplete:complete];
            
        }];
    }
    else{
        [self landscapeExecute];
        [self landscpeFinishedComplete:complete];
    }
    
    self.viewStatus = BLLandscapeViewStatusLandscape;
    [self refreshStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)bl_protraitAnimated:(BOOL)animated animations:(BLScreenEventsAnimations)animations complete:(BLScreenEventsComplete)complete{
    if (self.viewStatus != BLLandscapeViewStatusLandscape) {
        return;
    }
    
    self.viewStatus = BLLandscapeViewStatusAnimating;
    
    if (animated) {
        [UIView animateWithDuration:0.35 animations:^{
            
            [self portraitExecute];
            if (animations) {
                animations();
            }
            
        } completion:^(BOOL finished) {
            
            [self portraitFinishedComplete:complete];
            
        }];
    }
    else{
        [self portraitExecute];
        [self portraitFinishedComplete:complete];
    }
   
    self.viewStatus = BLLandscapeViewStatusPortrait;
    [self refreshStatusBarOrientation:UIInterfaceOrientationPortrait];
}


#pragma mark - Private

- (void)portraitFinishedComplete:(BLScreenEventsComplete)complete{
    [self removeFromSuperview];
    self.frame = [self.frame_beforeFullScreen CGRectValue];
    if (self.parentViewBeforeFullScreenSubstitute.anyObject) {
        [(UIView *)self.parentViewBeforeFullScreenSubstitute.anyObject insertSubview:self atIndex:self.indexBeforeAnimation];
    }
    
    if (complete) {
        complete();
    }
}

- (void)portraitExecute{
    CGRect frame = [self.parentViewBeforeFullScreenSubstitute.anyObject convertRect:[self.frame_beforeFullScreen CGRectValue] toView:nil];
    self.transform = CGAffineTransformIdentity;
    self.frame = frame;
}

- (void)landscpeFinishedComplete:(BLScreenEventsComplete)complete{
    if (complete) {
        complete();
    }
}

- (void)landscapeExecute{
    self.transform = CGAffineTransformMakeRotation(M_PI_2);
    CGRect bounds = CGRectMake(0, 0, CGRectGetHeight(self.superview.bounds), CGRectGetWidth(self.superview.bounds));
    CGPoint center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
    self.bounds = bounds;
    self.center = center;
}

-(void)refreshStatusBarOrientation:(UIInterfaceOrientation)interfaceOrientation {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:YES];
#pragma clang diagnostic pop
}

-(void)setViewStatus:(BLLandscapeViewStatus)viewStatus{
    objc_setAssociatedObject(self, @selector(viewStatus), @(viewStatus), OBJC_ASSOCIATION_ASSIGN);
}

-(BLLandscapeViewStatus)viewStatus{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (BLSubstituteObject *)parentViewBeforeFullScreenSubstitute{
    BLSubstituteObject *object = objc_getAssociatedObject(self, _cmd);
    if (!object) {
        object = [BLSubstituteObject new];
        objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return object;
}

-(void)setFrame_beforeFullScreen:(NSValue *)frame_beforeFullScreen{
    objc_setAssociatedObject(self, @selector(frame_beforeFullScreen), frame_beforeFullScreen, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSValue *)frame_beforeFullScreen{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setIndexBeforeAnimation:(NSInteger)indexBeforeAnimation{
    objc_setAssociatedObject(self, @selector(indexBeforeAnimation), @(indexBeforeAnimation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)indexBeforeAnimation{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end
