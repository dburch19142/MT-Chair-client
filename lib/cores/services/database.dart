import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clientapp/cores/services/collections.dart';
import 'package:clientapp/cores/services/upload.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  static addBarber({required String name, required File file}) async {
    String id = const Uuid().v4();
    var uploadUrl = await UploadService().uploadImage(file);
    bool request = await FireCollections.barberRef.doc(id).set({
      'name': name,
      'created_at': DateTime.now(),
      'photo_url': uploadUrl,
      'id': id,
      'available': false,
    }).then((value) {
      // FireCollections.barberRef.doc(value.id).update({'id': value.id});
      return true;
    }).catchError((error) {
      return false;
    });
    return request;
  }

  static updateBg({required File file}) async {
    var uploadUrl = await UploadService().uploadImage(file);
    bool request = await FireCollections.settingsRef.doc('settings').update({
      'bg': uploadUrl,
    }).then((value) async {
      await Hive.box('mtclient').put('bg', uploadUrl);
      return true;
    }).catchError((error) {
      return false;
    });
    return request;
  }

  static updateLogo({required File file}) async {
    var uploadUrl = await UploadService().uploadImage(file);
    bool request = await FireCollections.settingsRef.doc('settings').update({
      'logo': uploadUrl,
    }).then((value) async {
      await Hive.box('mtclient').put('logo', uploadUrl);
      return true;
    }).catchError((error) {
      return false;
    });
    return request;
  }

  Stream<QuerySnapshot> getAllBarbersStream() {
    return FireCollections.barberRef.snapshots();
  }

  Stream<QuerySnapshot> getAvailableBarbersStream() {
    return FireCollections.barberRef
        .where('available', isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getQueue() {
    return FireCollections.bookingRef
        .where('status', isEqualTo: 'waiting')
        .orderBy('appointmentDate', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getWaitingBooking() {
    return FireCollections.bookingRef
        .where('status', isEqualTo: 'waiting')
        .snapshots();
  }

  Stream<QuerySnapshot> getWalkInBooking() {
    return FireCollections.bookingRef
        .where('status', isEqualTo: 'waiting')
        .where('type', isEqualTo: 'walk-in')
        .snapshots();
  }

  Stream<QuerySnapshot> getAppointmentBooking() {
    return FireCollections.bookingRef
        .where('status', isEqualTo: 'waiting')
        .where('type', isEqualTo: 'appointment')
        .snapshots();
  }

  Stream<QuerySnapshot> getHours() {
    return FireCollections.hoursRef.orderBy('dayIndex').snapshots();
  }

  Stream<QuerySnapshot> getServices() {
    return FireCollections.servicesRef.snapshots();
  }

  Stream<QuerySnapshot> getBarberQueue({required String barberId}) {
    return FireCollections.bookingRef
        .where('status', isEqualTo: 'waiting')
        .where('barberId', isEqualTo: barberId)
        .where('barberId', isEqualTo: 'First Available')
        .snapshots();
  }

  static deleteBarber({required String barberId}) async {
    bool request = await FireCollections.barberRef
        .doc(barberId)
        .delete()
        .then((value) async {
      //     await FireCollections.bookingRef.where('barberId', isEqualTo: barberId).get().then((value) {
      //  for (var e in value.docs) {

      //  }
      //  });

      return true;
    }).catchError((error) {
      return false;
    });
    return request;
  }

  static addQueue({required Map<String, dynamic> data}) async {
    String id = const Uuid().v4();
    log(id);
    bool request = await FireCollections.bookingRef.doc(id).set({
      ...data,
      'id': id,
    }).then((value) {
      return true;
    }).catchError((error) {
      return false;
    });
    return request;
  }

  static updateQueue(
      {required String id,
      required bool firstAvailable,
      required String barberId,
      required String barberName}) async {
    if (firstAvailable) {
      bool request = await FireCollections.bookingRef.doc(id).update({
        'status': 'checked',
        'barberId': barberId,
        'barberName': barberName,
        'check_time': DateTime.now(),
      }).then((value) {
        return true;
      }).catchError((error) {
        return false;
      });
      return request;
    } else {
      bool request = await FireCollections.bookingRef
          .doc(id)
          .update({'status': 'checked'}).then((value) {
        return true;
      }).catchError((error) {
        return false;
      });
      return request;
    }
  }

  static Future<List> getStat({
    required DateTime selectedDate,
    required DateTime toSelectedDate,
    required String barberId,
  }) async {
    // print(selectedDate);
    // print(toSelectedDate);
    List data = [];
    Query query = FireCollections.bookingRef
        .where('barberId', isEqualTo: barberId)
        .where('status', isEqualTo: 'checked')
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(toSelectedDate),
        )
        .where(
          'createdAt',
          isLessThanOrEqualTo: Timestamp.fromDate(selectedDate),
        );

    QuerySnapshot querySnapshot = await query.get();
    // print(querySnapshot.docs);
    // print(barberId + ' ' + querySnapshot.docs.length.toString());
    for (var element in querySnapshot.docs) {
      data.add(element);
    }
    return data;
  }
}
