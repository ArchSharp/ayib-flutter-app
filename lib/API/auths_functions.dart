import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

String baseUrl = "https://fd9f-102-88-62-56.ngrok-free.app";

Future<Tuple2<bool, String>> signinFn(email, pass) async {
  String apiUrl = '$baseUrl/api/SigninUser';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer YOUR_API_KEY",
  };

  final Map<String, dynamic> payload = {
    "email": email,
    "password": pass,
  };

  var result = const Tuple2(false, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(payload));

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      // Parse the JSON data
      // print(data);
      result = const Tuple2(true, "Login success");
    } else {
      // Handle errors
      print('Request failed with status: ${response.statusCode}');
      result = Tuple2(false, data['body']);
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    result = const Tuple2(false, "Network error");
  }
  return result;
}

Future<Tuple2<bool, String>> signupFn(email, phone, pass) async {
  String apiUrl = '$baseUrl/api/NewUser';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer YOUR_API_KEY",
  };

  final Map<String, dynamic> payload = {
    "email": email,
    "password": pass,
    "date_of_birth": "1990-02-16T00:00:00+00:00",
    "firstname": "Raphael",
    "lastname": "Adetunji",
    "middle_name": "Alade",
    "phone_number": phone
  };

  var result = const Tuple2(false, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(payload));

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 201) {
      // print(data);
      result = const Tuple2(true, "Account created succesfully");
    } else {
      // Handle errors
      print('Request failed with status: ${response.statusCode}');
      // print(response.body);
      result = Tuple2(false, data['body']);
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    result = const Tuple2(false, "Network error");
  }
  return result;
}
