import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:get/get.dart';

import 'verify_code.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final countryCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  // var _countryCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 250,
                  width: 250,
                  child: Image.asset('assets/images/phone_auth.png')),
              const SizedBox(
                height: 50,
              ),
              IntlPhoneField(
                //disableLengthCheck: true,
                controller: phoneNumberController,
                initialCountryCode: 'IN',
                decoration: const InputDecoration(
                    hintText: 'Enter Phone Number',
                    hintStyle: TextStyle(fontSize: 15),
                    labelText: 'Phone Number',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value!.completeNumber.isEmpty) {
                    return "Enter valid phone number";
                  }
                  return null;
                },
                onChanged: (value) {
                  countryCodeController.text = value.countryCode;
                },
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );

                    final phoneNumber =
                        countryCodeController.text + phoneNumberController.text;

                    try {
                      await auth.verifyPhoneNumber(
                          phoneNumber: phoneNumber,
                          timeout: const Duration(seconds: 60),
                          verificationCompleted: (_) {
                            Get.back(); // Dismiss loading dialog
                            // Navigator.pop(context); // Dismiss loading dialog
                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return const Center(
                            //       child: CircularProgressIndicator(),
                            //     );
                            //   },
                            // );
                          },
                          verificationFailed: (e) {
                            Get.back(); // Dismiss loading dialog
                            // Navigator.pop(context); // Dismiss loading dialog
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(title: Text(e.toString()));
                              },
                            );
                          },
                          codeSent: (String verificationId, int? token) {
                            Get.back(); // Dismiss loading dialog
                            // Navigator.pop(context); // Dismiss loading dialog
                            Get.to(VerifyCodeScreen(verificationId: verificationId));
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => VerifyCodeScreen(
                            //           verificationId: verificationId),
                            //     ));
                          },
                          codeAutoRetrievalTimeout: (e) {
                            //Navigator.pop(context); // Dismiss loading dialog
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(title: Text(e.toString()));
                              },
                            );
                          });
                    } catch (e) {
                      //Navigator.pop(context); // Dismiss loading dialog
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(title: Text(e.toString()));
                        },
                      );
                    }
                  }
                },

                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                      child: Text(
                    'Confirm Number',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
