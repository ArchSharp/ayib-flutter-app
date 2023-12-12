import 'dart:convert';

import 'package:ayib/Model/payment_link.dart';
import 'package:ayib/ReduxState/store.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;

String baseUrl = "https://837e-102-88-63-168.ngrok-free.app";

Future<Tuple2<int, String>> createPaymentLink(
    PaymentLinkPayload payload) async {
  String apiUrl = '$baseUrl/api/CreatePaymentLink';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": 'Bearer ${store.state.userToken["accesstoken"]}',
  };

  print(payload.toJson());

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(payload.toJson()),
    );
    // print("object-1: ${response.body}");
    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      // final Map<String, dynamic> data = json.decode(response.body);
      // print(data);
      result = Tuple2(1, data["body"]["link"]);
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      // print('check error: $data');

      result = const Tuple2(3, "Could not create payment link");
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    // print('check error: $data');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}
