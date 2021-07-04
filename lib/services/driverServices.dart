import 'package:armotaleadmin/models/driverModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<DriverModel>> getAllDrivers() async {
    List<DriverModel> drivers = [];
    try {
      await _firestore.collection(DriverModel.users).get().then((doc) {
        for (DocumentSnapshot user in doc.docs) {
          drivers.add(DriverModel.fromSnapshot(user));
        }
      });
    } catch (e) {
      print('the error is '+e.toString());
    }
    return drivers;
  }

    Future<List<DriverModel>> getAllDriverEarnings() async {
    List<DriverModel> drivers = [];
    try {
      await _firestore.collection(DriverModel.users).orderBy(DriverModel.TOTALEARNINGS, descending: true).get().then((doc) {
        for (DocumentSnapshot user in doc.docs) {
          drivers.add(DriverModel.fromSnapshot(user));
        }
      });
    } catch (e) {
      print('the error is'+e.toString());
    }
    return drivers;
  }

  Future updateUser(String uid, bool driverStatus, String firstName, String lastName, String emailAddress, String phoneNumber) async {
    try {
      await _firestore.collection(DriverModel.users).doc(uid).update(
        {
          DriverModel.STATUS: driverStatus,
          DriverModel.FIRSTNAME: firstName,
          DriverModel.LASTNAME: lastName,
          DriverModel.EMAIL: emailAddress,
          DriverModel.PHONENUMBER: phoneNumber,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
