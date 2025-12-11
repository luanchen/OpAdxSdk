//
//  AdConfig.m
//  OpAdxDemo_iOS
//
//  Created by Luan Chen on 2025/12/10.
//

#import "AdConfig.h"


@implementation AdConfig

+ (BOOL)useTestAd {
    return YES; // test
}

+ (BOOL)useAndroidConfig {
    return NO; // test
}

+ (BOOL)useTestServer {
    return [AdConfig useTestServer] && [AdConfig useAndroidConfig]; // test
}

+ (NSString *)applicationId {
    return @"pub13423013211200/ep13423013211584/app14170937163904";
}

+ (NSString *)iOSAppId {
    return @"1444253128";
}

// iOS Placement IDs
static NSString *const nativePlacementId = @"s14198263063424";
static NSString *const bannerPlacementId = @"s14170965187264";
static NSString *const bannerVideoPlacementId = @"s14198605602880";
static NSString *const interstitialPlacementId = @"s14198264979520";
static NSString *const interstitialVideoPlacementId = @"s14198603681728";
static NSString *const rewardedPlacementId = @"s14198592226752";

// Android Configs
+ (NSString *)android_applicationId {
    return [AdConfig useTestServer] ?
        @"pub13124398458816/ep13374306271488/app13336434553408" :
        @"pub13423013211200/ep13423013211584/app13423536670400";
}

+ (NSString *)android_nativePlacementId {
    return [AdConfig useTestServer] ? @"s13336452960512" : @"s13429368154496";
}
+ (NSString *)android_bannerPlacementId {
    return [AdConfig useTestServer] ? @"s13336445508160" : @"s13423621779136";
}
+ (NSString *)android_bannerVideoPlacementId {
    return [AdConfig useTestServer] ? @"s13391091037312" : @"s13429297184768";
}
+ (NSString *)android_interstitialPlacementId {
    return [AdConfig useTestServer] ? @"s13391104307072" : @"s13423624619200";
}
+ (NSString *)android_interstitialVideoPlacementId {
    return [AdConfig useTestServer] ? @"s13391097365952" : @"s13424442482432";
}
+ (NSString *)android_rewardedPlacementId {
    return [AdConfig useTestServer] ? @"s13584962043136" : @"s13938889680960";
}


+ (NSString *)getPlacementIdWithAdFormat:(AdFormat)adFormat forceVideo:(BOOL)forceVideo {
    if ([AdConfig useAndroidConfig]) {
        switch (adFormat) {
            case AdFormatNative:
                return [AdConfig android_nativePlacementId];
            case AdFormatBanner:
                return forceVideo ? [AdConfig android_bannerVideoPlacementId] : [AdConfig android_bannerPlacementId];
            case AdFormatInterstitial:
                return forceVideo ? [AdConfig android_interstitialVideoPlacementId] : [AdConfig android_interstitialPlacementId];
            case AdFormatReward:
                return [AdConfig android_rewardedPlacementId];
            default:
                return @"";
        }
    } else {
        switch (adFormat) {
            case AdFormatNative:
                return nativePlacementId;
            case AdFormatBanner:
                return forceVideo ? bannerVideoPlacementId : bannerPlacementId;
            case AdFormatInterstitial:
                return forceVideo ? interstitialVideoPlacementId : interstitialPlacementId;
            case AdFormatReward:
                return rewardedPlacementId;
            default:
                return @"";
        }
    }
}

@end
