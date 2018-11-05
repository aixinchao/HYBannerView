//
//  HYBannerView.m
//  HYBannerView
//
//  Created by ios on 2018/11/2.
//  Copyright © 2018年 hy. All rights reserved.
//

#import "HYBannerView.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@interface HYBannerView ()<UIScrollViewDelegate>

/**
 *  轮播滑动scrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  页面指示器pageControl
 */
@property (nonatomic, strong) UIPageControl *pageControl;
/**
 *  视频和图片url
 */
@property (nonatomic, strong) NSArray *dataArray;
/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;
/**
 *  记录数组的下标
 */
@property (nonatomic, assign) NSInteger index;

@end

@implementation HYBannerView

- (void)dealloc {
    NSLog(@"dealloc_____%@",[self class]);
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame withDataArray:nil];
}

- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = dataArray;
        
        [self privateInitPropertys];
        [self privateSetupUI];
        [self privateAddImgViewToScrollView];
    }
    return self;
}

#pragma mark -- Methods
- (void)privateInitPropertys {
    self.backgroundColor = [UIColor clearColor];
}

- (void)privateSetupUI {
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}

- (void)privateAddImgViewToScrollView {
    if (!self.dataArray.count) {
        return;
    }
    [[self.scrollView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    BOOL isMore = ((self.dataArray.count > 1) ? YES : NO);
    int count = (isMore ? 3 : 1);
    for (int i = 0; i < count; i++) {
        NSString *urlString;
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
        imgView.tag = 1000 + i;//添加标记,方便后面找到
        if (isMore) {
            if (i == 0) {
                urlString = [self.dataArray lastObject];
                [imgView sd_setImageWithURL:[NSURL URLWithString:[self.dataArray lastObject]]];
            } else if (i == 1) {
                urlString = [self.dataArray firstObject];
                [imgView sd_setImageWithURL:[NSURL URLWithString:[self.dataArray firstObject]]];
            } else {
                urlString = self.dataArray[1];
                [imgView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[1]]];
            }
        } else {
            urlString = [self.dataArray firstObject];
            [imgView sd_setImageWithURL:[NSURL URLWithString:[self.dataArray firstObject]]];
        }
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imgView];
        if ([urlString hasSuffix:@".mp4"] || [urlString hasSuffix:@".mp3"] || [urlString hasSuffix:@".avi"] || [urlString hasSuffix:@".wma"] || [urlString hasSuffix:@".mov"]) {
            imgView.image = [self privateGetVideoPreViewImage:[NSURL URLWithString:urlString]];
            [self privateInitPlayButtonImage:imgView];
        }
    }
    if (isMore) {
        self.pageControl.numberOfPages = self.dataArray.count;
        self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0.f);
        [self privateInitTimer];
    } else {
        self.scrollView.scrollEnabled = NO;
    }
}

- (void)privateUpdataImageView:(NSInteger)index {
    UIImageView *imageView1 = (UIImageView *)[self.scrollView viewWithTag:1000];
    [[imageView1 subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    UIImageView *imageView2 = (UIImageView *)[self.scrollView viewWithTag:1001];
    [[imageView2 subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    UIImageView *imageView3 = (UIImageView *)[self.scrollView viewWithTag:1002];
    [[imageView3 subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (index == self.dataArray.count - 1) {
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:self.dataArray[index - 1]]];
        [imageView2 sd_setImageWithURL:[NSURL URLWithString:self.dataArray[index]]];
        [imageView3 sd_setImageWithURL:[NSURL URLWithString:self.dataArray[0]]];
    } else if (index == 0) {
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:self.dataArray.lastObject]];
        [imageView2 sd_setImageWithURL:[NSURL URLWithString:self.dataArray[index]]];
        [imageView3 sd_setImageWithURL:[NSURL URLWithString:self.dataArray[index + 1]]];
    } else {
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:self.dataArray[index - 1]]];
        [imageView2 sd_setImageWithURL:[NSURL URLWithString:self.dataArray[index]]];
        [imageView3 sd_setImageWithURL:[NSURL URLWithString:self.dataArray[index + 1]]];
    }
    if ([self.dataArray[index] hasSuffix:@".mp4"] || [self.dataArray[index] hasSuffix:@".mp3"] || [self.dataArray[index] hasSuffix:@".avi"] || [self.dataArray[index] hasSuffix:@".wma"] || [self.dataArray[index] hasSuffix:@".mov"]) {
        imageView2.image = [self privateGetVideoPreViewImage:[NSURL URLWithString:self.dataArray[index]]];
        [self privateInitPlayButtonImage:imageView2];
    }
}

