//
//  HYBannerView.h
//  HYBannerView
//
//  Created by ios on 2018/11/2.
//  Copyright © 2018年 hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>

@interface HYBannerView : UIView

/**
 *  播放器
 */
@property (strong, nonatomic) ZFPlayerController *player;
/**
 *  播放器显示View
 */
@property (strong, nonatomic) ZFPlayerControlView *controlView;


- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSArray *)dataArray;


- (void)publicInvalidateTimer;

@end
