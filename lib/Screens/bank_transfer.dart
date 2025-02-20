import 'package:ayib/API/flutterwave.dart';
import 'package:ayib/ReduxState/store.dart';
import 'package:ayib/Screens/bottom_navbar.dart';
import 'package:ayib/Screens/my_notification_bar.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class BankTransfer extends StatefulWidget {
  const BankTransfer({super.key});
  static const routeName = '/bankTransfer';

  @override
  State<BankTransfer> createState() => _BankTransferState();
}

class _BankTransferState extends State<BankTransfer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController acctNameController = TextEditingController();
  String accountNumber = '';
  String beneficiary = '';
  String narration = '';
  String amount = '';
  String email = store.state.email;
  String currency = 'NGN';
  bool isButtonClicked = false;
  String name = '';

  String errorText = '';
  bool isLoading = false;
  // List<Map<String, String>> banks = [
  //   {"name": "Bank A", "code": "98"},
  //   {"name": "Bank B", "code": "42"},
  //   // Add more banks as needed
  // ];
  List<dynamic> banks = store.state.banks;
  String? selectedBank;

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchDataFromApi() async {
    // ... your API call logic
    Tuple2<int, String> result =
        await fetchBankAccName(accountNumber, selectedBank!);
    if (result.item1 == 1) {
      setState(() {
        name = result.item2;
        // Assuming you want to update the beneficiary field as well
        beneficiary = result.item2;
        acctNameController.text = result.item2;
      });
    }
  }

  Future<void> handleBankTransfer() async {
    setState(() {
      isLoading = true;
    });

    // Create an instance of UserPayload

    var ayibPayload = {
      'bankCode': selectedBank,
      'accountNumber': accountNumber,
      'narration': narration,
      'amount': amount,
      'email': email,
      'currency': currency,
    };

    try {
      Tuple2<int, String> result = await bankTransferFn(ayibPayload);
      if (_formKey.currentState?.validate() ?? false) {
        if (result.item1 == 1) {
          if (context.mounted) {
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => const OTPScreen()));
            myNotificationBar(context, result.item2, "success");
          }
          setState(() {
            isButtonClicked = true;
            errorText = '';
          });

          // You might want to navigate to another screen or perform user registration
        } else {
          // Failed sign-up
          if (context.mounted) {
            myNotificationBar(context, result.item2, "error");
          }
          setState(() {
            isButtonClicked = true;
            errorText = result.item2;
          });
        }
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    // print("BANKS: ");
    // print(banks);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                    "Bank transfer",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: deviceHeight * 0.02),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 16),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onChanged: (value) async {
                        setState(() {
                          accountNumber = value;
                        });
                        if (value.length == 10) {
                          // await fetchDataFromApi();
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account number';
                        }
                        // Add more validation rules if needed
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Account number',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            //
                          },
                          child: const Icon(
                            Icons.account_box,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      autovalidateMode: AutovalidateMode.always,
                      value: selectedBank,
                      items: banks.map(
                        (dynamic bank) {
                          final truncatedName = bank["name"]!.length > 30
                              ? '${bank["name"]!.substring(0, 30)}...'
                              : bank["name"]!;
                          return DropdownMenuItem<String>(
                            value: bank["code"],
                            child: Tooltip(
                              message: bank["name"]!,
                              child: Text(
                                truncatedName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      hint: const Text("Choose Bank"),
                      onChanged: (String? value) {
                        selectedBank = value;
                        setState(() {});
                        if (accountNumber.length == 10) {
                          fetchDataFromApi();
                        }
                      },
                      validator: (String? value) {
                        return value == null ? "Choose item from list" : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      key: const ValueKey('apiTextField'),
                      controller: acctNameController,
                      enabled: false,
                      onChanged: (value) {
                        setState(() {
                          beneficiary = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account name';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Account name'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          narration = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter narration';
                        }
                        // Add more validation rules if needed
                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Explain transaction'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          amount = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        // Add more validation rules if needed
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Amount'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        handleBankTransfer();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isLoading ? Colors.green : const Color(0xFF049DFE),
                        fixedSize: Size.fromWidth(deviceWidth),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Text(
                            'Continue',
                            style: TextStyle(color: Colors.white),
                          ),
                          if (isLoading)
                            const Positioned.fill(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
