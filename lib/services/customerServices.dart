import 'package:armotaleadmin/models/customerModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CustomerModel> customers = [];
  Future<List<CustomerModel>> getAllCustomers() async {
    try {
      await _firestore.collection(CustomerModel.USERS).get().then((allCustomers) {
        for (DocumentSnapshot driver in allCustomers.docs) {
          customers.add(CustomerModel.fromSnapshot(driver));
        }
      });
      return customers;
    } catch (e) {
      print(e.toString());
      return customers;
    }
  }

  Future<List<CustomerModel>> getAllCustomerSpendings() async {
    try {
      await _firestore.collection(CustomerModel.USERS).orderBy(CustomerModel.TOTALSPENDINGS, descending: true).get().then((allCustomers) {
        for (DocumentSnapshot driver in allCustomers.docs) {
          customers.add(CustomerModel.fromSnapshot(driver));
        }
      });
      return customers;
    } catch (e) {
      print(e.toString());
      return customers;
    }
  }
}
