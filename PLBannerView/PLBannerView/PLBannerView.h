//
//  PLBannerView.h
//  PLKit
//
//  Created by zpz on 15/12/7.
//  Copyright © 2015年 BigRoc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, PLPageControlAndTitleShowStyle)
{
    PLPageControlAndTitleShowStyleNone,
    PLPageControlShowRightAndTitleShowLeftStyle,
    PLPageControlOnlyShowControlCenterStyle,
    PLPageControlOnlyShowControlLeftStyle,
    PLPageControlOnlyShowControlRightStyle,
    PLPageControlOnlyShowTitleCenterStyle,
};

@class PLBannerView;
@protocol PLBannerViewDelegate <NSObject>
- (void)bannerView:(PLBannerView *)bannerView didSelectedContentAtIndex:(NSUInteger)index;

@end

@protocol PLbannerViewDataSource <NSObject>
- (NSUInteger)numberOfContentInBannerView:(PLBannerView *)bannerView;

- (void)bannerView:(PLBannerView *)bannerView contentImageAtIndex:(NSUInteger)index forView:(UIImageView *)imageView;
- (NSString *)bannerView:(PLBannerView *)bannerView contentTitleAtIndex:(NSUInteger)index;
@end

@interface PLBannerView : UIScrollView
@property (nonatomic, assign) IBInspectable BOOL autoScroll;//是否自动滚动
@property (nonatomic, assign) IBInspectable NSUInteger autoScrollInterval;//自动滚动的时
@property (nonatomic, assign) PLPageControlAndTitleShowStyle pageControlStyle;//pageControl样式
// 占位图，用于网络未加载到图片时
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, weak) IBOutlet id<PLbannerViewDataSource> plBannerDataSource;//数据源
@property (nonatomic, weak) IBOutlet id<PLBannerViewDelegate> plBannerDelegate;

- (void)reloadData;

@end
