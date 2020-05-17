#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "UIView+BBBProperty.h"
#import <objc/runtime.h>

@implementation UIView(BBBProperty)

@dynamic BBB_percentCorner;

- (CGFloat)BBB_percentCorner {
    return [objc_getAssociatedObject(self, @selector(BBB_percentCorner)) floatValue];
}

- (void)setBBB_percentCorner:(CGFloat)BBB_percentCorner {
    objc_setAssociatedObject(self, @selector(BBB_percentCorner), @(BBB_percentCorner), OBJC_ASSOCIATION_RETAIN);
    [self BBB_setCornerRadius];
}

#pragma mark - Exchenger

- (void)BBB_layoutSubviews {
    [self BBB_layoutSubviews];
    
    if (self.BBB_percentCorner != 0) {
        [self BBB_setCornerRadius];
    }
}

#pragma mark - Private

- (void)BBB_setCornerRadius {
    [self layoutIfNeeded];
    self.layer.cornerRadius = self.bounds.size.height * (self.BBB_percentCorner / 100);
}

#pragma mark - Override

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(layoutSubviews)), class_getInstanceMethod(self, @selector(BBB_layoutSubviews)));
        
    });
}

@end
