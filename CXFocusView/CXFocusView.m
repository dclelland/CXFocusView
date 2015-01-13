//
//  CXFocusView.m
//  CALX
//
//  Created by Daniel Clelland on 3/01/15.
//  Copyright (c) 2015 Daniel Clelland. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <ObjectiveSugar/ObjectiveSugar.h>
#import <NSObject+KVOBlocks/NSObject+KVOBlocks.h>

#import "CXFocusView.h"

@interface CXFocusView ()

@property (nonatomic, getter=isUpdating) BOOL updating;

- (void)focusViewWillUpdateAnimated:(BOOL)animated;
- (void)focusViewDidUpdateAnimated:(BOOL)animated;

- (void)viewsDidChangeFromViews:(NSArray *)fromViews toViews:(NSArray *)toViews;

@end

@implementation CXFocusView

- (instancetype)init
{
    self = [super init];
    if (self) {
        __block CXFocusView *_self = self;
        [self setObserverBlock:^(NSDictionary *change) {
            [_self viewsDidChangeFromViews:change[NSKeyValueChangeOldKey] toViews:change[NSKeyValueChangeNewKey]];
        } forKeyPath:NSStringFromSelector(@selector(views))];
    }
    return self;
}

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        [self focusOnView:view];
    }
    return self;
}

- (instancetype)initWithViews:(NSArray *)views
{
    self = [super init];
    if (self) {
        [self focusOnViews:views];
    }
    return self;
}

#pragma mark - Lifecycle

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (self.superview) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.superview);
        }];
    }
}

- (void)dealloc
{
    [self setViews:nil];
}

#pragma mark - Observation

- (void)focusViewWillUpdateAnimated:(BOOL)animated
{
    self.updating = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(focusView:willUpdateAnimated:)]) {
        [self.delegate focusView:self willUpdateAnimated:animated];
    }
}

- (void)focusViewDidUpdateAnimated:(BOOL)animated
{
    self.updating = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(focusView:didUpdateAnimated:)]) {
        [self.delegate focusView:self didUpdateAnimated:animated];
    }
}

- (void)viewsDidChangeFromViews:(NSArray *)fromViews toViews:(NSArray *)toViews
{
    if (![fromViews isEqual:[NSNull null]]) {
        [fromViews each:^(UIView *fromView) {
            [fromView setObserverBlock:nil forKeyPath:NSStringFromSelector(@selector(center))];
        }];
    }
    
    if (![toViews isEqual:[NSNull null]]) {
        [toViews each:^(UIView *toView) {
            [toView setObserverBlock:^(NSDictionary *change) {
                [self setNeedsDisplay];
            } forKeyPath:NSStringFromSelector(@selector(center))];
        }];
    }
    
    [self setNeedsDisplay];
}

#pragma mark - Focus on view

- (void)focusOnView:(UIView *)view
{
    [self focusOnViews:@[view]];
}

- (void)focusOnView:(UIView *)view withDuration:(NSTimeInterval)duration
{
    [self focusOnViews:@[view] withDuration:duration];
}

- (void)focusOnView:(UIView *)view withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay
{
    [self focusOnViews:@[view] withDuration:duration andDelay:delay];
}

- (void)focusOnView:(UIView *)view withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay andCompletion:(void (^)(BOOL finished))completion
{
    [self focusOnViews:@[view] withDuration:duration andDelay:delay andCompletion:completion];
}

#pragma mark - Focus on views

- (void)focusOnViews:(NSArray *)views
{
    [self focusViewWillUpdateAnimated:NO];
    [self setViews:views];
    [self focusViewDidUpdateAnimated:NO];
}

- (void)focusOnViews:(NSArray *)views withDuration:(NSTimeInterval)duration
{
    [self focusOnViews:views withDuration:duration andDelay:0.0];
}

- (void)focusOnViews:(NSArray *)views withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay
{
    [self focusOnViews:views withDuration:duration andDelay:delay andCompletion:nil];
}

- (void)focusOnViews:(NSArray *)views withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay andCompletion:(void (^)(BOOL finished))completion
{
    [self focusViewWillUpdateAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isUpdating) {
            [self setViews:views];
            [UIView transitionWithView:self duration:duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [self.layer displayIfNeeded];
            } completion:^(BOOL finished) {
                [self focusViewDidUpdateAnimated:YES];
                if (completion) {
                    completion(finished);
                }
            }];
        }
    });
}

#pragma mark - Clear focus

- (void)clearFocus
{
    [self focusOnViews:nil];
}

- (void)clearFocusWithDuration:(NSTimeInterval)duration
{
    [self focusOnViews:nil withDuration:duration];
}

- (void)clearFocusWithDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay
{
    [self focusOnViews:nil withDuration:duration andDelay:delay];
}

- (void)clearFocusWithDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay andCompletion:(void (^)(BOOL finished))completion
{
    [self focusOnViews:nil withDuration:duration andDelay:delay andCompletion:completion];
}

#pragma mark - Drawing

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.views) {
        [self.views each:^(UIView *view) {
            CGContextClearRect(context, [view.superview convertRect:view.frame toView:self]);
        }];
    }
}

@end

@implementation UIView (CXFocusView)

- (CXFocusView *)focusView
{
    return [self.subviews find:^BOOL(UIView *subview) {
        return [subview isKindOfClass:[CXFocusView class]];
    }];
}

- (void)setFocusView:(CXFocusView *)focusView
{
    [[self.subviews select:^BOOL(UIView *subview) {
        return [subview isKindOfClass:[CXFocusView class]];
    }] each:^(CXFocusView *focusView) {
        [focusView removeFromSuperview];
    }];
    
    [self insertSubview:focusView atIndex:0];
}

@end
