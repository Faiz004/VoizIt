import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddContact extends StatefulWidget {

  final SharedPreferences prefs;
  AddContact({this.prefs});
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  Country _selected;
  String number;
  String name;
  String _phonecode;
  final _phoneController = TextEditingController();

  //String phonenumber;

   
  final db = Firestore.instance;
  final ContactPicker _contactPicker = new ContactPicker();
  CollectionReference contactsReference;
  DocumentReference profileReference;
  DocumentSnapshot profileSnapshot;

  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final _yourNameController = TextEditingController();
  final _yourFNameController = TextEditingController();
  final _yourLNameController = TextEditingController();



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
      widget.prefs
          .setString('profilepic', profileSnapshot.data["profilepic"]);

    });
  }


  saveContacts() async {
   // Contact contact = await _contactPicker.selectContact();
    if (_phoneController != null) {
      String phoneNumber =   _phonecode + _phoneController.text.trim()

          .toString()
          .replaceAll(new RegExp(r"\s\b|\b\s"), "")
          .replaceAll(new RegExp(r'[^\w\s]+'), '');
      if (phoneNumber.length == 10) {
        print(phoneNumber);
    DocumentReference mobileRef = db
            .collection("Mobiles")
            .document(phoneNumber.replaceAll(new RegExp(r'[^\w\s]+'), ''));
        await mobileRef.get().then((documentReference) {
          if (documentReference.exists) {
            contactsReference.add({
              'userid': documentReference['userid'],
              'name': _yourNameController.text,
              'mobile': phoneNumber.replaceAll(new RegExp(r'[^\w\s]+'), ''),
              
            });
          } else {
            print("User is not Registered yet!");
           showAlertDialog(context);
          }
        }).catchError((e) {});        
      }
      if (phoneNumber.length == 11) {
                print(phoneNumber);
 DocumentReference mobileRef = db
            .collection("Mobiles")
            .document(phoneNumber.replaceAll(new RegExp(r'[^\w\s]+'), ''));
        await mobileRef.get().then((documentReference) {
          if (documentReference.exists) {
            contactsReference.add({
              'userid': documentReference['userid'],
              'name': _yourNameController.text,
              'mobile': phoneNumber.replaceAll(new RegExp(r'[^\w\s]+'), ''),
            });
          } else {
            print("User is not Registered yet!");
           showAlertDialog(context);
          }
        }).catchError((e) {});     
         }

      if (phoneNumber.length == 12) {
                print(phoneNumber);

        DocumentReference mobileRef = db
            .collection("Mobiles")
            .document(phoneNumber.replaceAll(new RegExp(r'[^\w\s]+'), ''));
        await mobileRef.get().then((documentReference) {
          if (documentReference.exists) {
            contactsReference.add({
              'userid': documentReference['userid'],
              'name'  : _yourNameController.text,
              'mobile': phoneNumber.replaceAll(new RegExp(r'[^\w\s]+'), ''),
            });
          } else {
            print("User is not Registered yet!");
           showAlertDialog(context);
          }
        }).catchError((e) {});
      } else {
                print(phoneNumber);

           showAlertDialog(context);
      }
    }
  }
     showAlertDialog(BuildContext context) {  
  // Create AlertDialog  
  AlertDialog alert = AlertDialog(  
   title: Text("User is not Registered yet!"),
   content: Text("Send them invite link to Voiz them in or try saving the number along with country code"),
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

     showSavedDialog(BuildContext context) {  
  // Create AlertDialog  
  AlertDialog saved = AlertDialog(  
   title: Text("Contact added Successfully!"),
   content: Text("Now you can text and call them through VoizIt"),
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
      return saved;  
    },  
  ); 
 
} 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //  centerTitle : true,
          title: Text(
            'Add New Contact',
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
              icon: Icon(Icons.check),
              iconSize: 35.0,
              onPressed: () {
                print('Click Save');
                saveContacts();
                showSavedDialog(context);
              },
            ),
          ]),
      body: new Container(
          child: new Column(
        children: <Widget>[
          new Padding(padding: EdgeInsets.all(10.0)),
          new Row(
            children: <Widget>[
              new Padding(padding: EdgeInsets.all(10.0)),
              new InkWell(

                child : new Container(
                  child:  CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    'https://cdn.iconscout.com/icon/free/png-512/user-598-132486.png'),
                    
              ),
                ),   
              onTap: () {ImagePicker.pickImage(source: ImageSource.gallery);},

              ),
             
              new Padding(padding: EdgeInsets.all(10.0)),
              new Container(
                width: 230.0,
                child: new Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'First Name (Required)',
                      ),
                        controller: _yourNameController ,

                    ),
                   
                  ],
                ),
              ),
            ],
          ),
          new Padding(padding: EdgeInsets.all(8.0)),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

               new Padding(padding: EdgeInsets.only(left:8.0)),

              CountryPicker(
                dense: false,
                showFlag: true, //displays flag, true by default
                showDialingCode: true, //displays dialing code, false by default
                showName: false, //displays country name, true by default
                showCurrency: false, //eg. 'British pound'
                //eg. 'GBP'
                onChanged: (Country country) {
                 setState(() {
                    _selected = country;
                    print("${_selected.dialingCode}");
                    _phonecode = _selected.dialingCode.toString();
                  });
                },
                selectedCountry: _selected,
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    hintText: "Mobile Number",
                  ),
                   controller: _phoneController,
                  
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
