import 'package:clientapp/cores/constants/constants.dart';
import 'package:clientapp/cores/services/database.dart';
import 'package:clientapp/cores/shared/button.dart';
import 'package:clientapp/cores/shared/colors.dart';
import 'package:clientapp/cores/shared/size_boxes.dart';
import 'package:clientapp/cores/shared/style.dart';
import 'package:clientapp/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class WaitingListScreen extends StatefulWidget {
  const WaitingListScreen({super.key});

  @override
  State<WaitingListScreen> createState() => _WaitingListScreenState();
}

class _WaitingListScreenState extends State<WaitingListScreen> {
  @override
  void initState() {
    super.initState();
  }

  final f = DateFormat.jm();
  @override
  Widget build(BuildContext context) {
    // String logo = Hive.box('empty').get('logo', defaultValue: '');
    String bg = Hive.box('empty').get('bg', defaultValue: '');
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          width: width(context),
          height: height(context),
          padding: const EdgeInsets.all(15),
          alignment: Alignment.center,
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
          child: StreamBuilder<QuerySnapshot>(
              stream: DatabaseService().getQueue(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No data available'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: red,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(20),
                          width: width(context),
                          decoration: BoxDecoration(
                              color: const Color(0xffD9D9D9),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'CLIENT',
                                            style: textStyle12.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  constraints.maxWidth <= 768
                                                      ? 8
                                                      : 12,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'BARBER',
                                            style: textStyle12.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  constraints.maxWidth <= 768
                                                      ? 8
                                                      : 12,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'STATUS',
                                            style: textStyle12.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  constraints.maxWidth <= 768
                                                      ? 8
                                                      : 12,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'SIGNIN TIME',
                                            style: textStyle12.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  constraints.maxWidth <= 768
                                                      ? 8
                                                      : 12,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'APPOINT. TIME',
                                            style: textStyle12.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  constraints.maxWidth <= 768
                                                      ? 8
                                                      : 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var data = snapshot.data!.docs;
                                        Timestamp timestamp =
                                            data[index]['appointmentDate'];
                                        int time =
                                            timestamp.millisecondsSinceEpoch;
                                        var date =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                time);
                                        var dateformat = f.format(date);
                                        return Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  data[index]['clientName'],
                                                  style: textStyle12.copyWith(
                                                    fontSize:
                                                        constraints.maxWidth <=
                                                                768
                                                            ? 8
                                                            : 12,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  data[index]['barberName'],
                                                  style: textStyle12.copyWith(
                                                    fontSize:
                                                        constraints.maxWidth <=
                                                                768
                                                            ? 8
                                                            : 12,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  data[index]['type'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: textStyle12.copyWith(
                                                    fontSize:
                                                        constraints.maxWidth <=
                                                                768
                                                            ? 8
                                                            : 12,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  dateformat,
                                                  style: textStyle12.copyWith(
                                                    fontSize:
                                                        constraints.maxWidth <=
                                                                768
                                                            ? 8
                                                            : 12,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  data[index]['appointmentTime'] ==
                                                          '00pm'
                                                      ? ''
                                                      : data[index]
                                                          ['appointmentTime'],
                                                  style: textStyle12.copyWith(
                                                    fontSize:
                                                        constraints.maxWidth <=
                                                                768
                                                            ? 8
                                                            : 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBoxH10(),
                                      itemCount: snapshot.data!.docs.length,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBoxH20(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: CustomButton(
                                      onPressed: () {
                                        Get.toNamed(AppPages.mainPage);
                                      },
                                      text: 'Back',
                                      textColor: white,
                                      bgColor: green,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 150,
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                );
              }),
        );
      }),
    );
  }
}
