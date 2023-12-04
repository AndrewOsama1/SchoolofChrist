import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kdeccourse/backend_requests.dart';
import 'package:kdeccourse/firebase_auth_service.dart';
import 'package:kdeccourse/main.dart';
import 'package:kdeccourse/models/user_model.dart';
import 'package:kdeccourse/profile_screen.dart';
import 'package:kdeccourse/reset_password.dart';
import 'package:kdeccourse/signup_screen.dart';
import 'package:provider/provider.dart';
import 'app_colors.dart';

class LoginScreen extends StatefulWidget {
  final bool skip;

  const LoginScreen({Key? key, this.skip = false}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool emailValid = true, passValid = true;

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar(); // Dismiss any existing snackbar

    Get.snackbar(
      'Login Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 2.5;
    return context.watch<User?>() == null
        ? Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/app_background.jpg"),
                    fit: BoxFit.cover)),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset("images/cover.jpg"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "login",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: multiplier * unitHeightValue),
                            ).tr(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 45,
                            child: TextField(
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              decoration: InputDecoration(
                                  fillColor: AppColor.primary,
                                  border: const OutlineInputBorder(),
                                  labelText: "Email",
                                  errorText: !emailValid
                                      ? "Please enter a valid email"
                                      : null),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 45,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              autocorrect: false,
                              decoration: InputDecoration(
                                  fillColor: AppColor.primary,
                                  border: const OutlineInputBorder(),
                                  labelText: 'Password',
                                  errorText: !passValid
                                      ? "Password should be 5 characters at least"
                                      : null),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ResetScreen())),
                              child: Text("Reset Password",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: multiplier * unitHeightValue,
                                    decoration: TextDecoration.underline,
                                  )).tr()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen())),
                              child: Text("noEmail",
                                  style: TextStyle(
                                    color: AppColor.secondary,
                                    fontSize: multiplier * unitHeightValue,
                                    decoration: TextDecoration.underline,
                                  )).tr()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                              onTap: () =>
                                  Navigator.pushAndRemoveUntil<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          const MyHomePage(),
                                    ),
                                    (route) => false,
                                  ),
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "guest",
                                  style: TextStyle(
                                      fontSize: multiplier * unitHeightValue,
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue),
                                ).tr(),
                              )),
                        ),
                        TextButton.icon(
                          label: const Text('language').tr(),
                          onPressed: () => EasyLocalization.of(context)!
                              .setLocale(EasyLocalization.of(context)!
                                  .supportedLocales
                                  .where((element) =>
                                      element !=
                                      EasyLocalization.of(context)!
                                          .currentLocale)
                                  .first),
                          icon: const Icon(Icons.language),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 2 * multiplier * unitHeightValue,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primary),
                            child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  "login",
                                  style: TextStyle(
                                      fontSize: multiplier * unitHeightValue),
                                ).tr()),
                            onPressed: () async {
                              if (_emailController.text.contains("@") &&
                                  _passwordController.text.length >= 5) {
                                await context
                                    .read<FirebaseAuthService>()
                                    .signIn(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    )
                                    .then((value) async {
                                  log(FirebaseAuth.instance.currentUser!.email
                                      .toString());
                                  context.read<UserModel>().setUser(
                                        await BackendQueries.getUserInfo(
                                            await FirebaseAuth
                                                    .instance.currentUser
                                                    ?.getIdToken(true) ??
                                                ""),
                                      );
                                  Navigator.pushAndRemoveUntil<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          const MyHomePage(),
                                    ),
                                    (route) => false,
                                  );
                                }).catchError((error) {
                                  _showErrorSnackbar(
                                      "The Email or Password is incorrect");
                                });
                              } else {
                                setState(() {
                                  emailValid = passValid = false;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          )
        : widget.skip
            ? const MyHomePage()
            : const ProfileScreen();
  }
}
