import 'dart:convert';
import 'package:ayib/ReduxState/actions.dart';
import 'package:ayib/ReduxState/store.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

String baseUrl = "https://af8c-102-88-63-210.ngrok-free.app";

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

Future<Tuple2<int, String>> signupFn(
    email, phone, pass, fname, lname, mname, dateofbirth) async {
  String apiUrl = '$baseUrl/api/NewUser';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer YOUR_API_KEY",
  };

  final Map<String, dynamic> payload = {
    "email": email,
    "password": pass,
    "date_of_birth": dateofbirth
        .toString()
        .replaceAll(RegExp(r' 00:00:00.000'), 'T00:00:00+00:00'),
    "firstname": fname,
    "lastname": lname,
    "middle_name": mname,
    "phone_number": phone
  };
  // print(payload);

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(payload));

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 201) {
      // print(data);
      result = const Tuple2(1, "Account created succesfully");
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      // print('check error: $data');
      if (data['error'].toString().contains("parsing time")) {
        result = const Tuple2(2, 'There is error in date');
      } else {
        result = Tuple2(3, data['body']);
      }
    }
  } catch (e) {
    // Handle exceptions
    // print('Error: $e');
    result = const Tuple2(-1, "Network error");
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

Future<Tuple2<int, String>> forgotPasswordFn(email) async {
  String apiUrl = '$baseUrl/api/ForgotPassword?email=$email';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer YOUR_API_KEY",
  };

  var result = const Tuple2(0, "");
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(data);
      result = Tuple2(1, data['body']);
    } else {
      print(
          'Request failed with status: ${response.statusCode} response payload: $data');

      String msg = data['body'];
      if (msg.contains("not found")) {
        result = Tuple2(2, msg);
      } else if (msg.contains("verify")) {
        result = Tuple2(3, msg);
      }
    }
  } catch (e) {
    print('Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> resetPasswordFn(otp, newPassword) async {
  String apiUrl = '$baseUrl/api/ResetPassword';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer YOUR_API_KEY",
  };
  var email = store.state.email;
  final Map<String, dynamic> payload = {
    "email": email,
    "otp": otp,
    "new_password": newPassword,
  };

  var result = const Tuple2(0, "");
  try {
    final response = await http.patch(Uri.parse(apiUrl),
        headers: headers, body: json.encode(payload));

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(data);
      result = Tuple2(1, data['body']);
    } else {
      print(
          'Request failed with status: ${response.statusCode} response payload: $data');

      String msg = data['body'];
      if (msg.contains("not found")) {
        result = Tuple2(2, msg);
      } else if (msg.contains("verify")) {
        result = Tuple2(3, msg);
      } else if (msg.contains("invalid/wrong")) {
        result = Tuple2(4, msg);
      } else if (msg.contains("expired")) {
        result = Tuple2(5, msg);
      }
    }
  } catch (e) {
    print('Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

void logoutFn() {
  try {
    store.dispatch(LogOut());
  } catch (e) {
    print('Error: $e');
  }
}