- (void)privateInitTimer {
    [self publicInvalidateTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)publicInvalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerClick {
    int index = self.scrollView.contentOffset.x / self.frame.size.width + 1;
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * index, 0.f) animated:YES];
}

- (void)privateInitPlayButtonImage:(UIImageView *)imageView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 10;
    button.bounds = CGRectMake(0.f, 0.f, 50.f, 50.f);
    button.center = CGPointMake(imageView.frame.size.width / 2, imageView.frame.size.height / 2);
    [button setImage:[UIImage imageNamed:@"Video"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(privatePlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];
}

- (void)privatePlayButton:(UIButton *)sender {
    [self publicInvalidateTimer];
    self.pageControl.hidden = YES;
    [self.controlView resetControlView];
    NSString *urlString = self.dataArray[sender.tag - 10];
    [self.controlView showTitle:@"标题" coverURLString:urlString fullScreenMode:ZFFullScreenModePortrait];
    ZFAVPlayerManager *palyerManager = [[ZFAVPlayerManager alloc] init];
    self.player = [ZFPlayerController playerWithPlayerManager:palyerManager containerView:[sender superview]];
    self.player.controlView = self.controlView;
    __weak typeof(self) weakSelf = self;
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        
    };
    self.player.playerPlayStatChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
        if (playState == ZFPlayerPlayStatePaused && !weakSelf.player.isFullScreen) {
            weakSelf.pageControl.hidden = NO;
            [weakSelf.player stop];
        }
    };
    self.player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        NSLog(@"播放完成");
        weakSelf.pageControl.hidden = NO;
        [weakSelf.player stop];
    };
    self.player.playerPrepareToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        NSLog(@"准备播放了");
    };
    self.player.assetURL = [NSURL URLWithString:urlString];
}

- (UIImage *)privateGetVideoPreViewImage:(NSURL *)url {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

#pragma mark -- Setter
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self privateAddImgViewToScrollView];
}

#pragma mark -- ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == self.frame.size.width) {
        return;
    }
    if (scrollView.contentOffset.x >= self.frame.size.width * 2) {
        if (self.index == self.dataArray.count - 1) {
            self.index = 0;
        } else {
            self.index ++;
        }
    } else {
        if (self.index == 0) {
            self.index = self.dataArray.count - 1;
        } else {
            self.index --;
        }
    }
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    self.pageControl.currentPage = self.index;
    [self privateUpdataImageView:self.index];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == self.frame.size.width) {
        return;
    }
    if (scrollView.contentOffset.x >= self.frame.size.width * 2) {
        if (self.index == self.dataArray.count - 1) {
            self.index = 0;
        } else {
            self.index ++;
        }
    } else {
        if (self.index == 0) {
            self.index = self.dataArray.count - 1;
        } else {
            self.index --;
        }
    }
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    self.pageControl.currentPage = self.index;
    [self privateUpdataImageView:self.index];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageControl.hidden = NO;
    [self.player stop];
    if (self.dataArray.count > 1) {
        [self publicInvalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.dataArray.count > 1) {
        [self privateInitTimer];
    }
}

#pragma mark -- Property
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(3 * self.frame.size.width, self.frame.size.height);
        _scrollView.contentOffset = CGPointMake(0.f, 0.f);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(40.f, self.frame.size.height - 30.f, self.frame.size.width - 80.f, 20.f)];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.numberOfPages = self.dataArray.count;
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor magentaColor];
        _pageControl.pageIndicatorTintColor = [UIColor orangeColor];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}

@end
