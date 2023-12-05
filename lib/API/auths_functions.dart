import 'dart:convert';
import 'package:ayib/ReduxState/actions.dart';
import 'package:ayib/ReduxState/store.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

String baseUrl = "https://d6df-102-88-35-131.ngrok-free.app";

Future<Tuple2<int, String>> signinFn(email, pass) async {
  String apiUrl = '$baseUrl/api/SigninUser';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer YOUR_API_KEY",
  };

  final Map<String, dynamic> payload = {
    "email": email,
    "password": pass,
  };

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(payload));

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      // print(data);
      store.dispatch(UpdateUserAction(data['body']));
      result = const Tuple2(1, "Login success");
    } else {
      // Handle errors
      print(
          'Request failed with status: ${response.statusCode}, responsePayload: $data');
      String msg = data['body'];
      if (msg.toLowerCase() == "please verify your email") {
        result = Tuple2(2, data['body']);
      } else if (msg.toLowerCase() == "incorrect password detected") {
        result = Tuple2(3, data['body']);
      } else if (msg.toLowerCase() == "user not found") {
        result = Tuple2(4, data['body']);
      }
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    result = const Tuple2(-1, "Network error");
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

Future<Tuple2<int, String>> verifyEmailFn(email, otp) async {
  String apiUrl = '$baseUrl/api/VerifyEmail';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer YOUR_API_KEY",
  };

  final Map<String, dynamic> payload = {"email": email, "otp": otp};

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(payload));

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      // print(data);
      result = Tuple2(1, data['body']);
    } else {
      print(
          'Request failed with status: ${response.statusCode} response payload: $data');

      String msg = data['body'];
      if (msg.contains("expired")) {
        result = Tuple2(2, msg);
      } else if (msg.contains("wrong")) {
        result = Tuple2(3, msg);
      }
    }
  } catch (e) {
    print('Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}
