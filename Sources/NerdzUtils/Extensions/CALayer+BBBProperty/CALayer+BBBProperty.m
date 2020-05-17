#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#import "CALayer+BBBProperty.h"

@implementation CALayer(BBBProperty)

#pragma mark -  Property

- (void)setBBB_borderColor:(UIColor *)BBB_borderColor {
    self.borderColor = BBB_borderColor.CGColor;
}

- (UIColor*)BBB_borderColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
