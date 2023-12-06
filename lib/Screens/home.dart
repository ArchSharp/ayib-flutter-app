import 'package:ayib/ReduxState/store.dart';
import 'package:ayib/Screens/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool showSystemNavBar = false;
  bool showBalance = false;

  @override
  void initState() {
    super.initState();
    // Initially, hide the system navigation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void showNavBar() {
    setState(() {
      showSystemNavBar = true;
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  void hideNavBar() {
    setState(() {
      showSystemNavBar = false;
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    // double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    // double imageWidth = deviceWidth * 0.8;
    double height = deviceHeight * 0.2;

    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          // Detect vertical swipe to show/hide the system navigation bar
          if (details.primaryDelta! > 20) {
            showNavBar();
          } else if (details.primaryDelta! < -20) {
            hideNavBar();
          }
        },
        child: StoreConnector<AppState, dynamic>(
          converter: (store) => store, //store.state.user
          builder: (context, state /*user*/) {
            var fname = store.state.user['firstname'];
            var lname = store.state.user['lastname'];
            return Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Container(
                      height: height,
                      color: const Color(0xFF049DFE),
                    ),
                    Positioned(
                      // top: 50.0,
                      bottom: -height / 2,
                      left: 16.0,
                      right: 16.0,
                      height: height * 1.2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Hey, $fname!',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Add Money',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Image.asset(
                                            'assets/images/addmoney.png',
                                            width: 20,
                                            height: 20)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 4),
                              //balance

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    showBalance
                                        ? 'NGN236,600.00'
                                        : '***********',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        showBalance = !showBalance;
                                      });
                                    },
                                    child: showBalance
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Container(
                //   height: height,
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: Colors.orangeAccent.shade700,
                //       width: 2.0,
                //     ),
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
