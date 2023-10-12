import 'package:flutter/material.dart';
import 'package:myapp/Components/Button.dart';
import 'package:myapp/view/SignUpScreen.dart';

import 'SignInScreen.dart';

class SignUpLoginScreen extends StatelessWidget {
  const SignUpLoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image(
                fit: BoxFit.fill,
                width: width,
                height: height,
                image: const AssetImage('images/bg2.png')),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.1, vertical: height * 0.1),
                  child: const Image(
                      fit: BoxFit.fill, image: AssetImage('images/logo.png')),
                ),
                SizedBox(height: height * 0.4),
                AppButton(
                    text: 'SignUp',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    }),
                SizedBox(height: height * 0.02),
                AppButton(
                    text: 'Login',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()));
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
