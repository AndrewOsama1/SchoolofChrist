import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'app_colors.dart';

class EmailScreen extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();
  final maxLines = 5;

  EmailScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Scaffold(appBar: AppBar(
          title: const Text(
            "اطلب مساعدة",
            style: TextStyle(fontSize: 25),
          ),
      centerTitle: true,
      toolbarHeight:50,
      elevation: 0,
          backgroundColor: AppColor.primary,
      automaticallyImplyLeading: true,
    ),body: SafeArea(
      child: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
                child: SizedBox(
              height: 500,
                child: TextField(
                  maxLines: maxLines * 4,
                  controller: _textEditingController,
                      decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'الموضوع',
                  ),
                )),
          ),
          ElevatedButton(
              onPressed: () async {
                final Email email = Email(
                  body: _textEditingController.text,
                  subject: 'School of Christ app',
                  recipients: ["kdec@kdec.net"],
                  /* cc: ['cc@example.com'],
              bcc: ['bcc@example.com'],
              attachmentPaths: ['/path/to/attachment.zip'],*/
                  isHTML: false,
                );
                    await FlutterEmailSender.send(email).then(
                      (value) => Navigator.pop(context),
                    );
                },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary),
                  child: const Text("send").tr())
        ]),
      ),
    ));
  }

}