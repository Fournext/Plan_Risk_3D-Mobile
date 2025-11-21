import 'package:get/get.dart';

class ModelController extends GetxController {
  var mustRefresh = false.obs;

  void notifyRefresh() {
    mustRefresh.value = true;
  }

  void consumed() {
    mustRefresh.value = false;
  }
}
