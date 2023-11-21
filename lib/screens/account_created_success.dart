import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class AccountCreatedSuccessfully extends StatefulWidget {
  const AccountCreatedSuccessfully({super.key});

  @override
  State<AccountCreatedSuccessfully> createState() =>
      _AccountCreatedSuccessfullyState();
}

class _AccountCreatedSuccessfullyState
    extends State<AccountCreatedSuccessfully> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/images/check-button.png')),

              const SizedBox(height: 40),

              const Text(
                'Account Created Successfully!',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 40),

              // sign in button
              GestureDetector(
                onTap: () {
                  Get.offAll(const HomeScreen());
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => const HomeScreen(),
                  //     ));
                },
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                      child: Text(
                    'Explore Home Page!',
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
