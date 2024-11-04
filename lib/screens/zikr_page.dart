import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:huzurvakti/controller/zikr_controller.dart';
import 'package:huzurvakti/service/google_ads_service/google_ads.dart';
import 'package:huzurvakti/utils/project_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class ZikrPage extends StatefulWidget {
  const ZikrPage({super.key});

  @override
  State<ZikrPage> createState() => _ZikrPageState();
}

class _ZikrPageState extends State<ZikrPage> {
  final ZikrController controller = Get.put(ZikrController());
  GoogleAds ads = GoogleAds();
  @override
  void initState() {
    ads.loadBannerAd(onLoaded: () {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ProjectColor.backgroundColor,
        body: Obx(
          () => Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/zikirmatik.png', width: 300),
                      Positioned(
                          top: 46,
                          right: 80,
                          child: Text(
                            controller.counter.toString(),
                            style: TextStyle(
                              fontFamily: 'Digital7',
                              fontSize: 50,
                              color: ProjectColor.zikrTextColor,
                            ),
                          )),
                      Positioned(
                        bottom: 30,
                        child: GestureDetector(
                          onTap: () => controller.increment(),
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                        ),
                      ),
                      //reset zikirmatik
                      Positioned(
                        right: 76,
                        bottom: 114,
                        child: GestureDetector(
                          onTap: () => Get.defaultDialog(
                            title: context.tr("zikrDeleteTitle"),
                            middleText: context.tr("zikrDeleteText"),
                            textConfirm: context.tr("zikrDeleteConfirm"),
                            textCancel: context.tr("zikrDeleteCancel"),
                            onConfirm: () {
                              controller.reset();
                              Get.back();
                            },
                          ),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.1,
                  ),
                  Visibility(
                    visible: ads.bannerAd != null,
                    child: SizedBox(
                      width: ads.bannerAd?.size.width.toDouble() ?? 0.0,
                      height: ads.bannerAd?.size.height.toDouble() ?? 0.0,
                      child: ads.bannerAd != null
                          ? AdWidget(ad: ads.bannerAd!)
                          : Container(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
