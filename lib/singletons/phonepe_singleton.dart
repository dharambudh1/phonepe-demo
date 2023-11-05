import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:crypto/crypto.dart";
import "package:flutter_phonepe_demo/constant/string_constants.dart";
import "package:flutter_phonepe_demo/model/phonepe_model.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:phonepe_payment_sdk/phonepe_payment_sdk.dart";

class PhonePeSingleton {
  factory PhonePeSingleton() {
    return _singleton;
  }

  PhonePeSingleton._internal();
  static final PhonePeSingleton _singleton = PhonePeSingleton._internal();

  Future<void> init() async {
    try {
      final bool result = await PhonePePaymentSdk.init(
        StringConstants().environment,
        StringConstants().appId,
        StringConstants().merchantId,
        StringConstants().enableLogging,
      );
      log("PhonePeService: init(): try: $result");
    } on Exception catch (error) {
      log("PhonePeService: init(): catch: $error");
    }
    return Future<void>.value();
  }

  Future<void> makePayment({
    required double amount,
    required Function(String) successAcknowledgement,
    required Function(String) failureAcknowledgement,
  }) async {
    try {
      StringConstants().packageName = await getPackageName();

      final Map<dynamic, dynamic> result =
          await PhonePePaymentSdk.startPGTransaction(
                getBody(amount: amount),
                Platform.isIOS ? StringConstants().iOSCallback : "null",
                getChecksumCalculation(amount: amount),
                <String, String>{"Content-Type": "application/json"},
                StringConstants().apiEndPoint,
                StringConstants().packageName,
              ) ??
              <dynamic, dynamic>{};

      if (result.isEmpty) {
        log("PhonePeService: makePayment(): try: result.isEmpty");
        failureAcknowledgement("Something went wrong! Try again later.");
      } else {
        log("PhonePeService: makePayment(): try: result.isNotEmpty");
        final Map<String, dynamic> json = Map<String, dynamic>.from(result);
        final PhonePeModel phonePeModel = PhonePeModel.fromJson(json);
        final String status = phonePeModel.status ?? "";
        final String error = phonePeModel.error ?? "";
        log("PhonePeService: makePayment(): try: status: $status");
        log("PhonePeService: makePayment(): try: error: $error");

        switch (status) {
          case "SUCCESS":
            successAcknowledgement("$status $error");
            break;
          case "FAILURE":
            failureAcknowledgement("$status $error");
            break;
          case "INTERUPTTED":
            failureAcknowledgement("$status $error");
            break;
        }
      }
    } on Exception catch (error) {
      log("PhonePeService: makePayment(): catch: $error");
    }
    return Future<void>.value();
  }

  Future<String> getPackageName() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String packageName = packageInfo.packageName;
    return Future<String>.value(packageName);
  }

  String getBody({required double amount}) {
    final String string = '''
{
  "merchantId": "PGTESTPAYUAT97",
  "merchantTransactionId": "MT7850590068188104",
  "merchantUserId": "MUID123",
  "amount": ${amount.toInt() * 100},
  "redirectUrl": "https://webhook.site/redirect-url",
  "redirectMode": "REDIRECT",
  "callbackUrl": "https://webhook.site/callback-url",
  "mobileNumber": "9999999999",
  "paymentInstrument": {
    "type": "PAY_PAGE"
  }
}''';
    final String value = encodeStringToBase64(decodedString: string);
    return value;
  }

  String getChecksumCalculation({required double amount}) {
    final String base64Body = getBody(amount: amount);
    final String apiEndPoint = StringConstants().apiEndPoint;
    final String salt = StringConstants().appId;
    final String sha = stringToSHA256(string: base64Body + apiEndPoint + salt);
    final String value = "$sha###1";
    return value;
  }

  String encodeStringToBase64({required String decodedString}) {
    final List<int> encodedUnits = decodedString.codeUnits;
    final String encodedString = base64.encode(encodedUnits);
    return encodedString;
  }

  String decodeBase64toString({required String encodedString}) {
    final List<int> decodedint = base64.decode(encodedString);
    final String decodedstring = utf8.decode(decodedint);
    return decodedstring;
  }

  String stringToSHA256({required String string}) {
    final List<int> appleInBytes = utf8.encode(string);
    final Digest value = sha256.convert(appleInBytes);
    return value.toString();
  }
}
