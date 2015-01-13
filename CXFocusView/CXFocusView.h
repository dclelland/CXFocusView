//
//  CXFocusView.h
//  CALX
//
//  Created by Daniel Clelland on 3/01/15.
//  Copyright (c) 2015 Daniel Clelland. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CXFocusView;

@protocol CXFocusViewDelegate <NSObject>

@optional
- (void)focusView:(CXFocusView *)focusView willUpdateAnimated:(BOOL)animated;
- (void)focusView:(CXFocusView *)focusView didUpdateAnimated:(BOOL)animated;

@end

@interface CXFocusView : UIView

@property (nonatomic, strong) NSArray *views;

@property (unsafe_unretained) id <CXFocusViewDelegate> delegate;

- (instancetype)initWithView:(UIView *)view;
- (instancetype)initWithViews:(NSArray *)views;

- (void)focusOnView:(UIView *)view;
- (void)focusOnView:(UIView *)view withDuration:(NSTimeInterval)duration;
- (void)focusOnView:(UIView *)view withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay;
- (void)focusOnView:(UIView *)view withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay andCompletion:(void (^)(BOOL finished))completion;

- (void)focusOnViews:(NSArray *)views;
- (void)focusOnViews:(NSArray *)views withDuration:(NSTimeInterval)duration;
- (void)focusOnViews:(NSArray *)views withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay;
- (void)focusOnViews:(NSArray *)views withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay andCompletion:(void (^)(BOOL finished))completion;

- (void)clearFocus;
- (void)clearFocusWithDuration:(NSTimeInterval)duration;
- (void)clearFocusWithDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay;
- (void)clearFocusWithDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay andCompletion:(void (^)(BOOL finished))completion;

@end

@interface UIView (CXFocusView)

@property (readwrite) CXFocusView *focusView;

@end