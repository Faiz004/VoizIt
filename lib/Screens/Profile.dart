import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voizit/Screens/HomeScreen.dart';
import 'package:voizit/Screens/home_page.dart';
import 'RegistrationPage.dart';

class Profile extends StatefulWidget {
  final SharedPreferences prefs;
  Profile({this.prefs});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _currentIndex = 0;
  String _tabTitle = "Profile";
  List<Widget> _children = [Container(), Container()];

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

  Future<void> getProfilePicture() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profiles/${widget.prefs.getString('userid')}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String fileUrl = await storageReference.getDownloadURL();
    profileReference.updateData({'profilepic': fileUrl});
  }

  generateProfileTab() {
    return Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (profileSnapshot != null
                ? (profileSnapshot.data['profilepic'] != null
                    ? InkWell(
                        child: Container(
                          width: 210.0,
                          height: 210.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  '${profileSnapshot.data['profilepic']}'),
                            ),
                          ),
                        ),
                        onTap: () {
                          getProfilePicture();
                        },
                      )
                    : Container())
                : Container()),
            SizedBox(
              height: 20,
            ),
            (!editName && profileSnapshot != null
                ? new Container(
                    width: 300,
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${profileSnapshot.data["name"]}',
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              editName = true;
                            });
                          },
                        ),
                      ],
                    ))
                : Container()),
            (editName
                ? Form(
                    key: _formStateKey,
                    autovalidate: true,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter Name';
                              }
                              if (value.trim() == "")
                                return "Only Space is Not Valid!!!";
                              return null;
                            },
                            controller: _yourNameController,
                            decoration: InputDecoration(
                              focusedBorder: new UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      width: 5, style: BorderStyle.solid)),
                              labelText: "Enter Your Name",
                              focusColor: Theme.of(context).primaryColor,
                              icon: Icon(
                                Icons.verified_user,
                                color: Theme.of(context).primaryColor,
                              ),
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()),
            (editName
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                        child: Text(
                          'UPDATE',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          if (_formStateKey.currentState.validate()) {
                            profileReference
                                .updateData({'name': _yourNameController.text});
                            setState(() {
                              editName = false;
                            });
                          }
                        },
                        color: Theme.of(context).primaryColor,
                      ),
                      RaisedButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          setState(() {
                            editName = false;
                          });
                        },
                      )
                    ],
                  )
                : Container())
          ]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      switch (_currentIndex) {
        case 0:
          _tabTitle = "Profile";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _children = [
      generateProfileTab(),
    ];
    return MaterialApp(
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'My Profile',
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
              (_currentIndex == 0
                  ? Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.backspace),
                          onPressed: () {
                            FirebaseAuth.instance.signOut().then((response) {
                              widget.prefs.remove('is_verified');
                              widget.prefs.remove('mobile');
                              widget.prefs.remove('userid');
                              widget.prefs.remove('name');
                              widget.prefs.remove('profilepic');
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RegistrationPage(prefs: widget.prefs),
                                ),
                              );
                            });
                          },
                        )
                      ],
                    )
                  : Container())
            ],
          ),
          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped, // new
            currentIndex: _currentIndex, // new
            items: [
              new BottomNavigationBarItem(
                icon: Icon(
                  Icons.verified_user,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('Profile',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 33.0,
            ),
            backgroundColor: Colors.purple,
            onPressed: () {
              print("Entered");
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomeScreen(prefs: widget.prefs),
              )
              );
            },
          ),
        ),
      ),
    );
  }
}
