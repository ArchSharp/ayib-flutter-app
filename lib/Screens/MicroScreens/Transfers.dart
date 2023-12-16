import 'package:ayib/Screens/ayib_transfer.dart';
import 'package:ayib/Screens/bottom_navbar.dart';
import 'package:ayib/Screens/home.dart';
import 'package:flutter/material.dart';

class TransfersOptions extends StatelessWidget {
  const TransfersOptions({super.key});
  static const routeName = '/transfersOptions';

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: deviceWidth * 0.02,
                    height: deviceHeight * 0.1,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  SizedBox(width: deviceWidth * 0.1),
                  const Text(
                    "Transfer Money",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: deviceHeight * 0.02),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(AyibTransfer.routeName,
                    arguments: 'Passing data from transfers');
              },
              child: Row(
                children: <Widget>[
                  SizedBox(width: deviceWidth * 0.05),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(4, 157, 254, 0.1),
                    ),
                    child: Image.asset(
                      'assets/images/ayibTrf.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  SizedBox(width: deviceWidth * 0.05),
                  const Text(
                    "Ayib to Ayib wallet",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    size: deviceWidth * 0.1,
                  ),
                  SizedBox(width: deviceWidth * 0.04)
                ],
              ),
            ),
            SizedBox(height: deviceHeight * 0.02),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Home.routeName,
                    arguments: 'Passing data from home');
              },
              child: Row(
                children: <Widget>[
                  SizedBox(width: deviceWidth * 0.05),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(4, 157, 254, 0.1),
                    ),
                    child: Image.asset(
                      'assets/images/bank.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  SizedBox(width: deviceWidth * 0.05),
                  const Text(
                    "Other accounts and banks",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    size: deviceWidth * 0.1,
                  ),
                  SizedBox(width: deviceWidth * 0.04)
                ],
              ),
            ),
            SizedBox(height: deviceHeight * 0.02),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Home.routeName,
                    arguments: 'Passing data from home');
              },
              child: Row(
                children: <Widget>[
                  SizedBox(width: deviceWidth * 0.05),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(4, 157, 254, 0.1),
                    ),
                    child: Image.asset(
                      'assets/images/bank.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  SizedBox(width: deviceWidth * 0.05),
                  const Text(
                    "Other payment service bank",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    size: deviceWidth * 0.1,
                  ),
                  SizedBox(width: deviceWidth * 0.04)
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const MyBottomNavBar(),
      ),
    );
  }
}
