import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Components/Button.dart';
import 'package:myapp/Utilis/colors.dart';

import '../FirebaseNotification.dart';
import '../Utilis/Utilis.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  NotificationServices notificationServices = NotificationServices();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool loading = false;

  // Focus nodes for text fields
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  FirebaseAuth auth = FirebaseAuth.instance;
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  final fireStore = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Stack(
        children: [
          Image(
              fit: BoxFit.fill,
              width: width,
              height: height,
              image: const AssetImage('images/bg3.png')),
          GestureDetector(
            onTap: () {
              // Dismiss keyboard when tapped outside of a text field
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.1, vertical: height * 0.1),
                        child: const Image(
                            fit: BoxFit.fill,
                            image: AssetImage('images/logo.png')),
                      ),
                      TextFormField(
                        focusNode: _firstNameFocus,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            hintText: 'FirstName',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: back, width: 2),
                                borderRadius: BorderRadius.circular(35)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: back, width: 2),
                                borderRadius: BorderRadius.circular(35))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _firstName = value!;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_lastNameFocus);
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      TextFormField(
                        focusNode: _lastNameFocus,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            hintText: 'Last Name',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: back, width: 2),
                                borderRadius: BorderRadius.circular(35)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: back, width: 2),
                                borderRadius: BorderRadius.circular(35))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _lastName = value!;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_emailFocus);
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: back, width: 2),
                                borderRadius: BorderRadius.circular(35)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: back, width: 2),
                                borderRadius: BorderRadius.circular(35))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an email address.';
                          }
                          if (!RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      TextFormField(
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: back, width: 2),
                                borderRadius: BorderRadius.circular(35)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: back, width: 2),
                                borderRadius: BorderRadius.circular(35))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password.';
                          }
                          if (value!.length < 6) {
                            return 'Password must be at least 6 characters.';
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context)
                              .requestFocus(_confirmPasswordFocus);
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      TextFormField(
                        focusNode: _confirmPasswordFocus,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: back, width: 2),
                                borderRadius: BorderRadius.circular(35)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: back, width: 2),
                                borderRadius: BorderRadius.circular(35))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password.';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          _submitForm();
                        },
                      ),
                      const SizedBox(height: 20.0),
                      AppButton(
                          text: 'Submit',
                          loading: loading,
                          onTap: () {
                            _submitForm();
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    setState(() {
      loading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      auth
          .createUserWithEmailAndPassword(
              email: _emailController.text.toString(),
              password: _passwordController.text.toString())
          .then((value) async {
        setState(() {
          loading = false;
        });
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => SignInScreen()));
        notificationServices.getDeviceToken().then((valuee) {
          fireStore.doc(value.user!.uid.toString()).set({
            'userId': value.user!.uid.toString(),
            'role': 'user',
            'fcm_token': valuee
          });
        });
      }).onError((error, stackTrace) {
        setState(() {
          loading = false;
        });
        Utilis().toastMessage(error.toString());
      });
    }
    _formKey.currentState!.reset();

    // Clear text field controllers
    _passwordController.clear();
    _emailController.clear();

    // Focus on the first field
    FocusScope.of(context).requestFocus(_firstNameFocus);

    // Show a success message or navigate to the next screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sign up successful!'),
      ),
    );
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
