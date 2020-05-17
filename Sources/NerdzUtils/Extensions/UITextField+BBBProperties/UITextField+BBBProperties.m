#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "UITextField+BBBProperties.h"
#import <objc/runtime.h>

@implementation UITextField(BBBProperties)

@dynamic BBB_placeholderColor;

- (UIColor *)BBB_placeholderColor {
    return objc_getAssociatedObject(self, @selector(BBB_placeholderColor));
}

- (void)setBBB_placeholderColor:(UIColor *)BBB_placeholderColor {
    objc_setAssociatedObject(self, @selector(BBB_placeholderColor), BBB_placeholderColor, OBJC_ASSOCIATION_RETAIN);
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString: self.placeholder attributes:@{NSForegroundColorAttributeName : BBB_placeholderColor}];
}

@end
