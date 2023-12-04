import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solarpunk_prototype/constant.dart';
import 'package:solarpunk_prototype/controllers/authentication.dart';
//import 'package:solarpunk_prototype/controllers/auth_controller.dart';
import 'package:solarpunk_prototype/views/screens/login_view.dart';
import 'package:solarpunk_prototype/views/widgets/textfield.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

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
            Stack(
              children: [
                const CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(
                      'https://www.iconpacks.net/icons/2/free-user-icon-3296-thumb.png'),
                  backgroundColor: secondaryColor,
                ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () => authController.pickImage(),//authController.pickImage(),
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _usernameController,
                labelText: 'Username',
                icon: Icons.person,
              ),
            ),
            const SizedBox(
              height: 15,
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
              height: 15,
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
              child: InkWell(
                onTap: () => authController.registerUser(
                  _usernameController.text,
                  _emailController.text,
                  _passwordController.text,
                  authController.profileImage,
                ),
                child: const Center(
                  child: Text(
                    'Register',
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
                  'I have a account. ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  ),
                  child: Text(
                    'Login',
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