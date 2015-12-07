轻量级图片轮播器，支持本地和网络两种方式，可以设置标题，配置样式等。
使用仿官方UITableView
- (void)viewDidLoad {
    [super viewDidLoad];
    //IB创建
    _dataSource1 = @[@"0.jpg",@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
    _titles = @[@"红豆生南国",@"春来发几枝",@"人间万事",@"毫发常重泰山轻",@"富贵非吾事"];
    self.bannerView1.pageControlStyle = PLPageControlShowRightAndTitleShowLeftStyle;
    
    
    //代码创建
    _dataSource2 = @[
                     @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                     @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                     @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                     ];
    self.bannerView2 = [[PLBannerView alloc] init];
    self.bannerView2.frame = CGRectMake(0, CGRectGetMaxY(_bannerView1.frame) + 50, CGRectGetWidth(_bannerView1.frame), CGRectGetHeight(_bannerView1.frame));
    self.bannerView2.plBannerDataSource = self;
    self.bannerView2.plBannerDelegate = self;
    self.bannerView2.pageControlStyle = PLPageControlOnlyShowControlCenterStyle;
    self.bannerView2.autoScrollInterval = 6;
    [self.view addSubview:self.bannerView2];
}

- (NSUInteger)numberOfContentInBannerView:(PLBannerView *)bannerView
{
    if (bannerView == self.bannerView1) {
        return _dataSource1.count;
    } else {
        return _dataSource2.count;
    }
}

- (void)bannerView:(PLBannerView *)bannerView contentImageAtIndex:(NSUInteger)index forView:(UIImageView *)imageView
{
    if (bannerView == self.bannerView1) {
        imageView.image = [UIImage imageNamed:_dataSource1[index]];
    } else {
        [imageView setImageWithURL:[NSURL URLWithString:_dataSource2[index]] placeholderImage:[UIImage imageNamed:@"place"] options:SDWebImageProgressiveDownload];
    }
}

- (NSString *)bannerView:(PLBannerView *)bannerView contentTitleAtIndex:(NSUInteger)index
{
    if (bannerView == self.bannerView1) {
        return _titles[index];
    } else {
        return _dataSource2[index];
    }
}

- (void)bannerView:(PLBannerView *)bannerView didSelectedContentAtIndex:(NSUInteger)index
{
    NSLog(@"第%ld张被选中了",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
