import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'account_created_success.dart';
import 'login_screen.dart';

class RegisterUserScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterUserScreen({super.key, this.onTap});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      //createing a new account
      if (_passwordController.text == _confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);

        addUserDetails(
            _firstNameController.text,
            _lastNameController.text,
            _emailController.text.toString(),
            _passwordController.text.toString(),
            int.parse(_ageController.text.toString()),
            int.parse(_mobileNumberController.text.toString()));
      } else {
        // pop the loading circle
        Navigator.pop(context);

        //password dont match
        showErrorMessage("Password doesn't match");
      }
      // pop the loading circle
      //Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // Show Error Message
      showErrorMessage(e.code);
    }
  }

  Future addUserDetails(String firstName, String lastName, String email,
      String password, int age, int mobileNumber) async {
    await FirebaseFirestore.instance.collection('users').add({
      'First Name': firstName,
      'Last Name': lastName,
      'Age': age,
      'Mobile Number': mobileNumber,
      'Email': email,
      'Password': password
    });
  }

  // wrong email message popup
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),

                const Text(
                  "Let's Create An Account!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                // first name textformfield
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter First Name',
                      labelText: 'First Name',
                      prefixIcon: const Icon(Icons.person)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // last name textformfield
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Last Name',
                      labelText: 'Last Name',
                      prefixIcon: const Icon(Icons.person)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // age textformfield
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _ageController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Age',
                      labelText: 'Age',
                      prefixIcon: const Icon(Icons.person_2_outlined)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter age';
                    } else if (value.length > 2) {
                      return 'Age required maximum 2 digit';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // mobile number textformfield
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: _mobileNumberController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Mobile Number',
                      labelText: 'Mobile Number',
                      prefixIcon: const Icon(Icons.person_2_outlined)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter valid mobile number';
                    } else if (value.length < 10) {
                      return 'Mobile number required 10 digit';
                    } else if (value.length > 10) {
                      return 'Mobile number should be max 10 digit';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // email textformfield
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
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
                const SizedBox(height: 20),

                // password textformfield
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Password',
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText
                            ? Icons.visibility_off
                            : Icons.visibility_sharp),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter password';
                    } else if (value.length < 6) {
                      return 'Password must be atleast 6 characters';
                    }
                    return null;
                  },
                  obscureText: _obscureText,
                ),
                const SizedBox(height: 20),

                // confirm password textformfield
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Enter Confirm Password',
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText
                            ? Icons.visibility_off
                            : Icons.visibility_sharp),
                      )),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter confirm password';
                    }
                    return null;
                  },
                  obscureText: _obscureText,
                ),
                const SizedBox(height: 30),

                // sign up button
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate() &&
                        _passwordController.text ==
                            _confirmPasswordController.text) {
                      signUserUp();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AccountCreatedSuccessfully(),
                          ));
                    }
                  },
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                        child: Text(
                      'Sign Up',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    )),
                  ),
                ),
                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an Account?  ',
                      style:
                          TextStyle(fontSize: 17, color: Colors.grey.shade600),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ));
                      },
                      child: const Text(
                        'Login Now',
                        style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
