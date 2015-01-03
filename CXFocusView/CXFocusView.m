//
//  CXFocusView.m
//  CALX
//
//  Created by Daniel Clelland on 3/01/15.
//  Copyright (c) 2015 Daniel Clelland. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <ObjectiveSugar/ObjectiveSugar.h>

#import "CXFocusView.h"

@interface CXFocusView ()

@property (nonatomic) BOOL waiting;

@end

@implementation CXFocusView

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

#pragma mark - Setters

- (void)setViews:(NSArray *)views
{
    self.waiting = NO;
    if (_views == views) return;
    _views = views;
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
    [self setViews:views];
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
    self.waiting = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.waiting) {
            [self setViews:views];
            [UIView transitionWithView:self duration:duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [self.layer displayIfNeeded];
            } completion:completion];
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
    
    [focusView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
