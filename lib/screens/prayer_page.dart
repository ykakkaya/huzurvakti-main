import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:huzurvakti/controller/clock_controller.dart';
import 'package:huzurvakti/controller/salah_times_controller.dart';
import 'package:huzurvakti/models/district_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:huzurvakti/service/google_ads_service/google_ads.dart';
import 'package:huzurvakti/utils/project_colors.dart';
import '../models/city.dart';
import '../models/district.dart';
import '../models/salah_time.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  List<SalahTime> timeList = [];
  SalahTimeController controller = Get.put(SalahTimeController());
  final ClockController _clockController = Get.put(ClockController());

  List<DropdownMenuItem> countryDropdownList = [];
  List<DropdownMenuItem> cityDropdownList = [];
  List<DropdownMenuItem> districtDropdownList = [];

  Future<void> updateCountryDropdownlist() async {
    await controller.getAllCountries();
    for (var element in controller.countryList.value) {
      countryDropdownList.add(DropdownMenuItem(
          value: element.ulkeId, child: Text(element.ulkeAdi ?? "non")));
    }
  }

  Future<void> updateCityDropdownlist(int countryId) async {
    controller.selectedCountry.value = countryId;
    await controller.getAllCities(countryId);
    cityDropdownList = [];
    districtDropdownList = [];

    for (var element in controller.cityList.value) {
      cityDropdownList.add(DropdownMenuItem(
          value: element.sehirId, child: Text(element.sehirAdi ?? "non")));
    }
    controller.selectedCity.value = cityDropdownList[0].value;
    await updateDistrictDropdownlist(controller.selectedCity.value);
  }

  Future<void> updateDistrictDropdownlist(int cityId) async {
    controller.selectedCity.value = cityId;
    await controller.getAllDistricts(cityId);
    districtDropdownList = [];
    for (var element in controller.districtList.value) {
      districtDropdownList.add(DropdownMenuItem(
          value: element.ilceId, child: Text(element.ilceAdi ?? "non")));
    }
    controller.selectedDistrict.value = districtDropdownList[0].value;
  }

  /* Future<void> updateSalahTimes() async {
    await controller.getAl
    districtDropdownList = [];
    controller.districtList.value.forEach((element) {
      districtDropdownList.add(DropdownMenuItem(child:  Text(element.ilceAdi??"non"), value: element.ilceId));
    });
    controller.selectedDistrict.value = districtDropdownList[0].value;
  }
*/
  GoogleAds ads = GoogleAds();
  @override
  void initState() {
    ads.loadBannerAd(onLoaded: () {
      setState(() {});
    });
    updateCountryDropdownlist();
    updateCityDropdownlist(2);
    updateDistrictDropdownlist(539);
    super.initState();
  }

  var now = DateTime.now();

  Future<void> saveLocation() async {
    District? district = await controller.districtDatabaseHelper
        .getDistrict(controller.selectedDistrict.value);
    if (district != null) {
      City? city =
          await controller.cityDatabaseHelper.getCity(district.sehirId);
      controller.userDistrictInfo.value = UserDistrictInfo(
          districtNameTr: district.ilceAdi ?? "non",
          districtNameEn: district.ilceAdiEn ?? "non",
          lastSelectedDistrictId: district.ilceId,
          lastUpdateTime: DateTime.now(),
          willBeUpdated: DateTime.now().add(const Duration(days: 20)),
          lastSelectedCityId: city != null ? city.sehirId : 0,
          lastSelectedCountryId: city != null ? city.ulkeId : 0);
      await controller.userDiscrictInfoDatabaseHelper
          .insertOrUpdateDistrictInfo(controller.userDistrictInfo.value!);
      DateTime miladi = DateTime(now.year, now.month, now.day);
      await controller.getSalahTimesForADay(miladi.toString(),
          controller.userDistrictInfo.value!.lastSelectedDistrictId);
    } else {
      throw Exception("Error");
    }
  }

  void showLocationSelecter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        margin: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => (controller.countryList.value.isEmpty)
                ? const CircularProgressIndicator()
                : DropdownButton(
                    isExpanded: true,
                    value: controller.selectedCountry.value,
                    items: countryDropdownList,
                    onChanged: (value) async {
                      await updateCityDropdownlist(value);
                      controller.selectedCountry.value = value;
                    })),
            Obx(
              () => ((controller.countryList.value.isEmpty ||
                      (controller.cityList.value.isEmpty)))
                  ? const CircularProgressIndicator()
                  : DropdownButton(
                      isExpanded: true,
                      value: controller.selectedCity.value,
                      items: cityDropdownList,
                      onChanged: (value) async {
                        await updateDistrictDropdownlist(value);
                        controller.selectedCity.value = value;
                      }),
            ),
            Obx(
              () => ((controller.countryList.value.isEmpty ||
                      (controller.cityList.value.isEmpty ||
                          controller.districtList.value.isEmpty)))
                  ? const CircularProgressIndicator()
                  : DropdownButton(
                      isExpanded: true,
                      value: controller.selectedDistrict.value,
                      items: districtDropdownList,
                      onChanged: (value) async {
                        controller.selectedDistrict.value = value;
                      }),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ProjectColor.prayLocationSetButtonColor),
                onPressed: () async {
                  await saveLocation();
                  Navigator.pop(context);
                },
                child: Text("prayLocationSelect",
                        style: TextStyle(
                            color: ProjectColor.prayLocationSetTextColor))
                    .tr()),
            // ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //         backgroundColor: ProjectColor.prayLocationSetButtonColor),
            //     onPressed: () {},
            //     child: Text("praylocationFind",
            //             style: TextStyle(
            //                 color: ProjectColor.prayLocationSetTextColor))
            //         .tr()),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColor.backgroundColor,
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 1 / 25,
              ),
              if (controller.userDistrictInfo.value == null)
                ElevatedButton(
                  onPressed: () {
                    showLocationSelecter();
                  },
                  child: const Text("prayLocationSelect",
                          style: TextStyle(fontSize: 20))
                      .tr(),
                )
              else
                Card(
                  child: InkWell(
                    onTap: showLocationSelecter,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 2 / 3,
                      height: MediaQuery.of(context).size.width * 1 / 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${controller.userDistrictInfo.value?.districtNameTr}" ??
                                '',
                            style: TextStyle(
                                fontSize: 20,
                                color: ProjectColor.prayLocationTextColor),
                          ),
                          Text("locationSelect",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color:
                                          ProjectColor.prayLocationTextColor))
                              .tr(),
                        ],
                      ),
                    ),
                  ),
                ),
              controller.salahTimes.value == null
                  ? const Text("")
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "prayCelendarMiladi",
                          style: TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.underline),
                        ).tr(),
                        Text(
                          controller.salahTimes.value?.miladiTarihUzun ?? '',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
              controller.salahTimes.value == null
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: Stack(alignment: Alignment.center, children: [
                      Image.asset(
                        "assets/images/salah_times.png",
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        child: Text(
                          _clockController.currentTime.value,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 1 / 6,
                        top: MediaQuery.of(context).size.height * 1 / 7,
                        child: prayTimeShow("prayImsak",
                            controller.salahTimes.value?.imsak ?? '00:00'),
                      ),
                      Positioned(
                        right: MediaQuery.of(context).size.width * 1 / 6,
                        top: MediaQuery.of(context).size.height * 1 / 7,
                        child: prayTimeShow("prayOgle",
                            controller.salahTimes.value?.ogle ?? '00:00'),
                      ),
                      Positioned(
                        right: MediaQuery.of(context).size.width * 1 / 6,
                        bottom: MediaQuery.of(context).size.height * 1 / 7,
                        child: prayTimeShow("prayIkindi",
                            controller.salahTimes.value?.ikindi ?? '00:00'),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width * 1 / 7,
                        bottom: MediaQuery.of(context).size.height * 1 / 7,
                        child: prayTimeShow("prayYatsi",
                            controller.salahTimes.value?.yatsi ?? '00:00'),
                      ),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height * 1 / 15,
                        child: prayTimeShow("prayAksam",
                            controller.salahTimes.value?.aksam ?? '00:00'),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 1 / 15,
                        child: prayTimeShow("prayGunes",
                            controller.salahTimes.value?.gunes ?? '00:00'),
                      ),
                    ])),
              controller.salahTimes.value == null
                  ? const Text("")
                  : Container(
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "prayCelendarHicri",
                            style: TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                            ),
                          ).tr(),
                          Text(
                              controller.salahTimes.value?.hicriTarihUzun ?? "",
                              style: const TextStyle(fontSize: 20)),
                          Visibility(
                            visible: ads.bannerAd != null,
                            child: SizedBox(
                              width: ads.bannerAd?.size.width.toDouble() ?? 0.0,
                              height:
                                  ads.bannerAd?.size.height.toDouble() ?? 0.0,
                              child: ads.bannerAd != null
                                  ? AdWidget(ad: ads.bannerAd!)
                                  : Container(),
                            ),
                          )
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Column prayTimeShow(String text1, String text2) {
    return Column(
      children: [
        Text(
          text1,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ProjectColor.prayTextColor,
          ),
        ).tr(),
        Text(
          text2,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ProjectColor.prayTimeTextColor,
          ),
        ),
      ],
    );
  }
}
