import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then(
                (value) async {
                  await GoogleSignIn().signOut().then((value) {
                    //FirebaseAuth.instance = FirebaseAuth.instance;
                    //Navigator.pop(context);
                    Get.off(const LoginScreen());
                  });
                },
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'LogOut',
          )
        ],
      ),
    );
  }
}
