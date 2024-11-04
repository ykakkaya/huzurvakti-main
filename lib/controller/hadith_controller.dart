import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class HadithController extends GetxController {
  var items = [].obs;
  var index = 0.obs;
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);
    items.value = data["items"];
    index.value = Random().nextInt(items.length);
  }

  @override
  Future<void> onInit() async {
    await readJson();
    super.onInit();
  }
}
