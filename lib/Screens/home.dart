import 'package:ayib/API/auths_functions.dart';
import 'package:ayib/API/flutterwave.dart';
import 'package:ayib/ReduxState/store.dart';
import 'package:ayib/Screens/MicroScreens/paybills.dart';
import 'package:ayib/Screens/MicroScreens/transfers.dart';
// import 'package:ayib/Screens/MicroScreens/fund_walet.dart';
import 'package:ayib/Screens/MicroScreens/webview2.dart';
import 'package:ayib/Screens/MicroScreens/withdraws.dart';
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

    fetchUserWalletFn(store.state.email).then((_) => {fetchBanks()});
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
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    // double imageWidth = deviceWidth * 0.8;
    double height = deviceHeight * 0.2;
    double width = deviceWidth * 0.9;

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
            // var lname = store.state.user['lastname'];
            var bal = store.state.userWallet['balance'];
            var balance =
                bal == null ? "0" : double.parse(bal).toStringAsFixed(2);
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.topCenter,
                    children: <Widget>[
                      Container(
                        height: height,
                        color: const Color(0xFF049DFE),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          SizedBox(
                            height: height * 1.2,
                            width: width,
                            child: Container(
                              width: width,
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
                                        Column(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pushNamed(
                                                    WebView2.routeName,
                                                    arguments:
                                                        'Passing data from home');
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text(
                                                    'Fund Wallet',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF049DFE),
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
                                      ],
                                    ),
                                    SizedBox(height: ((height * 1.2) / 4)),
                                    //balance
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          showBalance
                                              ? 'NGN$balance'
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
                                              ? const Icon(
                                                  Icons.visibility,
                                                  color: Color(0xFF049DFE),
                                                )
                                              : const Icon(
                                                  Icons.visibility_off,
                                                  color: Color(0xFF049DFE),
                                                ),
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
                    ],
                  ),
                  SizedBox(height: height / 7),
                  SizedBox(
                    // height: height * 1.4,
                    width: deviceWidth,
                    child: Column(
                      children: <Widget>[
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Quick Actions",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            WebView2.routeName,
                                            arguments:
                                                'Passing data from home');
                                      },
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromRGBO(4, 157, 254, 0.1),
                                        ),
                                        child: Image.asset(
                                            'assets/images/add2.png',
                                            width: 20,
                                            height: 20),
                                      ),
                                    ),
                                    const Text(
                                      "Fund Wallet",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            TransfersOptions.routeName,
                                            arguments:
                                                'Passing data from home');
                                      },
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromRGBO(4, 157, 254, 0.1),
                                        ),
                                        child: Image.asset(
                                            'assets/images/trf.png',
                                            width: 20,
                                            height: 20),
                                      ),
                                    ),
                                    const Text(
                                      "Transfer Money",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        // Handle button tap
                                        print('Button tapped!');
                                      },
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromRGBO(4, 157, 254, 0.1),
                                        ),
                                        child: Image.asset(
                                            'assets/images/air.png',
                                            width: 20,
                                            height: 20),
                                      ),
                                    ),
                                    const Text(
                                      "Recharge Airtime",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        // Handle button tap
                                        print('Button tapped!');
                                      },
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromRGBO(4, 157, 254, 0.1),
                                        ),
                                        child: Image.asset(
                                            'assets/images/bundle.png',
                                            width: 20,
                                            height: 20),
                                      ),
                                    ),
                                    const Text(
                                      "Buy Bundle",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            WithdrawOptions.routeName,
                                            arguments:
                                                'Passing data from home');
                                      },
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromRGBO(4, 157, 254, 0.1),
                                        ),
                                        child: Image.asset(
                                            'assets/images/wcash.png',
                                            width: 20,
                                            height: 20),
                                      ),
                                    ),
                                    const Text(
                                      "Withdraw Cash",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        // Handle button tap
                                        Navigator.of(context).pushNamed(
                                            PayBillsOptions.routeName,
                                            arguments:
                                                'Passing data from home');
                                      },
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromRGBO(4, 157, 254, 0.1),
                                        ),
                                        child: Image.asset(
                                          'assets/images/pbill.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Pay Bill",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        // Handle button tap
                                        print('Button tapped!');
                                      },
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromRGBO(4, 157, 254, 0.1),
                                        ),
                                        child: Image.asset(
                                            'assets/images/pmerch.png',
                                            width: 20,
                                            height: 20),
                                      ),
                                    ),
                                    const Text(
                                      "Pay Merchant",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Column(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        // Handle button tap
                                        print('Button tapped!');
                                      },
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              Color.fromRGBO(4, 157, 254, 0.1),
                                        ),
                                        child: Image.asset(
                                            'assets/images/mqr.png',
                                            width: 20,
                                            height: 20),
                                      ),
                                    ),
                                    const Text(
                                      "My QR",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    // height: height * 1.7,
                    width: deviceWidth,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: deviceWidth / 2 - 16,
                            height: height / 1.5,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage('assets/images/fav.png'),
                                fit: BoxFit.fill,
                              ),
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
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              child: const Center(
                                child: Text(
                                  "Manage Your Favourites",
                                  style: TextStyle(
                                    color: Colors.white,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: deviceWidth / 2 - 16,
                            height: height / 1.5,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage('assets/images/agent.png'),
                                fit: BoxFit.fill,
                              ),
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
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              child: const Center(
                                child: Text(
                                  "Find An Agent",
                                  style: TextStyle(
                                    color: Colors.white,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: deviceWidth,
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Recent transactions",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Center(child: Text("#"))),
                                DataColumn(
                                    label: Center(child: Text("Details"))),
                                DataColumn(
                                    label: Center(child: Text("Amount"))),
                              ],
                              rows: const [
                                DataRow(
                                  cells: [
                                    DataCell(
                                      Text(""),
                                    ),
                                    DataCell(
                                      Column(
                                        children: [
                                          Text("From: Jimi Dayo"),
                                          Text("Dec 7th 12:16 PM")
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          "+#56.23",
                                          style: TextStyle(
                                              color: Color(0xFF049DFE)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: [
                                    DataCell(
                                      Text(""),
                                    ),
                                    DataCell(
                                      Column(
                                        children: [
                                          Text("To: Sportybet"),
                                          Text("Dec 6th 11:34 AM")
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          "-#4.00",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                DataRow(
                                  cells: [
                                    DataCell(
                                      Text(""),
                                    ),
                                    DataCell(
                                      Column(
                                        children: [
                                          Text("To: Spotify"),
                                          Text("Dec 6th 11:05 AM")
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          "-#9.99",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
