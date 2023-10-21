// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Components/Button.dart';
import 'package:myapp/Utilis/colors.dart';

import '../Utilis/Utilis.dart';
import '../adminScreens/AdminHomeScreen.dart';
import 'HomeScreen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final fireStore = FirebaseFirestore.instance.collection('users');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: back,
          ),
        ),
        title: const Text(
          'Sign in Screen',
          style: TextStyle(color: back),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Image(
              fit: BoxFit.fill,
              width: width,
              height: height,
              image: const AssetImage('images/bg4.png')),
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
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters.';
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          _submitForm();
                        },
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      AppButton(
                          loading: loading,
                          text: 'Submit',
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

      await auth
          .signInWithEmailAndPassword(
              email: _emailController.text.toString(),
              password: _passwordController.text.toString())
          .then((value) async {
        final user = await fireStore.doc(value.user!.uid).get();
        if (user['role'] == 'admin') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AdminHomeScreen()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
        setState(() {
          loading = false;
        });

        debugPrint(value.credential!.accessToken.toString());
      }).onError((error, stackTrace) {
        setState(() {
          loading = false;
        });
        Utilis().toastMessage(error.toString());
      });

      // Clear the form

      // Clear text field controllers
      _passwordController.clear();
      _emailController.clear();

      // Focus on the first field
      FocusScope.of(context).requestFocus(_emailFocus);
      setState(() {
        loading = false;
        // _formKey.currentState!.reset();
      });
      // Show a success message or navigate to the next screen
    }
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
