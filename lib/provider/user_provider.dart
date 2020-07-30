import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voizit/Models/Strings.dart';
import 'package:voizit/Models/user.dart';

class UserProvider with ChangeNotifier {
  User _user;

    final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore firestore = Firestore.instance;
  static final Firestore _firestore = Firestore.instance;

  User get getUser => _user;
  User curUser ;
  DocumentReference profileReference ;
  String userid;

  void refreshUser() async {
    User user = await getUserDetails();
    _user = user;
    notifyListeners();
  }

  
   Future<User> getUserDetails() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
         
         userid = prefs.getString('userid');
      curUser = User(
          mobile: prefs.getString('mobile'),
          name: prefs.getString('name'),
          profilepic: prefs.getString('profilepic'),
        );
    DocumentSnapshot documentSnapshot =
        await _userCollection.document(userid).get();
            print("Hello I am User.... "+userid);
    return User.fromMap(documentSnapshot.data);
  }

    Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

    static final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);


}