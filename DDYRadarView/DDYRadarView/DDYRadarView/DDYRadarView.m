#import "DDYRadarView.h"
#import "DDYDraw.h"

@interface DDYRadarView ()

@property (nonatomic, strong) UIImageView *circleView;
@property (nonatomic, strong) UIImageView *sectorView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation DDYRadarView

- (UIImageView *)circleView {
    if (!_circleView) {
        _circleView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _circleView;
}

- (UIImageView *)sectorView {
    if (!_sectorView) {
        _sectorView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _sectorView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return _contentView;
}

+ (instancetype)radarViewWithWidth:(CGFloat)width {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, width, width)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.sectorView];
        [self addSubview:self.circleView];
        [self addSubview:self.contentView];
        // 默认值
        self.speed = 120;
        self.clockwise = YES;
        self.circleView.image = [DDYDraw circleWithRect:self.bounds circleNumber:3 color:[UIColor redColor] showSeparator:YES];
        self.sectorView.image = [DDYDraw sectorWithRect:self.bounds startColor:[UIColor redColor] endColor:[UIColor clearColor] angle:60 clockwise:self.clockwise];
    }
    return self;
}

- (void)setSectorImage:(UIImage *)sectorImage {
    _sectorImage = sectorImage;
    self.sectorView.image = _sectorImage;
}

- (void)setCircleImage:(UIImage *)circleImage {
    _circleImage = circleImage;
    self.circleView.image = _circleImage;
}

- (void)startScanAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:(_clockwise?1:-1) * M_PI * 2.];
    animation.duration = 360.f/_speed;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.sectorView.layer addAnimation:animation forKey:@"rotationAnimation"];
}

- (void)stopScanAnimation {
    [self.sectorView.layer removeAnimationForKey:@"rotationAnimation"];
}

#pragma mark 刷新以展示数据
- (void)reloadData
{
    void (^updateConstraints)(UIView *, NSUInteger) = ^(UIView *avatarView, NSUInteger index) {
        dispatch_async(dispatch_get_main_queue(), ^{
            avatarView.frame = CGRectMake(0, 0, 40, 40);
            avatarView.tag = 100+index;

            [avatarView.layer setCornerRadius:(avatarView.bounds.size.width/2.)];
            [avatarView.layer setMasksToBounds:YES];
            [avatarView.layer setBorderWidth:(.7)];
            [avatarView.layer setBorderColor:[UIColor whiteColor].CGColor];
            
            avatarView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTopPointView:)];
            [avatarView addGestureRecognizer:tap];
            
            [self.contentView addSubview:avatarView];
            avatarView.center = [self pointWithIndex:index];
        });
    };
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if ([self.dataSource respondsToSelector:@selector(numberOfPointInRadarView:)]) {
        for (int index=0; index<MIN([self.dataSource numberOfPointInRadarView:self], 9); index++) {
            if ([self.dataSource respondsToSelector:@selector(radarView:viewForIndex:)]) {
                UIView *avatarView = [self.dataSource radarView:self viewForIndex:index];
                updateConstraints(avatarView, index);
            } else if ([self.dataSource respondsToSelector:@selector(radarView:imageForIndex:)]) {
                if ([self.dataSource radarView:self imageForIndex:index]) {
                    UIImageView *avatarView = [[UIImageView alloc] initWithImage:[self.dataSource radarView:self imageForIndex:index]];
                    updateConstraints(avatarView, index);
                }
            }
        }
        
    }
}

- (void)handleTopPointView:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(radarView:didSelectItemAtIndex:)]) {
        [self.delegate radarView:self didSelectItemAtIndex:gesture.view.tag-100];
    }
}

#pragma mark 点位数组
- (CGPoint)pointWithIndex:(NSInteger)index {
    CGPoint points[9];
    CGFloat radiusBig = self.bounds.size.width/2.;
    CGFloat radiusMid = ((3-1)*radiusBig/3);
    CGFloat centerX = self.contentView.center.x;
    CGFloat centerY = self.contentView.center.y;
    points[0] = CGPointMake(centerX+sinf(0*M_PI_4)*radiusBig, centerY-cosf(0*M_PI_4)*radiusBig);
    points[1] = CGPointMake(centerX+sinf(4*M_PI_4)*radiusBig, centerY-cosf(4*M_PI_4)*radiusBig);
    points[2] = CGPointMake(centerX+sinf(6*M_PI_4)*radiusBig, centerY-cosf(6*M_PI_4)*radiusBig);
    points[3] = CGPointMake(centerX+sinf(2*M_PI_4)*radiusBig, centerY-cosf(2*M_PI_4)*radiusBig);
    points[4] = CGPointMake(centerX+sinf(1*M_PI_4)*radiusMid, centerY-cosf(1*M_PI_4)*radiusMid);
    points[5] = CGPointMake(centerX+sinf(3*M_PI_4)*radiusMid, centerY-cosf(3*M_PI_4)*radiusMid);
    points[6] = CGPointMake(centerX+sinf(7*M_PI_4)*radiusMid, centerY-cosf(7*M_PI_4)*radiusMid);
    points[7] = CGPointMake(centerX+sinf(5*M_PI_4)*radiusMid, centerY-cosf(5*M_PI_4)*radiusMid);
    points[8] = CGPointMake(centerX, centerY);
    return points[index];
}

@end

/**
 *  最简单的方式是使用图片，添加旋转动画。
 *  WTF？UI不给弄这样逐步透明的恶心图片？没关系，自己绘制一个。
 *  https://www.jianshu.com/p/c79a68e4eada
 */
