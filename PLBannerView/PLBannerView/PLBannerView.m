//
//  PLBannerView.m
//  PLKit
//
//  Created by zpz on 15/12/7.
//  Copyright © 2015年 BigRoc. All rights reserved.
//

#import "PLBannerView.h"

@interface PLBannerView ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIImageView *imageView1;
@property (nonatomic, strong)UIImageView *imageView2;
@property (nonatomic, strong)UIImageView *imageView3;

@property (nonatomic, assign) NSUInteger currentPage;  //当前显示图片的index
@property (nonatomic, strong) NSTimer *autoScrollTimer;//自动轮播定时器
@property (nonatomic, assign) NSUInteger numberOfImage;//图片总数量

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *footBgView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *titleLabel;

//@property (nonatomic, strong) NSArray *titles;
@end

@implementation PLBannerView
{
    BOOL _isInit;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _imageView1 = [[UIImageView alloc] init];
    _imageView1.contentMode = UIViewContentModeScaleAspectFill;
    _imageView1.clipsToBounds = YES;
    [self addSubview:_imageView1];
    
    _imageView2 = [[UIImageView alloc] init];
    _imageView2.contentMode = UIViewContentModeScaleAspectFill;
    _imageView2.clipsToBounds = YES;
    [self addSubview:_imageView2];

    _imageView3 = [[UIImageView alloc] init];
    _imageView3.contentMode = UIViewContentModeScaleAspectFill;
    _imageView3.clipsToBounds = YES;
    [self addSubview:_imageView3];
    
    _imageView2.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    [_imageView2 addGestureRecognizer:tapGesture];
    
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    
    self.autoScroll = YES;
    self.autoScrollInterval = 3.f;
    self.currentPage = 0;
    self.pageControlStyle = PLPageControlOnlyShowTitleCenterStyle;
    _footBgView = [[UIView alloc] init];
    
    _coverView = [[UIView alloc] init];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.2f;
    [_footBgView addSubview:_coverView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.text = @"";
    [_footBgView addSubview:_titleLabel];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [_footBgView addSubview:_pageControl];

}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.autoScroll) {
        [self initAutoScrollTimer];
    }

}

- (void)layoutSubviews
{
    if (!_isInit) {
        _isInit = YES;
        
        CGFloat x = self.frame.origin.x;
        CGFloat y = self.frame.origin.y;
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        
        self.contentSize = CGSizeMake(width * 3, height);
        self.contentOffset = CGPointMake(width, 0);//一直显示第二页
        _imageView1.frame = CGRectMake(0, 0, width, height);
        _imageView2.frame = CGRectMake(width, 0, width, height);
        _imageView3.frame = CGRectMake(width * 2, 0, width, height);
        
        _footBgView.frame = CGRectMake(x, y + height - height * 0.126, width, height * 0.126);
        [self.superview addSubview:_footBgView];
        
        [self layoutFootViewSubViewsWithPageControlAndTitleShowStyle:_pageControlStyle];
       
        
        [self reloadData];
        [self reloadImages];
    }
    [super layoutSubviews];
}

- (void)layoutFootViewSubViewsWithPageControlAndTitleShowStyle:(PLPageControlAndTitleShowStyle)style
{
    _coverView.hidden = NO;
    _titleLabel.hidden = NO;
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _pageControl.hidden = NO;
    CGFloat width = CGRectGetWidth(self.frame);
    _coverView.frame = self.footBgView.bounds;
    _titleLabel.frame = CGRectMake(10, 0, _footBgView.bounds.size.width - 20, _footBgView.bounds.size.height);
    _pageControl.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) - width * 0.15 - 20, 0, width * 0.15, _footBgView.bounds.size.height);
    
    switch (style) {
        case PLPageControlAndTitleShowStyleNone:
            _coverView.hidden = YES;
            _titleLabel.hidden = YES;
            _pageControl.hidden = YES;
            break;
        case PLPageControlShowRightAndTitleShowLeftStyle:
            break;
        case PLPageControlOnlyShowControlCenterStyle:
            _titleLabel.hidden = YES;
            _coverView.hidden = YES;
            CGPoint point = _pageControl.center;
            point.x = width * 0.5;
            _pageControl.center = CGPointMake(width * 0.5, _footBgView.frame.size.height * 0.5);
            break;
        case PLPageControlOnlyShowControlLeftStyle:
            _coverView.hidden = YES;
            _titleLabel.hidden = YES;
            CGRect rect = _pageControl.frame;
            rect.origin.x = _titleLabel.frame.origin.x;
            _pageControl.frame = rect;
            break;
        case PLPageControlOnlyShowControlRightStyle:
            _coverView.hidden = YES;
            _titleLabel.hidden = YES;
            CGRect rect1 = _pageControl.frame;
            rect.origin.x = _titleLabel.frame.origin.x + _titleLabel.frame.size.width;
            _pageControl.frame = rect1;

            break;
        case PLPageControlOnlyShowTitleCenterStyle:
            _pageControl.hidden = YES;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            break;
            

    }
}

