import 'package:clientapp/cores/constants/constants.dart';
import 'package:clientapp/cores/services/database.dart';
import 'package:clientapp/cores/shared/colors.dart';
import 'package:clientapp/cores/shared/size_boxes.dart';
import 'package:clientapp/cores/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HoursScreen extends StatefulWidget {
  const HoursScreen({super.key});

  @override
  State<HoursScreen> createState() => _HoursScreenState();
}

class _HoursScreenState extends State<HoursScreen> {
  @override
  Widget build(BuildContext context) {
    String logo = Hive.box('mtclient').get('logo', defaultValue: '');
    // String bg = Hive.box('mtclient').get('bg', defaultValue: '');
    return Scaffold(
      body: Container(
        width: width(context),
        height: height(context),
        padding: const EdgeInsets.all(15),
        // decoration: BoxDecoration(
        //   color: black,
        //   image: bg == ''
        //       ? DecorationImage(
        //           image: AssetImage('assets/images/bg.png'),
        //           fit: BoxFit.cover,
        //           opacity: .8,
        //         )
        //       : DecorationImage(
        //           image: NetworkImage(bg), fit: BoxFit.cover, opacity: .8),
        // ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackButton(
                  color: black,
                ),
                logo == ''
                    ? Image.asset(
                        'assets/images/logo.png',
                        width: width(context) * .25,
                        // width: 140,
                        height: height(context) * .12,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        logo,
                        width: width(context) / .25,
                        // width: 140,
                        height: height(context) * .12,
                      ),
                const SizedBoxH30(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Day',
                        style: textStyle16.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Hour',
                        style: textStyle16.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: black,
                  thickness: 1,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: DatabaseService().getHours(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text('No data'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      return snapshot.data!.docs.isEmpty
                          ? const Center(
                              child: Text('No data'),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var data = snapshot.data!.docs[index];
                                return Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['day'],
                                            style: textStyle16.copyWith(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          data['isClosed']
                                              ? Text(
                                                  'Closed',
                                                  style: textStyle12.copyWith(
                                                    color: red,
                                                  ),
                                                )
                                              : Text(
                                                  '${data['start']} - ${data['end']}',
                                                  style: textStyle16.copyWith(),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) => Divider(),
                              itemCount: snapshot.data!.docs.length,
                            );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
