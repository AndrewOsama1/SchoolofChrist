import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'app_colors.dart';
import 'main.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool emailValid = true;
  String resetMessage = "";

  Future<void> _resetPassword() async {
    if (_emailController.text.trim().contains("@") &&
        _emailController.text.trim().contains(".")) {
      emailValid = true;
    } else {
      emailValid = false;
    }

    if (emailValid) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text.trim());
        setState(() {
          resetMessage =
              "A password reset email has been sent to ${_emailController.text.trim()}. Please check your inbox.";
        });
      } catch (e) {
        setState(() {
          resetMessage =
              " Please make sure the email address is valid and registered.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return context.watch<User?>() == null
        ? Center(
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/app_background.jpg"),
                      fit: BoxFit.cover)),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: const Text(
                    "",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
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
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Reset Your Password',
                              style:
                                  TextStyle(fontFamily: 'Ubuntu', fontSize: 30),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 45,
                              child: Center(
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: 'Enter Your Email',
                                    errorText: !emailValid
                                        ? "Email must be valid"
                                        : null,
                                  ),
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
                                await _resetPassword();
                              },
                              child: const Text("Reset Password").tr(),
                            ),
                          ),
                          if (resetMessage.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                resetMessage,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : const MyHomePage();
  }
}
