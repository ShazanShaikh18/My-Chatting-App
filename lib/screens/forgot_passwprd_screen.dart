import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.toString());

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
            backgroundColor: Colors.blue,
            content: const Text(
              'Password reset link send successfully!',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);

      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
            backgroundColor: Colors.blue,
            content: Text(e.message.toString(),
                style: const TextStyle(color: Colors.white)),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text('Forgot Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  textAlign: TextAlign.center,
                  'Enter your email and we will send you a password reset link on your email',
                  style: TextStyle(fontSize: 17),
                ),

                const SizedBox(height: 55),

                // email textformfield
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Email',
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 55),

                // sign up button
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      passwordReset();
                    }
                  },
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                        child: Text(
                      'Reset Password',
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
      ),
    );
  }
}
