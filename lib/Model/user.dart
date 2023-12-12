// import 'dart:convert';

class UserPayload {
  String email;
  String password;
  String dateOfBirth;
  String firstname;
  String lastname;
  String middleName;
  String phoneNumber;

  UserPayload({
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.firstname,
    required this.lastname,
    required this.middleName,
    required this.phoneNumber,
  });

  // Convert UserPayload to JSON
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "date_of_birth": dateOfBirth,
      "firstname": firstname,
      "lastname": lastname,
      "middle_name": middleName,
      "phone_number": phoneNumber,
    };
  }

  // Create UserPayload from JSON
  factory UserPayload.fromJson(Map<String, dynamic> json) {
    return UserPayload(
      email: json['email'],
      password: json['password'],
      dateOfBirth: json['date_of_birth'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      middleName: json['middle_name'],
      phoneNumber: json['phone_number'],
    );
  }
}

// void main() {
//   // Sample payload data
//   String email = 'john.doe@example.com';
//   String pass = 'password123';
//   DateTime dateOfBirth = DateTime(1990, 12, 31);
//   String fname = 'John';
//   String lname = 'Doe';
//   String mname = 'Middle';
//   String phone = '1234567890';

//   // Create an instance of UserPayload
//   UserPayload userPayload = UserPayload(
//     email: email,
//     password: pass,
//     dateOfBirth: dateOfBirth
//         .toString()
//         .replaceAll(RegExp(r' 00:00:00.000'), 'T00:00:00+00:00'),
//     firstname: fname,
//     lastname: lname,
//     middleName: mname,
//     phoneNumber: phone,
//   );

//   // Convert UserPayload to JSON
//   Map<String, dynamic> payloadJson = userPayload.toJson();
//   String payloadJsonString = jsonEncode(payloadJson);

//   // Print the JSON representation
//   print(payloadJsonString);

//   // Convert JSON back to UserPayload
//   Map<String, dynamic> decodedJson = jsonDecode(payloadJsonString);
//   UserPayload decodedUserPayload = UserPayload.fromJson(decodedJson);

//   // Access properties of decodedUserPayload
//   print(decodedUserPayload.email);
//   print(decodedUserPayload.dateOfBirth);
//   print(decodedUserPayload.phoneNumber);
// }
