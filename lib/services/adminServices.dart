
import 'package:armotaleadmin/models/adminModel.dart';
import 'package:armotaleadmin/models/driverModel.dart';
import 'package:armotaleadmin/views/auth/login.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/changeScreen.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/styling.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> createUser(String emailAddress, String password, BuildContext context) async {
    try {
      await auth.createUserWithEmailAndPassword(email: emailAddress, password: password).then((value) {
        _firestore.collection(AdminModel.ADMIN).doc(auth.currentUser.uid).set(
          {
            // UserModel.NAMES: userName,
            // UserModel.PHONENUMBER: phoneNumber,
            AdminModel.EMAIL: emailAddress,
            AdminModel.UID: auth.currentUser.uid,
          },
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomText(
        text: 'Sign up successful',
        textAlign: TextAlign.center,
        color: white,
      )));
      Navigator.pushReplacementNamed(context, '/homePage');
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomText(
            color: white,
            text: e.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );
      print(e.toString());
      return false;
    }
  }

  Future<bool> loginUser(String emailAddress, String password, BuildContext context) async {
    // bool success = false;
    try {
      await auth.signInWithEmailAndPassword(email: emailAddress, password: password);
      Navigator.pushReplacementNamed(context, '/homePage');
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomText(
            text: 'Invalid email or password',
            textAlign: TextAlign.center,
            color: white,
          ),
        ),
      );
      // Fluttertoast.showToast(msg: 'Invalid email or password');
      print(e.toString());
      return false;
    }
  }

  Future<List<AdminModel>> getAllAdministrators() async {
    List<AdminModel> administrators = [];
    try {
      await _firestore.collection(AdminModel.ADMIN).get().then((doc) {
        for (DocumentSnapshot admin in doc.docs) {
          administrators.add(AdminModel.fromSnapshot(admin));
        }
      });
    } catch (e) {
      print(e.toString());
    }
    return administrators;
  }

  Future<bool> signOutAdmin(BuildContext context) async {
    try {
      await auth.signOut();
      changeScreenReplacement(context, Login());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: grey[100],
          content: CustomText(
            text: 'You have been successfully signed out',
            textAlign: TextAlign.center,
            color: Colors.red,
          )));
      return true;
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: grey[100],
          content: CustomText(
            text: 'Error encountered!!',
            textAlign: TextAlign.center,
            color: Colors.red,
          )));
      return false;
    }
  }

  Future<bool> authorizeUser(String driverId, bool authStatus, BuildContext context) async {
    try {
      await _firestore.collection(DriverModel.users).doc(driverId).update(
        {
          DriverModel.VERIFIED: authStatus,
        },
      );
      if (authStatus == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: grey[100],
            content: CustomText(
              text: 'Driver verification successful',
              textAlign: TextAlign.center,
              color: Colors.green,
            )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: grey[100],
            content: CustomText(
              text: 'Driver deactivation successful',
              textAlign: TextAlign.center,
              color: Colors.red,
            )));
      }

      return true;
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: grey[100],
          content: CustomText(
            text: 'Error encountered!!',
            textAlign: TextAlign.center,
            color: Colors.red,
          )));
      return false;
    }
  }

  Future saveGraphList(List<double> latestValue) async {
    try {
      await _firestore.collection(AdminModel.ADMIN).get().then((doc) {
        print(doc.docs[0].data()['userId']);
        if (!doc.docs[0].data().containsKey(AdminModel.GRAPHLIST) || DateTime.now().weekday == 1) {
          _firestore.collection(AdminModel.ADMIN).doc(doc.docs[0].data()['userId']).update({
            AdminModel.GRAPHLIST: [0],
          });
        } else {
          _firestore.collection(AdminModel.ADMIN).doc(doc.docs[0].data()['userId']).update({
            AdminModel.GRAPHLIST: latestValue,
          });
        }
      });
    } catch (e) {
      print('dcdcdsvav' + e.toString());

      print(e.toString());
    }
  }

  // Future update

  Future<List<double>> getGraphList() async {
    List<double> latestGraphValue = [];
    try {
      await _firestore.collection(AdminModel.ADMIN).get().then((doc) {
        latestGraphValue = doc.docs[0].data()[AdminModel.GRAPHLIST];
      });
      print(latestGraphValue);
      return latestGraphValue;
    } catch (e) {
      print('Latest graph error is ' + e.toString());
      return null;
    }
  }

  Future updateAdmin(String termsAndConditions, String services, String miscSettings, String aboutUs, Timestamp lastUpdate) async {
    try {
      await _firestore.collection(AdminModel.ADMIN).get().then((doc) {
        print(doc.docs[0].data()['userId']);
        _firestore.collection(AdminModel.ADMIN).doc(doc.docs[0].data()['userId']).update({
          AdminModel.TERMSANDCONDITIONS: termsAndConditions,
          AdminModel.SERVICES: services,
          AdminModel.MISC: miscSettings,
          AdminModel.ABOUTUS: aboutUs,
          AdminModel.LASTUPDATED: lastUpdate,
        });
      });
      print('object');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<AdminModel>> getLatestValues() async {
    List<AdminModel> adminValues = [];
    try {
      await _firestore.collection(AdminModel.ADMIN).get().then((doc) {
        for (DocumentSnapshot admin in doc.docs) {
          adminValues.add(AdminModel.fromSnapshot(admin));
        }
      });
      print(adminValues[0].aboutUs);
      return adminValues;
    } catch (e) {
      print(e.toString());
      return adminValues;
    }
  }
}
