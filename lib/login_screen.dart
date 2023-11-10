import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'api.dart';
import 'home_screen.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  static void disconnectWithGoogle() {}
}

class _LoginScreenState extends State<LoginScreen> {
  // Google Authentication Code
  _handleGoogleButtonClick() {
    // Get.defaultDialog(
    //   content: const Center(
    //     child: CircularProgressIndicator(),
    //   ),
    // );
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    _signInWithGoogle().then((user) async {
      //for hiding progress bar
      Get.back();

      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          Get.off(const HomeScreen());
        } else {
          await APIs.createUser().then((value) {
            Get.off(const HomeScreen());
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');

      // Sign in process which shows multiple accounts
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // Obtain auth details by request
      final GoogleSignInAuthentication? gAuth = await gUser?.authentication;

      // New credential user
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth?.accessToken, idToken: gAuth?.idToken);

      // Finally sign in
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something went wrong (Check Internet!)')));
      // Get.snackbar('Something went wrong', 'Check Internet Connection!');
      return null;
    }
  }

  disconnectWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
    //await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Login Screen'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                const FlutterLogo(
                  size: 150,
                  style: FlutterLogoStyle.stacked,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _handleGoogleButtonClick();
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.black12)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/images/google.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
