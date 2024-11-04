import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:huzurvakti/controller/home_controller.dart';
import 'package:huzurvakti/screens/hadith_page.dart';
import 'package:huzurvakti/screens/qibla_pages/loading_error.dart';
import 'package:huzurvakti/screens/qibla_pages/loading_indicator.dart';
import 'package:huzurvakti/screens/prayer_page.dart';
import 'package:huzurvakti/screens/qibla_pages/qibla_maps.dart';
import 'package:huzurvakti/screens/qibla_pages/qibla_page.dart';
import 'package:huzurvakti/screens/quran_page.dart';
import 'package:huzurvakti/screens/zikr_page.dart';
import 'package:huzurvakti/utils/project_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await EasyLocalization.ensureInitialized();
  await GetStorage.init();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.deviceLocale,
      title: "Huzur Vakti",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HomeController controller = Get.put(HomeController());
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("appbarText",
                style: TextStyle(color: ProjectColor.appbarTextColor))
            .tr(),
        centerTitle: true,
        backgroundColor: ProjectColor.appbarColor,
      ),
      body: SafeArea(child: Obx(() => _getPage(controller.currentIndex.value))),
      bottomNavigationBar: Obx(
        () => AnimatedBottomNavigationBar(
          backgroundColor: ProjectColor.bottomBar,
          icons: const [
            Icons.menu_book,
            Icons.location_on,
            Icons.add_chart_sharp,
            Icons.access_time,
            Icons.question_mark_rounded,
          ],
          activeIndex: controller.currentIndex.value,
          activeColor: ProjectColor.bottomBarActivaColor,
          inactiveColor: ProjectColor.bottomBarInActiveColor,
          gapLocation: GapLocation.none,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) => controller.changePage(index),
        ),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const QuranPage();
      case 1:
        return FutureBuilder(
          future: _deviceSupport,
          builder: (_, AsyncSnapshot<bool?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingIndicator();
            }
            if (snapshot.hasError) {
              return const LocationErrorWidget();
            }

            if (snapshot.data!) {
              return const QiblahCompass();
            } else {
              return const QiblahMaps();
            }
          },
        );

      case 2:
        return const ZikrPage();
      case 3:
        return const PrayerTimesPage();
      case 4:
        return const HadithPage();
      default:
        return const QuranPage();
    }
  }
}
