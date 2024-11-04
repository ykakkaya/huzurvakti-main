import 'package:get/get.dart';
import 'package:huzurvakti/data/district_data.dart';
import 'package:huzurvakti/data/salah_time_data.dart';
import 'package:huzurvakti/models/country.dart';
import 'package:huzurvakti/models/district.dart';
import 'package:huzurvakti/models/district_info.dart';
import '../service/remote_service/salah_times_api.dart';
import '../data/city_data.dart';
import '../data/country_data.dart';
import '../data/user_district_info_data.dart';
import '../models/city.dart';
import '../models/salah_time.dart';

class SalahTimeController extends GetxController {

  var countryList = Rx<List<Country>>([]);
  var cityList =  Rx<List<City>>([]);
  var districtList =  Rx<List<District>>([]);
  var salahTimes =  Rx<SalahTime?>(null);
  var userDistrictInfo = Rx<UserDistrictInfo?>(null);

  final api = SalahTimesApi();

  final countryDatabaseHelper = CountryDatabaseHelper();
  final cityDatabaseHelper = CityDatabaseHelper();
  final districtDatabaseHelper = DistrictDatabaseHelper();
  final userDiscrictInfoDatabaseHelper = UserDiscrictInfoDatabaseHelper();
  final salahTimeDatabaseHelper = SalahTimeDatabaseHelper();

  var selectedCountry = Rx<int>(2);
  var selectedCity = Rx<int>(539);
  var selectedDistrict = Rx<int>(3851);


  Future<void> getUserDistrictInfo() async{
    userDistrictInfo.value = await userDiscrictInfoDatabaseHelper.getDistrictInfo();
    if(userDistrictInfo.value !=null){
      userDistrictInfo.value = UserDistrictInfo(districtNameTr: "İstanbul", districtNameEn: "İstanbul", lastSelectedDistrictId: 9541, lastUpdateTime: DateTime.now(), willBeUpdated: DateTime
          .now()
          .add(Duration(days: 20)), lastSelectedCityId: 539, lastSelectedCountryId: 2);
    }
  }

  Future<void> getAllCountries() async{
    countryList.value = await countryDatabaseHelper.getAllCountries();
    if(countryList.value.isEmpty){
      var countiries = await api.getAllCountries();
      await countryDatabaseHelper.insertCountries(countiries);
    }
    countryList.value = await countryDatabaseHelper.getAllCountries();
  }

  Future<void> getAllCities(int countryId) async{
    cityList.value = await cityDatabaseHelper.getAllCitiesByCountryId(countryId);
    if(cityList.value.isEmpty){
      var cities = await api.getAllCitiesByCountryId(countryId);
      await cityDatabaseHelper.insertCities(cities);
    }
    cityList.value = await cityDatabaseHelper.getAllCitiesByCountryId(countryId);
  }

  Future<void> getAllDistricts(int cityId) async{
    districtList.value = await districtDatabaseHelper.getAllDistrictsByCityId(cityId);
    if(districtList.value.isEmpty){
      var districts = await api.getAllDisctrictByCityId(cityId);
      await districtDatabaseHelper.insertDistricts(districts);
    }
    districtList.value = await districtDatabaseHelper.getAllDistrictsByCityId(cityId);
  }

  Future<void> getSalahTimesForADay(String miladi, int districtId) async{
    print(miladi);
    salahTimes.value = await salahTimeDatabaseHelper.getOne(miladi,districtId);
    if(salahTimes.value==null){
      var salahTimes = await api.getAllSalahTimesByDistrictId(districtId);
      await salahTimeDatabaseHelper.insertList(salahTimes);
    }
    salahTimes.value = await salahTimeDatabaseHelper.getOne(miladi,districtId);
  }

@override
  void onInit() async{
  var now = DateTime.now();

  DateTime miladi = DateTime(now.year,now.month,now.day);
  userDistrictInfo.value = await userDiscrictInfoDatabaseHelper.getDistrictInfo();
  print(miladi);
    if(userDistrictInfo.value!=null){
      await getSalahTimesForADay(miladi.toString(), userDistrictInfo.value!.lastSelectedDistrictId);
    }
   ( await salahTimeDatabaseHelper.getAll()).forEach((e) => print(e.miladiTarihKisa));
/*
await getAllCountries();
await getUserDistrictInfo();
await getAllCities(2);
await getAllDistricts(540);
*/
    super.onInit();
  }
}
