import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'package:huzurvakti/controller/hadith_controller.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:huzurvakti/utils/project_colors.dart';
import 'package:easy_localization/easy_localization.dart';

class HadithPage extends StatefulWidget {
  const HadithPage({Key? key}) : super(key: key);

  @override
  State<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> {
  HadithController controller = Get.put(HadithController());
  bool isBack = true;
  double angle = 0;

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    String hadithText = context.tr('defaultHadith');
    return Scaffold(
      backgroundColor: ProjectColor.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _flip,
                  child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: angle),
                      duration: const Duration(seconds: 1),
                      builder: (BuildContext context, double val, __) {
                        if (val >= (pi / 2)) {
                          isBack = false;
                        } else {
                          isBack = true;
                        }
                        return (Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(val),
                          child: SizedBox(
                              width: Get.width * 0.95,
                              height: Get.height * 0.70,
                              child: isBack
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        image: const DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                              "assets/images/question.png"),
                                        ),
                                      ),
                                    )
                                  : Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..rotateY(pi),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          image: const DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                "assets/images/back.png"),
                                          ),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 35, 15, 0),
                                            child: Obx(() {
                                              if (controller.items.isEmpty ||
                                                  controller.index.value < 0 ||
                                                  controller.index.value >=
                                                      controller.items.length) {
                                                return Html(
                                                  data: '''
                   $hadithText 
                  ''',
                                                  style: {
                                                    'body': Style(
                                                      fontSize: FontSize(18),
                                                      color: ProjectColor
                                                          .hadithTextColor,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  },
                                                );
                                              } else {
                                                final turkce = controller.items[
                                                        controller.index.value]
                                                    ['turkce'];
                                                final textToShow =
                                                    turkce != null
                                                        ? turkce.toString()
                                                        : '';
                                                return Html(
                                                  data: textToShow,
                                                  style: {
                                                    'body': Style(
                                                      fontSize: FontSize(18),
                                                      color: ProjectColor
                                                          .hadithTextColor,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  },
                                                );
                                              }
                                            }),
                                          ),
                                        ),
                                      ),
                                    )),
                        ));
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
