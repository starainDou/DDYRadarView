# DDYRadarView

* 一个扫描雷达样式图
* 可以添加自定义扇形图片，如果你们UI设计人员足够懒，而你这个程序员(媛)足够勤快，可以自己生成
* 还有背景图
* 顺便添加了一些展示头像，并且可以点击回调
* 可以设定旋转速度（角度/s）
* 顺时针还是逆时针都没问题

![DDYRadarView.png](https://github.com/starainDou/DDYDemoImage/blob/master/DDYRadarView.png)


```
- (DDYRadarView *)radarView {
    if (!_radarView) {
        _radarView = [DDYRadarView radarViewWithWidth:self.view.bounds.size.width-40];
        _radarView.center = CGPointMake(self.view.bounds.size.width/2., self.view.bounds.size.height/2.);
        _radarView.circleImage = [DDYDraw circleWithRect:_radarView.bounds circleNumber:3 color:[UIColor yellowColor] showSeparator:YES];
        _radarView.sectorImage = [DDYDraw sectorWithRect:_radarView.bounds startColor:[UIColor yellowColor] endColor:[UIColor colorWithRed:1 green:1 blue:0 alpha:0.2] angle:60 clockwise:YES];
        _radarView.speed = 120;
        _radarView.clockwise = YES;
        _radarView.dataSource = self;
        _radarView.delegate = self;
    }
    return _radarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer setContents:(__bridge id)[UIImage imageNamed:@"radarBg"].CGImage];
    [self.view addSubview:self.radarView];
    [self.radarView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.radarView startScanAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.radarView stopScanAnimation];
}

#pragma mark - DDYRadarViewDataSource & DDYRadarViewDelegate
- (NSInteger)numberOfPointInRadarView:(DDYRadarView *)radarView {
    return 9;
}

- (UIView *)radarView:(DDYRadarView *)radarView viewForIndex:(NSInteger)index {
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    tempView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
    return tempView;
}

- (void)radarView:(DDYRadarView *)radarView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"click index:%ld",(long)index);
}
```
