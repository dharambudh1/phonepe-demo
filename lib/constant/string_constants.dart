// ignore: constant_identifier_names
enum Environment { UAT, UAT_SIM, PRODUCTION }

class StringConstants {
  factory StringConstants() {
    return _singleton;
  }

  StringConstants._internal();
  static final StringConstants _singleton = StringConstants._internal();

  // for initialization:
  final String environment = Environment.UAT_SIM.name;
  final String appId = "5bb51303-f908-43be-b6ed-515c12fb63b6";
  final String merchantId = "PGTESTPAYUAT97";
  final bool enableLogging = true;

  // for transaction:
  final String apiSrtPoint = "https://api-preprod.phonepe.com/apis";
  final String apiEndPoint = "/pg/v1/pay";
  // final String apiEndPoint = "/pg-sandbox/pg/v1/pay";
  final String iOSCallback = "com.PhonePe-iOS-Intent-SDK-Integration";
  String packageName = "";
}
