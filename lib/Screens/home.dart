import 'package:ayib/API/auths_functions.dart';
import 'package:ayib/ReduxState/store.dart';
import 'package:ayib/Screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, dynamic>(
        converter: (store) => store, //store.state.user
        builder: (context, state /*user*/) {
          var fname = store.state.user['firstname'];
          var lname = store.state.user['lastname'];
          return SafeArea(
              child: Column(
            children: [
              Text('Welcome, $fname $lname!'), //${user['lastname']}
              ElevatedButton(
                  onPressed: () {
                    logoutFn();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  child: const Text("Log out"))
            ],
          ));
        },
      ),
    );
  }
}
