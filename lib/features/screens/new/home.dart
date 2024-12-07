import 'package:clientapp/cores/constants/constants.dart';
import 'package:clientapp/cores/shared/button.dart';
import 'package:clientapp/cores/shared/colors.dart';
import 'package:clientapp/cores/shared/size_boxes.dart';
import 'package:clientapp/router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String logo = Hive.box('empty').get('logo', defaultValue: '');
  String bg = Hive.box('empty').get('bg', defaultValue: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width(context),
        height: height(context),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          image: bg == ''
              ? const DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                )
              : DecorationImage(
                  image: NetworkImage(bg),
                  fit: BoxFit.cover,
                ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logo == ''
                ? Image.asset(
                    'assets/images/logo.png',
                    width: width(context) * .8,
                    // width: 140,
                    height: height(context) * .4,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    logo,
                    width: width(context) / .8,
                    // width: 140,
                    height: height(context) * .4,
                  ),
            const SizedBoxH40(),
            SizedBox(
              width: 300,
              child: CustomButton(
                onPressed: () {
                  Get.toNamed(AppPages.mainPage);
                },
                text: 'ENTER',
                textColor: white,
                bgColor: green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