#pragma mark - setMethod
- (void)setAutoScrollInterval:(NSUInteger)autoScrollInterval
{
    _autoScrollInterval = autoScrollInterval > 0.25f ? autoScrollInterval
    : 3.f;
}

- (void)setPlBannerDataSource:(id<PLbannerViewDataSource>)plBannerDataSource
{
    _plBannerDataSource = plBannerDataSource;
}
- (void)setPageControlStyle:(PLPageControlAndTitleShowStyle)pageControlStyle
{
    _pageControlStyle = pageControlStyle;
    [self layoutFootViewSubViewsWithPageControlAndTitleShowStyle:_pageControlStyle];
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.autoScrollTimer invalidate];
    self.autoScrollTimer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self initAutoScrollTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    if (page == 2) {
    //向左滑动了一张图片的时候
    _currentPage = _currentPage == self.numberOfImage - 1 ? 0 : _currentPage + 1;
    } else if (page == 0) {
        //向右滑动了一张图片的时候
        _currentPage = _currentPage == 0 ? self.numberOfImage - 1 : _currentPage - 1;
    }
    
    [self reloadImages];
    
    self.contentOffset = CGPointMake(self.bounds.size.width, 0);
}
/**
 *  布局图片
 */
- (void)reloadImages
{
    if (!self.numberOfImage){
        return;
    }
    [self.plBannerDataSource bannerView:self contentImageAtIndex:_currentPage == 0 ? self.numberOfImage - 1 : _currentPage - 1  forView:_imageView1];
    [self.plBannerDataSource bannerView:self contentImageAtIndex:_currentPage  forView:_imageView2];
    [self.plBannerDataSource bannerView:self contentImageAtIndex:_currentPage == self.numberOfImage - 1 ? 0 : _currentPage + 1   forView:_imageView3];
    
    _titleLabel.text = [self.plBannerDataSource bannerView:self contentTitleAtIndex:_currentPage];
    
    _pageControl.currentPage = _currentPage;

}

- (void)reloadData
{
    NSUInteger count = [self.plBannerDataSource numberOfContentInBannerView:self];
    self.numberOfImage = count;
    _pageControl.numberOfPages = self.numberOfImage;
}

- (void)imageViewTapped:(UITapGestureRecognizer *)tap
{
    if (self.plBannerDelegate && [self.plBannerDelegate respondsToSelector:@selector(bannerView:didSelectedContentAtIndex:)]) {
        [self.plBannerDelegate bannerView:self didSelectedContentAtIndex:self.currentPage];
    }
}

#pragma mark timer 相关方法
- (void)initAutoScrollTimer
{
    if (!_autoScrollTimer.isValid) {
        _autoScrollTimer = [NSTimer timerWithTimeInterval:self.autoScrollInterval target:self selector:@selector(autoScrollTimerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_autoScrollTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)autoScrollTimerFired:(NSTimer *)timer{
    [UIView animateWithDuration:0.8f
                     animations:^{
                         self.contentOffset = CGPointMake(2 * self.bounds.size.width, 0);
                     }
                     completion:^(BOOL finished) {
                         [self scrollViewDidEndDecelerating:self];
                     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
