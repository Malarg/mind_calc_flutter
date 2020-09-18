import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'ui/app/app.dart';

void main() {
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(App());
}