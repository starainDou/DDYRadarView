#import <UIKit/UIKit.h>

@interface DDYDraw : NSObject
/** 画一个扇形用于旋转 */
+ (UIImage *)sectorWithRect:(CGRect)rect startColor:(UIColor *)startColor endColor:(UIColor *)endColor angle:(CGFloat)angle clockwise:(BOOL)clockwise;
/** 画同心圆和分割线 */
+ (UIImage *)circleWithRect:(CGRect)rect circleNumber:(NSUInteger)circleNumber color:(UIColor *)color showSeparator:(BOOL)show;

@end
