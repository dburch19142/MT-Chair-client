import 'dart:developer';
import 'dart:io';

import 'package:clientapp/cores/constants/constants.dart';
import 'package:clientapp/cores/services/database.dart';
import 'package:clientapp/cores/shared/button.dart';
import 'package:clientapp/cores/shared/colors.dart';
import 'package:clientapp/cores/shared/size_boxes.dart';
import 'package:clientapp/cores/shared/style.dart';
import 'package:clientapp/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPageScreen extends StatefulWidget {
  const MainPageScreen({super.key});

  @override
  State<MainPageScreen> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
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
          color: black,
          image: bg == ''
              ? DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                  opacity: .8,
                )
              : DecorationImage(
                  image: NetworkImage(bg), fit: BoxFit.cover, opacity: .8),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: white,
                  child: BackButton(
                    color: black,
                  ),
                ),
                const SizedBoxH10(),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: altoGrey,
                      ),
                    ),
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 15,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Waiting: ',
                              style: textStyle14.copyWith(
                                color: white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBoxW5(),
                            StreamBuilder<QuerySnapshot>(
                              stream: DatabaseService().getWaitingBooking(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                }
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: headerStyle.copyWith(
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Appointments: ',
                              style: textStyle14.copyWith(
                                color: white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBoxW5(),
                            StreamBuilder<QuerySnapshot>(
                              stream: DatabaseService().getAppointmentBooking(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                }
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: headerStyle.copyWith(
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Walk In: ',
                              style: textStyle14.copyWith(
                                color: white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBoxW5(),
                            StreamBuilder<QuerySnapshot>(
                              stream: DatabaseService().getWalkInBooking(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                }
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: headerStyle.copyWith(
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBoxH20(),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Available Barbers",
                      style: textStyle14,
                    ),
                  ),
                ),
                const SizedBoxH20(),
                StreamBuilder<QuerySnapshot>(
                  stream: DatabaseService().getAvailableBarbersStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('No barber available'),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    return snapshot.data!.docs.isEmpty
                        ? const Center(
                            child: Text('No barber available'),
                          )
                        : Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.start,
                            children: List.generate(
                              snapshot.data!.docs.length,
                              (index) {
                                var data = snapshot.data!.docs[index];
                                return Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: altoGrey,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipOval(
                                        // borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          data['photo_url'],
                                          width: 50,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBoxW15(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['name'],
                                            style: textStyle16,
                                          ),
                                          const SizedBoxH5(),
                                          Text(
                                            'Available Now',
                                            style: textStyle12.copyWith(
                                                color: green),
                                          ),
                                        ],
                                      ),
                                      const SizedBoxW10(),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                  },
                ),
                const SizedBoxH30(),
                Column(
                  children: [
                    CustomButton(
                      onPressed: () {
                        Get.toNamed(AppPages.services);
                      },
                      text: 'Services',
                      textColor: white,
                      bgColor: green,
                    ),
                    const SizedBoxH10(),
                    CustomButton(
                      onPressed: () {
                        Get.toNamed(AppPages.hours);
                      },
                      text: 'Hours',
                      textColor: white,
                      bgColor: red,
                    ),
                    const SizedBoxH10(),
                    CustomButton(
                      onPressed: () {
                        launchMapUrl();
                      },
                      text: 'Location',
                      textColor: white,
                      bgColor: blue,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String address = '4471 Jimmy Lee Smith Pkwy, Hiram, GA 30141';
  Future<void> launchMapUrl() async {
    String encodedAddress = Uri.encodeComponent(address);
    String googleMapUrl =
        "https://www.google.com/maps/search/?api=1&query=$encodedAddress";
    String appleMapUrl = "http://maps.apple.com/?q=$encodedAddress";
    if (Platform.isAndroid) {
      try {
        if (await canLaunchUrl(Uri.parse(googleMapUrl))) {
          await launchUrl(Uri.parse(googleMapUrl));
        }
      } catch (error) {
        log("Cannot launch Google map");
      }
    }
    if (Platform.isIOS) {
      try {
        if (await canLaunchUrl(Uri.parse(appleMapUrl))) {
          await launchUrl(Uri.parse(appleMapUrl));
        }
      } catch (error) {
        log("Cannot launch Apple map");
      }
    }
  }
}
