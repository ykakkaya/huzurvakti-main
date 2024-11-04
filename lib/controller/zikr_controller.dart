import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ZikrController extends GetxController {
  var zikrBox = GetStorage();

  var counter = 0.obs;

  void increment() {
    counter.value++;
    zikrBox.write('counter', counter.value);
  }

  void reset() {
    counter.value = 0;
    zikrBox.write('counter', counter.value);
  }

  @override
  void onInit() {
    counter.value = zikrBox.read('counter') ?? 0;
    super.onInit();
  }
}
