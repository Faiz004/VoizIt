import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:voizit/Models/ChartModel.dart';
import 'package:voizit/Models/user.dart';
import 'package:voizit/Screens/CallScreens/Pickup/PickupLayout.dart';
import 'package:voizit/Screens/NewMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voizit/Screens/SearchScreen.dart';
import 'package:voizit/Widgets/CustomTile.dart';
import 'package:voizit/provider/user_provider.dart';
import 'DrawerScreen.dart';
import 'ChatPage.dart';

class HomeScreen extends StatefulWidget {
  final SharedPreferences prefs;
  HomeScreen({this.prefs});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = Firestore.instance;
  final ContactPicker _contactPicker = new ContactPicker();
  CollectionReference contactsReference;
  DocumentReference profileReference;
  DocumentSnapshot profileSnapshot;

  UserProvider userProvider;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User sender;
  String _currentUserId;

  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _yourNameController = TextEditingController();
  bool editName = false;
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();

      getCurrentUser().then((user) {
        _currentUserId = user.uid;
        setState(() {
          sender = User(
            mobile: user.uid,
            name: user.displayName,
            profilepic: user.photoUrl,
          );
        });
      });
    });

    contactsReference = db
        .collection("Users")
        .document(widget.prefs.getString('userid'))
        .collection('contacts');
    profileReference =
        db.collection("Users").document(widget.prefs.getString('userid'));

    profileReference.snapshots().listen((querySnapshot) {
      profileSnapshot = querySnapshot;
      widget.prefs.setString('name', profileSnapshot.data["name"]);
      widget.prefs.setString('profilepic', profileSnapshot.data["profilepic"]);
    });
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  generateContactTab() {
    return Column(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
          stream: contactsReference.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData && snapshot.data == null)
              return new Center(
                  child: new Text(
                "Add friends from your Contact List and Voiz'em in.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                ),
              ));
            return Expanded(
              child: new ListView(
                children: generateContactList(snapshot),
              ),
            );
          },
        )
      ],
    );
  }

  generateContactList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map<Widget>(
          (doc) => InkWell(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              child: CustomTile(
                mini: false,
                onTap: () async {
                  QuerySnapshot result = await db
                      .collection('Chats')
                      .where('contact1',
                          isEqualTo: widget.prefs.getString('userid'))
                      .where('contact2', isEqualTo: doc["userid"])
                      .getDocuments();
                  List<DocumentSnapshot> documents = result.documents;
                  if (documents.length == 0) {
                    result = await db
                        .collection('Chats')
                        .where('contact2',
                            isEqualTo: widget.prefs.getString('userid'))
                        .where('contact1', isEqualTo: doc["userid"])
                        .getDocuments();
                    documents = result.documents;
                    if (documents.length == 0) {
                      await db.collection('Chats').add({
                        'contact1': widget.prefs.getString('userid'),
                        'contact2': doc["userid"]
                      }).then((documentReference) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              prefs: widget.prefs,
                              chatId: documentReference.documentID,
                              title: doc["name"],
                              number: doc["number"],
                            ),
                          ),
                        );
                      }).catchError((e) {});
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            prefs: widget.prefs,
                            chatId: documents[0].documentID,
                            title: doc["name"],
                          ),
                        ),
                      );
                    }
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          prefs: widget.prefs,
                          chatId: documents[0].documentID,
                          title: doc["name"],
                        ),
                      ),
                    );
                  }
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                  backgroundColor: Colors.white,
                ),
                title: Text(
                  doc["name"],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "+" + doc["mobile"],
                  style: TextStyle(color: Colors.blueGrey),
                ),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
          ),
        )
        .toList();
  }

  openContacts() async {
    Contact contact = await _contactPicker.selectContact();
    if (contact != null) {
      String phoneNumber = contact.phoneNumber.number
          .toString()
          .replaceAll(new RegExp(r"\s\b|\b\s"), "")
          .replaceAll(new RegExp(r'[^\w\s]+'), '');
      if (phoneNumber.length == 10) {
        DocumentReference mobileRef = db
            .collection("Mobiles")
            .document(phoneNumber.replaceAll(new RegExp(r'[^\w\s]+'), ''));
        await mobileRef.get().then((documentReference) {
          if (documentReference.exists) {
            contactsReference.add({
              'userid': documentReference['userid'],
              'name': contact.fullName,
              'mobile': phoneNumber.replaceAll(new RegExp(r'[^\w\s]+'), ''),
            });
          } else {
            print("User is not Registered yet!");
            showAlertDialog(context);
          }
        }).catchError((e) {});
      }
      if (phoneNumber.length == 11) {
        DocumentReference mobileRef = db
            .collection("Mobiles")
            .document(phoneNumber.replaceAll(new RegExp(r'[^\w\s]+'), ''));
        await mobileRef.get().then((documentReference) {
          if (documentReference.exists) {
            contactsReference.add({
              'userid': documentReference['userid'],
              'name': contact.fullName,
              'mobile': phoneNumber.replaceAll(new RegExp(r'[^\w\s]+'), ''),
            });
          } else {
            print("User is not Registered yet!");
            showAlertDialog(context);
          }
        }).catchError((e) {});
      }

      if (phoneNumber.length == 12) {
        DocumentReference mobileRef = db
            .collection("Mobiles")
            .document(phoneNumber.replaceAll(new RegExp(r'[^\w\s]+'), ''));
        await mobileRef.get().then((documentReference) {
          if (documentReference.exists) {
            contactsReference.add({
              'userid': documentReference['userid'],
              'name': contact.fullName,
              'mobile': phoneNumber.replaceAll(new RegExp(r'[^\w\s]+'), ''),
            });
          } else {
            print("User is not Registered yet!");
            showAlertDialog(context);
          }
        }).catchError((e) {});
      } else {
        showAlertDialog(context);
      }
    }
  }

  showAlertDialog(BuildContext context) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("User is not Registered yet!"),
      content: Text(
          "Send them invite link to Voiz them in or try saving the number along with country code"),
      actions: [
        FlatButton(
          child: Text('OK!'),
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
          scaffold: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Voizlt',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 50.0,
                color: Colors.white,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor,
                ],
              )),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.of(context).canPop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SearchScreen(prefs: widget.prefs)));
                },
              ),
            ]),
        drawer: DrawerScreen(prefs: widget.prefs),
        body: generateContactTab(),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          // foregroundColor: Colors.teal,
          onPressed: () {
            openContacts();
          },
        ),
      ),
    );
  }
}
