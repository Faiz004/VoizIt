import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voizit/Models/ChartModel.dart';
import 'package:voizit/Screens/AddContact.dart';
import 'package:voizit/Screens/NewGroup.dart';
import 'package:voizit/Screens/NewPodcast.dart';
import 'package:voizit/Screens/NewSecretChat.dart';
import 'package:voizit/Screens/SearchScreen.dart';

import 'ChatPage.dart';

class NewMessage extends StatefulWidget {
  final SharedPreferences prefs;
  NewMessage({this.prefs});

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final db = Firestore.instance;
  final ContactPicker _contactPicker = new ContactPicker();
  CollectionReference contactsReference;
  DocumentReference profileReference;
  DocumentSnapshot profileSnapshot;

  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _yourNameController = TextEditingController();
  bool editName = false;
  @override
  void initState() {
    super.initState();
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

      setState(() {
        _yourNameController.text = profileSnapshot.data["name"];
      });
    });
  }

  generateContactTab() {
    return Column(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
          stream: contactsReference.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return new Center(
                  child: new Text(
                "Add friends from the Contact List and Voiz'em in.",
                textAlign: TextAlign.justify,
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
              child: ListTile(
                //  leading: CircleAvatar(
                //  radius: 28,
                //  backgroundImage: NetworkImage(doc["profilepic"]),),
                title: Text(doc["name"]),
                subtitle: Text(doc["mobile"]),
                // trailing: Icon(Icons.chevron_right),
              ),
            ),
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
    return Scaffold(
      appBar: AppBar(
          //  centerTitle : true,
          title: Text(
            'New Message',
            style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
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
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Container(
              height: 192,
              child: Column(children: <Widget>[
                Card(
                  elevation: 0.0,
                  child: ListTile(
                    leading: Icon(Icons.group),
                    title: Text(
                      'New Audio Group',
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    onTap: () {
                      print("Audio Group tapped");
                      Navigator.of(context).canPop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => NewGroup(prefs: widget.prefs,)));
                    },
                  ),
                ),
                Card(
                  elevation: 0.0,
                  child: ListTile(
                    leading: Icon(Icons.lock),
                    title: Text(
                      'New Secret Chat',
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    onTap: () {
                      print("New Secret chat tapped");
                      Navigator.of(context).canPop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => NewSecretChat(prefs: widget.prefs)));
                    },
                  ),
                ),
                Card(
                  elevation: 0.0,
                  child: ListTile(
                    leading: Icon(Icons.mic),
                    title: Text(
                      'New Podcast',
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    onTap: () {
                      print("Podcasts tapped");
                      Navigator.of(context).canPop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => NewPodcast()));
                    },
                  ),
                ),
              ]),
            ),
            new Text(
              "Recent Chats",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            new Expanded(
              // height: MediaQuery.of(context).size.height - 292,
              child: generateContactTab(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 33.0,
        ),
        backgroundColor: Colors.purple,
        // foregroundColor: Colors.teal,
        onPressed: () {
          openContacts();
        },
      ),
    );
  }
}
