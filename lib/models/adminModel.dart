import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  static const UID = 'userId';
  static const EMAIL = 'emailAddress';
  static const PHONENUMBER = 'phoneNumber';
  static const PASSWORD = 'password';
  static const NAMES = 'customerNames';
  static const GENDER = 'gender';
  static const BIRTHDAY = 'birthDay';
  static const PROFILEPICTURE = 'profilePicture';
  static const ADMIN = 'administrators';
  static const GRAPHLIST = 'graphList';
  static const ABOUTUS = 'aboutUs';
  static const SERVICES = 'services';
  static const TERMSANDCONDITIONS = 'termsAndConditions';
  static const MISC = 'miscelaneous';
  static const LASTUPDATED = 'updatedAt';

  String _userId;
  String _email;
  String _phoneNumber;
  String _names;
  String _gender;
  DateTime _birthDay;
  String _profilePicture;
  List _graphList;
  String _aboutUs;
  String _services;
  String _termsAndConditions;
  String _misc;
  Timestamp _updatedAt;

  String get id => _userId;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get names => _names;
  String get gender => _gender;
  DateTime get birthDay => _birthDay;
  String get profilePicture => _profilePicture;
  List get graphList => _graphList;
  String get aboutUs => _aboutUs;
  String get services => _services;
  String get termsConditions => _termsAndConditions;
  String get miscSettings => _misc;
  Timestamp get updatedAt => _updatedAt;

  AdminModel.fromSnapshot(DocumentSnapshot snapshot) {
    _userId = snapshot.data()[UID];
    _email = snapshot.data()[EMAIL];
    _phoneNumber = snapshot.data()[PHONENUMBER];
    _names = snapshot.data()[NAMES];
    _gender = snapshot.data()[GENDER];
    _birthDay = snapshot.data()[BIRTHDAY];
    _profilePicture = snapshot.data()[PROFILEPICTURE];
    _graphList = snapshot.data()[GRAPHLIST];
    _aboutUs = snapshot.data()[ABOUTUS] ?? 'Not yet provided';
    _services = snapshot.data()[SERVICES] ?? 'Not yet provided';
    _termsAndConditions = snapshot.data()[TERMSANDCONDITIONS] ?? 'Not yet provided';
    _misc = snapshot.data()[MISC] ?? 'Not yet provided';
    _updatedAt = snapshot.data()[LASTUPDATED]??Timestamp.fromMillisecondsSinceEpoch(0);
  }
}
