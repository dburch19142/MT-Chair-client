import 'dart:developer';

import 'package:clientapp/cores/constants/constants.dart';
import 'package:clientapp/cores/services/collections.dart';
import 'package:clientapp/cores/shared/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clientapp/router.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  redirectScreen() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'admin@emptychair.app', password: 'admin123');
    await FireCollections.settingsRef.doc('settings').get().then((value) async {
      log(value.toString());
      await Hive.box('mtclient').put('bg', value['bg']);
      await Hive.box('mtclient').put('logo', value['logo']);
    });
    await Future.delayed(const Duration(seconds: 5))
        .then((value) => {Get.toNamed(AppPages.signIn)});
  }

  @override
  void initState() {
    super.initState();
    redirectScreen();
  }

  @override
  Widget build(BuildContext context) {
    // String logo = Hive.box('mtclient').get('logo', defaultValue: '');
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(
              'assets/images/logo.png',
              width: width(context) * .8,
              // width: 140,
              height: height(context) * .4,
              fit: BoxFit.fill,
            )),
          ],
        ),
      ),
    );
  }
}
