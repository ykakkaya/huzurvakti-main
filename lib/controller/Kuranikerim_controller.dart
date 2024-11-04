import 'package:get/get.dart';

import '../data/kuranikerim/Kuranikerim_data.dart';
import '../models/ayet.dart';
import '../models/sure.dart';

class KuranikerimController extends GetxController{
  var sureList =  Rx<List<Sure>>([]);
  var ayetList =  Rx<List<Ayet>>([]);
  var selectedSure = 0.obs;

  final databaseManager = KuraniKerimDatabeManager();

  Future<void> checkSureAndAyet() async{
    await databaseManager.createData();
    sureList.value = await databaseManager.getSureList();
    await getAyetList();
  }

  Future<void> getAyetList() async{
    if(selectedSure.value > 0){
      ayetList.value = await databaseManager.getAyetsBySure(selectedSure.value);
    }
  }
  
  @override
  Future<void> onInit() async{
    await checkSureAndAyet();
    super.onInit();
  }
}