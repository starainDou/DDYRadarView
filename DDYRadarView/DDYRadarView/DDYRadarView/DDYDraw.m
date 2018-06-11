#import "DDYDraw.h"
/** 沙盒Document路径 */
#define DDYPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

@implementation DDYDraw

+ (UIImage *)sectorWithRect:(CGRect)rect startColor:(UIColor *)startColor endColor:(UIColor *)endColor angle:(CGFloat)angle clockwise:(BOOL)clockwise {
    CGFloat width = rect.size.width;
    UIGraphicsBeginImageContext(CGSizeMake(width, width));
    CGContextRef context = UIGraphicsGetCurrentContext();
    const CGFloat *startColorComponents = CGColorGetComponents(startColor.CGColor);
    const CGFloat *endColorComponents = CGColorGetComponents(endColor.CGColor);
    
    for (int i=0; i<angle; i++) {
        CGFloat ratio = (clockwise?(angle-i):i)/angle;
        CGFloat r = startColorComponents[0] - (startColorComponents[0]-endColorComponents[0])*ratio;
        CGFloat g = startColorComponents[1] - (startColorComponents[1]-endColorComponents[1])*ratio;
        CGFloat b = startColorComponents[2] - (startColorComponents[2]-endColorComponents[2])*ratio;
        CGFloat a = startColorComponents[3] - (startColorComponents[3]-endColorComponents[3])*ratio;
        // 画扇形
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)].CGColor);
        CGContextSetLineWidth(context, 0);
        CGContextMoveToPoint(context, width/2., width/2.);
        CGContextAddArc(context, width/2., width/2., width/2.,  i*M_PI/180, (i + (clockwise?-1:1))*M_PI/180, clockwise);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    UIImage *tempSectorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tempSectorImage;
}

+ (UIImage *)circleWithRect:(CGRect)rect circleNumber:(NSUInteger)circleNumber color:(UIColor *)color showSeparator:(BOOL)show {
    CGFloat width = rect.size.width;
    UIGraphicsBeginImageContext(CGSizeMake(width, width));
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i=0; i<circleNumber; i++) {
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, 1.);
        CGContextAddArc(context, width/2., width/2., (width/2.)*(i+1)/circleNumber, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    if (show) {
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, .7);
        CGFloat dashLength[] = {5, 5};
        CGContextSetLineDash(context, 0, dashLength, 2);
        
        for (int i=0; i<4; i++) {
            CGContextMoveToPoint(context, width/2.+sinf(i*M_PI_4)*(width/2.), width/2.-cosf(i*M_PI_4)*(width/2.));
            CGContextAddLineToPoint(context, width/2.+sinf((i+4)*M_PI_4)*(width/2.), width/2.-cosf((i+4)*M_PI_4)*(width/2.));
        }
        CGContextStrokePath(context);
    }
    UIImage *tempCircleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tempCircleImage;
}

/** 可以把图片缓存 @"DDYRadarImage.png" @"DDYCircleImage.png" */
+ (void)saveImage:(UIImage *)image imageName:(NSString *)imageName {
    NSString *path = [DDYPathDocument stringByAppendingPathComponent:imageName];
    [[NSFileManager defaultManager] createFileAtPath:path contents:UIImagePNGRepresentation(image) attributes:nil];
}

+ (UIImage *)getImageWithImageName:(NSString *)imageName {
    NSString *path = [DDYPathDocument stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

@end

/** 如果UI不给提供图片咱们程序员(媛)可以生成 */
