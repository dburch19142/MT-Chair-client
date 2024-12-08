import 'package:clientapp/cores/constants/constants.dart';
import 'package:clientapp/cores/services/database.dart';
import 'package:clientapp/cores/shared/colors.dart';
import 'package:clientapp/cores/shared/size_boxes.dart';
import 'package:clientapp/cores/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
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
                      flex: 2,
                      child: Text(
                        'Name',
                        style: textStyle16.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Price',
                        textAlign: TextAlign.end,
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
                    stream: DatabaseService().getServices(),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        data['name'],
                                        style: textStyle16.copyWith(),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '\$${data['price']}',
                                        style: textStyle16.copyWith(),
                                        textAlign: TextAlign.end,
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
