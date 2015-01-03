CXFocusView
===========

Basic UIView overlay (for tutorials etc.). Inserts itself under all other subviews and uses `drawRect:` to cover the canvas with a colour and then cut out a CGRect. Based on [CXOverlay](https://github.com/dclelland/CXOverlay).

✓ UIView category convenience methods

    self.view.focusView = [[CXFocusView alloc] init];
    self.view.focusView.backgroundColor = [UIColor orangeColor];
    self.view.focusView = nil;

✓ Supports animation with a crossfade effect.

    [self.view.overlay focusOnView:someView withDuration:1.0];

### Full API:

CXFocusView

    @property (nonatomic, strong) NSArray *views;

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

UIView (CXFocusView)

    @property (readwrite) CXFocusView *focusView;