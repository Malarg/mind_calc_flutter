import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'ui/app/app.dart';

void main() async {
  InAppPurchaseConnection.enablePendingPurchases();
  await GetStorage.init();
  runApp(App());
}