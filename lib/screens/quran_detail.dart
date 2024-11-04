// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:huzurvakti/controller/Kuranikerim_controller.dart';

import 'package:huzurvakti/models/sure.dart';
import 'package:huzurvakti/service/google_ads_service/google_ads.dart';
import 'package:huzurvakti/utils/project_colors.dart';

class QuranDetailPage extends StatefulWidget {
  Sure sure;
  QuranDetailPage({super.key, required this.sure});

  @override
  State<QuranDetailPage> createState() => _QuranDetailPageState();
}

class _QuranDetailPageState extends State<QuranDetailPage> {
  KuranikerimController controller = Get.find();
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
      appBar: AppBar(
          title: Visibility(
            visible: ads.bannerAd != null,
            child: SizedBox(
              width: ads.bannerAd?.size.width.toDouble() ?? 0.0,
              height: ads.bannerAd?.size.height.toDouble() ?? 0.0,
              child: ads.bannerAd != null
                  ? AdWidget(ad: ads.bannerAd!)
                  : Container(),
            ),
          ),
          backgroundColor: ProjectColor.appbarColor,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          )),
      body: Obx(
        () => SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      widget.sure.isim!,
                      style: const TextStyle(
                          fontSize: 30, decoration: TextDecoration.underline),
                    ),
                    Text(widget.sure.yer!,
                        style: const TextStyle(fontSize: 20)),
                    // Text(
                    //   widget.sure.aciklama!,
                    //   textAlign: TextAlign.center,
                    //   style: const TextStyle(fontSize: 18),
                    // ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: controller.ayetList.value.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                      controller.ayetList.value[index].ayet
                                          .toString(),
                                      style: const TextStyle(fontSize: 24)),
                                ),
                                Text(
                                  controller.ayetList.value[index].textAr ?? "",
                                  style: const TextStyle(fontSize: 24),
                                ),
                                Text(
                                  textAlign: TextAlign.center,
                                  controller.ayetList.value[index].text ?? "",
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
