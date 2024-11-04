import 'dart:io';

import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:huzurvakti/utils/ads_code.dart';

class GoogleAds {
  InterstitialAd? interstitialAd;
  BannerAd? bannerAd;

  void loadInterstitialAd() {
    final adUnitId = Platform.isAndroid
        ? AdsCode.interstitialAdANDROID
        : AdsCode.interstitialAdIOS;

    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            interstitialAd = ad;
            showInterstitialAd();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {},
        ));
  }

  void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.show();
    }
  }

  void loadBannerAd({required Callback onLoaded}) {
    final adBannerUnitId =
        Platform.isAndroid ? AdsCode.bannerAdANDROID : AdsCode.bannerAdIOS;
    bannerAd = BannerAd(
      adUnitId: adBannerUnitId,
      request: const AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
          onLoaded();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }
}
