//
//  BannerViewController.m
//  OpAdxDemo_iOS
//
//  Created by Luan Chen on 2025/12/10.
//

#import "BannerViewController.h"
#import <OpAdxSdk/OpAdxSdk-Swift.h>


@interface BannerViewController()<OpAdxBannerAdDelegate>

@property (nonatomic, strong, nullable) OpAdxBannerAdBridge *bannerAdView;

@end

@implementation BannerViewController

- (BOOL)hasVideo {
    return YES;
}

- (NSString *)adFormatString {
    return @"Banner Ad";
}

- (void)loadAd {
    [self destroyAd];
    
    __weak typeof(self) weakSelf = self;
    NSString *placementID = self.placementId;
    
    OpAdxBannerAdBridge *bannerAd = [[OpAdxBannerAdBridge alloc] initWithPlacementId:placementID adSize:OpAdxAdSize.BANNER_MREC];
    self.bannerAdView = bannerAd;
    bannerAd.presentingViewControllerProvider = ^UIViewController * _Nullable{
        return weakSelf;
    };
    bannerAd.delegate = self;
    [bannerAd loadAd];
}

- (void)showAd {
    if (!self.bannerAdView) return;

#ifdef DEBUG
    // Debug 模式下不检查 isAdInvalidated
#else
    if (self.bannerAdView.isAdInvalidated) {
        [self.logView print:@"Ad is invalidated"];
        [self destroyAd];
        return;
    }
#endif
    
    UIView *bannerAdView = self.bannerAdView;
    bannerAdView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.adContainer addSubview:bannerAdView];
    NSArray<NSLayoutConstraint *> *constraints = @[
        // 图标
        [bannerAdView.centerXAnchor constraintEqualToAnchor:self.adContainer.centerXAnchor],
        [bannerAdView.centerYAnchor constraintEqualToAnchor:self.adContainer.centerYAnchor],
        [bannerAdView.widthAnchor constraintEqualToAnchor:self.adContainer.widthAnchor],
        [bannerAdView.heightAnchor constraintEqualToAnchor:self.adContainer.heightAnchor],
    ];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    [self enableDestroyAd];
    [self disableShowAd];
}

- (void)destroyAd {
    [super destroyAd];
    [self.bannerAdView destroy];
    self.bannerAdView = nil;
    
    [self disableShowAd];
    [self disableDestroyAd];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.bannerAdView pause];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.bannerAdView resume];
}

#pragma mark - OpAdxBannerAdDelegate

- (void)bannerAdDidLoad:(OpAdxBannerAdBridge *)bannerAd {
    NSLog(@"[ADX] Banner广告加载成功: %@", bannerAd.placementID);
    
    [self.logView print:[NSString stringWithFormat:@"Loaded, adSize: %@ ", bannerAd.adSize]];
   
    [self enableShowAd];
    [self enableDestroyAd];
    
}

- (void)bannerAd:(OpAdxBannerAdBridge *)bannerAd didFailWithError:(NSError *)error {
    NSLog(@"[ADX] Banner广告加载失败: %@", error);
    [self.logView print:error.localizedDescription];
    
}

- (void)bannerAdDidClick:(OpAdxBannerAdBridge *)bannerAd {
    NSLog(@"[ADX] Banner广告被点击: %@", bannerAd.placementID);
    [self.logView print:@"onAdClicked"];
}

- (void)bannerAdWillLogImpression:(OpAdxBannerAdBridge *)bannerAd {
    NSLog(@"[ADX] Banner广告展示: %@", bannerAd.placementID);
    [self.logView print:@"onAdImpression"];
    
}

- (void)dealloc {
    [self.bannerAdView destroy];
    self.bannerAdView = nil;
}

@end
