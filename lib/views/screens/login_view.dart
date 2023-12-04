import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solarpunk_prototype/constant.dart';
import 'package:solarpunk_prototype/views/screens/signup_view.dart';
import 'package:solarpunk_prototype/views/widgets/textfield.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Oradores',
              style: TextStyle(
                fontSize: 35,
                fontFamily: GoogleFonts.notoSansPahawhHmong().fontFamily,
                color: primaryColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                isObscure: true,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 50,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: InkWell(/*
                onTap: () => authController.loginUser(
                  _emailController.text,
                  _passwordController.text,
                ),*/
                onTap: () => print('Login'),
                child: const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Need an account? ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignupScreen(),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 20, color: primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}