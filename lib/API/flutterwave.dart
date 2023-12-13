import 'dart:convert';

import 'package:ayib/Model/payment_link.dart';
import 'package:ayib/ReduxState/store.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;

String baseUrl = "https://dd8d-102-88-69-57.ngrok-free.app";

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
