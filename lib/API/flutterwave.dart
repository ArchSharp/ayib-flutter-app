import 'dart:convert';
import 'dart:io';

import 'package:ayib/Model/payment_link.dart';
import 'package:ayib/Model/transactions.dart';
import 'package:ayib/ReduxState/actions.dart';
import 'package:ayib/ReduxState/store.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;

String? baseUrl = dotenv.env['NGROK_URL'];

Future<Tuple2<int, String>> createPaymentLink(Flutterwave payload) async {
  String apiUrl = '$baseUrl/api/FundWalletMobile';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": 'Bearer ${store.state.userToken["accesstoken"]}',
  };

  // print("Request Payload: ${payload.amount}");
  var user = store.state.user;
  ICustomer customer = ICustomer(
    email: user["email"],
    phoneNumber: user["phone_number"],
    name: user["lastname"] + " " + user["firstname"],
  );

  // Create an instance of IMeta
  IMeta meta = IMeta(
    consumerId: 123,
    consumerMac: 'mac_address',
  );

  // Create an instance of ICustomizations
  ICustomizations customization = ICustomizations(
    title: "ArchIntel Ltd",
    logo:
        'https://archdemy.netlify.app/static/media/archintel-nobg.1c7feb8033d0420b2461.png',
    description: 'We deliver great development',
  );

  // Create an instance of PaymentLinkPayload
  PaymentLinkPayload paymentPayload = PaymentLinkPayload(
    customer: customer,
    txRef: payload.txRef,
    amount: payload.amount,
    currency: payload.currency,
    redirectUrl: 'https://example.com/redirect',
    meta: meta,
    customization: customization,
  );

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(paymentPayload.toJson()),
    );
    // print("object-1: ${response.body}");
    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      // print(data);
      result = Tuple2(1, data["body"]);
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      // print('check error: $data');

      result = const Tuple2(2, "Could not create txref");
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    // print('check error: $data');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> fetchBankAccName(String num, String code) async {
  String apiUrl = '$baseUrl/api/ValidateBankAccount';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": 'Bearer ${store.state.userToken["accesstoken"]}',
  };

  // print("Request Payload: ${payload.amount}");

  final Map<String, dynamic> verifyPayload = {
    "account_number": num,
    "bank_code": code
  };

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(verifyPayload),
    );
    // print("object-1: ${response.body}");
    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      // print(data);
      result = Tuple2(1, data["data"]["account_name"]);
    } else {
      // Handle errors
      print('Request failed with status: ${response.statusCode}');
      print('check error: $data');

      result = const Tuple2(2, "Could not create txref");
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    // print('check error: $data');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> fetchAyibAccName(String payload) async {
  String apiUrl = '$baseUrl/api/ValidateAyibAcct?acctNum=$payload';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": 'Bearer ${store.state.userToken["accesstoken"]}',
  };

  // print("Request Payload: ${payload.amount}");

  var result = const Tuple2(0, "");
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);
    // print("object-1: ${response.body}");
    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(data);
      result = Tuple2(1, data["body"]["Name"]);
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      // print('check error: $data');

      result = const Tuple2(2, "Could not create txref");
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    // print('check error: $data');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> ayibTransferFn(var payload) async {
  String apiUrl = '$baseUrl/api/AyibTransfer';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": 'Bearer ${store.state.userToken["accesstoken"]}',
  };

  // print("Request Payload: ${payload.amount}");

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(payload),
    );
    // print("object-1: ${response.body}");
    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      // print(data);
      result = Tuple2(1, data["body"]);
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      print('check error: $data');

      result = const Tuple2(2, "Could not create txref");
      if (data['message'] == "Same user") {
        result = Tuple2(2, data['message']);
      }
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    // print('check error: $data');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> bankTransferFn(var payload) async {
  String apiUrl = '$baseUrl/api/BankTransfer';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": 'Bearer ${store.state.userToken["accesstoken"]}',
  };

  // print("Request Payload: ${payload.amount}");

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(payload),
    );
    // print("object-1: ${response.body}");
    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      // print(data);
      var res = "${data["body"]["Amount"]} sent to ${data["body"]["Receiver"]}";
      result = Tuple2(1, res);
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      print('check error: $data');

      result = const Tuple2(2, "Could not create txref");
      if (data['message'] == "Insufficient balance") {
        result = Tuple2(2, data['message']);
      }
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    // print('check error: $data');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> fetchBanks() async {
  String apiUrl = '$baseUrl/api/GetBanks';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": 'Bearer ${store.state.userToken["accesstoken"]}',
  };

  // print("Request Payload: ${payload.amount}");

  var result = const Tuple2(0, "");
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);
    // print("object-1: ${response.body}");
    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      // print("retreived banks: ${data["data"]}");

      // writeApiResponseToFile(data["data"], "response.json");
      store.dispatch(GetBanks(data["data"]));
      result = const Tuple2(1, "");
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      // print('check error: $data');

      result = const Tuple2(2, "Could not create txref");
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    // print('check error: $data');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

void writeApiResponseToFile(
    List<Map<String, dynamic>> data, String fileName) async {
  try {
    // var jsonResponse = json.decode(data);
    final Directory? externalDir = await getExternalStorageDirectory();

    // final Directory directory = await getApplicationDocumentsDirectory();
    // Write the response to a file
    // File file = File('${directory.path}/$fileName');
    // await file.writeAsString(jsonEncode(data));
    // print('API response written to file: ${file.path}');

    if (externalDir != null) {
      // Write the response to a file in the external storage directory
      File file = File('${externalDir.path}/$fileName');
      await file.writeAsString(jsonEncode(data));

      print('API response written to file: ${file.path}');
    } else {
      print('External storage directory not available.');
    }
  } catch (e) {
    print('Error writting file: $e');
  }
}
