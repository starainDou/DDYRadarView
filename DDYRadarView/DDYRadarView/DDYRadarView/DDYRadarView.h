#import <UIKit/UIKit.h>

@class DDYRadarView;

#pragma mark - /////////////////////////////////////////// 代理 ///////////////////////////////////////////
//------------------------ 数据源 ------------------------//
@protocol DDYRadarViewDataSource <NSObject>
@optional
/** 点位数量 最大为9 */
- (NSInteger)numberOfPointInRadarView:(DDYRadarView *)radarView;
/** 点位视图 */
- (UIView *)radarView:(DDYRadarView *)radarView viewForIndex:(NSInteger)index;
/** 点位图片 */
- (UIImage *)radarView:(DDYRadarView *)radarView imageForIndex:(NSInteger)index;

@end

//------------------------ 视图代理 ------------------------//
@protocol DDYRadarViewDelegate <NSObject>
@optional
/** 点击点位回调 */
- (void)radarView:(DDYRadarView *)radarView didSelectItemAtIndex:(NSInteger)index;

@end

#pragma mark - /////////////////////////////////////////// 视图 ///////////////////////////////////////////

@interface DDYRadarView : UIView

/** 数据源代理 */
@property (nonatomic, weak) id <DDYRadarViewDataSource> dataSource;
/** 视图代理 */
 @property (nonatomic, weak) id <DDYRadarViewDelegate> delegate;

/** 扇形旋转图片 */
@property (nonatomic, strong) UIImage *sectorImage;
/** 同心圆背景图片 */
@property (nonatomic, strong) UIImage *circleImage;
/** 扇形旋转方向 */
@property (nonatomic, assign) BOOL clockwise;
/** 扇形旋转速度 */
@property (nonatomic, assign) CGFloat speed;

/** 雷达视图对象 */
+ (instancetype)radarViewWithWidth:(CGFloat)width;
/** 开始动画 */
- (void)startScanAnimation;
/** 结束动画 */
- (void)stopScanAnimation;
/** 刷新以展示数据 */
- (void)reloadData;

@end
