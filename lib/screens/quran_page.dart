import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huzurvakti/controller/Kuranikerim_controller.dart';
import 'package:huzurvakti/screens/quran_detail.dart';
import 'package:huzurvakti/service/google_ads_service/google_ads.dart';
import 'package:huzurvakti/utils/project_colors.dart';

import '../models/sure.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  KuranikerimController controller = Get.put(KuranikerimController());
  GoogleAds ads = GoogleAds();

  Future<void> init() async {}
  @override
  void initState() {
    ads.loadInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColor.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/kk.png'),
            Obx(
              () => ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.sureList.value.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        controller.selectedSure.value =
                            controller.sureList.value[index].sure!;
                        await controller.getAyetList();
                        Sure sure = controller.sureList.value[index];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuranDetailPage(sure: sure),
                          ),
                        );
                      },
                      child: Card(
                          color: Colors.green.shade50,
                          child: Container(
                              height: Get.height * 0.1,
                              margin: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${index + 1} - ${controller.sureList.value[index].isim!}",
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    "${controller.sureList.value[index].ayetSayisi!} ayet",
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ))),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
