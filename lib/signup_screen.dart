import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:kdeccourse/backend_requests.dart';
import 'package:kdeccourse/firebase_auth_service.dart';
import 'package:kdeccourse/models/user_model.dart';
import 'package:provider/provider.dart';

import 'app_colors.dart';
import 'main.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool emailValid = true, passValid = true, nameValid = true;

  String errorMessage = "";

  Future<void> _signUp() async {
    if (_emailController.text.trim().contains("@") &&
        _emailController.text.trim().contains(".")) {
      emailValid = true;
    } else {
      emailValid = false;
    }

    if (_passwordController.text.length > 5) {
      passValid = true;
    } else {
      passValid = false;
    }

    if (_nameController.text.trim().isNotEmpty) {
      nameValid = true;
    } else {
      nameValid = false;
    }

    if (emailValid && passValid && nameValid) {
      try {
        UserModel user = UserModel(
          email: _emailController.text.trim(),
          name: _nameController.text.trim(),
        );

        User? userCredential =
            (await context.read<FirebaseAuthService>().signUp(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                )) as User?;

        if (userCredential != null) {
          String token = await userCredential.getIdToken();
          var en = jsonEncode(user.toJson());

          BuildContext currentContext = context;

          await BackendQueries.createUser(token, en).then((_) {
            Navigator.pushReplacement(
              currentContext,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(),
              ),
            );
          });
        } else {}
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          setState(() {
            errorMessage = "The Email is already in use";
          });
        } else {
          setState(() {
            errorMessage =
                "The email is already in use. Please use a different email.";
          });
        }
      } catch (e) {
        setState(() {
          errorMessage =
              "The email is already in use. Please use a different email.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return context.watch<User?>() == null
        ? Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/app_background.jpg"),
                    fit: BoxFit.cover)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: const Text(
                  "signup",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ).tr(),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 45,
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'name'.tr(),
                              errorText:
                                  !nameValid ? "Name must not be empty" : null,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 45,
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'email'.tr(),
                              errorText:
                                  !emailValid ? "Email must be valid" : null,
                            ),
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
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'password'.tr(),
                              errorText: !passValid
                                  ? "Password must be at least 5 characters"
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary),
                          onPressed: () async {
                            await _signUp();
                          },
                          child: const Text("signup").tr(),
                        ),
                      ),
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const MyHomePage();
  }
}
