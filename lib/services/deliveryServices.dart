import 'package:armotaleadmin/models/deliveryModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeliveryServices {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<DeliveryModel>> getDeliveries() async {
    List<DeliveryModel> deliveries = [];
    try {
      await _firestore.collection(DeliveryModel.SERVICEREQUESTS).get().then((value) {
        for (DocumentSnapshot snap in value.docs) {
          deliveries.add(DeliveryModel.fromSnapshot(snap));
          // print(deliveries[1].toString());
        }
      });
    } catch (e) {
      print(e.toString());
    }
    return deliveries;
  }
}
