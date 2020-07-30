import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:voizit/Screens/HomeScreen.dart';
import 'package:voizit/Screens/Profile.dart';
import 'package:voizit/Screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';


class RegistrationPage extends StatefulWidget {
  final SharedPreferences prefs;
  RegistrationPage({this.prefs});
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  
    Country _selected;
  String number;
  String _phonecode = "";
  final _phoneController = TextEditingController();

    bool isLoginPressed = false;

  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  final db = Firestore.instance;

  @override
  initState() {
    super.initState();
  }

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {});
    };

    setState(() {
      isLoginPressed = true;
    });

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException e) {
            print('${e.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter the OTP here'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: () async{
                  _auth.currentUser().then((user) async {
                    print(user);
                    signIn();
                    } );
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      print("I am in Sign in");
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
            print("I am in Sign in 2");

      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
       print("I am in Sign in 3");

      Navigator.of(context).pop();
      DocumentReference mobileRef = db
          .collection("Mobiles")
          .document(phoneNo.replaceAll(new RegExp(r'[^\w\s]+'), ''));
      await mobileRef.get().then((documentReference) {
        if (!documentReference.exists) {
          mobileRef.setData({}).then((documentReference) async {
            await db.collection("Users").add({
              'mobile': phoneNo.replaceAll(new RegExp(r'[^\w\s]+'), ''),
              'name': "No Name",
              'profilepic': "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
            }).then((documentReference) {
              widget.prefs.setBool('is_verified', true); 
              widget.prefs.setString('mobile', phoneNo.replaceAll(new RegExp(r'[^\w\s]+'), ''),);
              widget.prefs.setString('userid', documentReference.documentID);
              widget.prefs.setString('name', "No Name");
              widget.prefs.setString('profilepic', "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");
              mobileRef.setData({'userid': documentReference.documentID}).then(
                  (documentReference) async {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Profile(prefs: widget.prefs)));
              }).catchError((e) {
                print(e);
              });
            }).catchError((e) {
              print(e);
            });
          });
        } else {
          widget.prefs.setBool('is_verified', true);
          widget.prefs.setString('mobile',phoneNo.replaceAll(new RegExp(r'[^\w\s]+'), ''),);
          widget.prefs.setString('userid', documentReference["userid"]);
          widget.prefs.setString('name', "No Name");
          widget.prefs.setString('profilepic', "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Profile(prefs: widget.prefs),
            ),
          );
        }
      }).catchError((e) {});
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {});
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        //  centerTitle : true,
        title: Text(
          'My Phone',
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
      ),
      body: new Stack(
        children: <Widget>[
           
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
           CountryPicker(
                dense: false,
                showFlag: true, //displays flag, true by default
                showDialingCode: true, //displays dialing code, false by default
                showName: true, //displays country name, true by default
                showCurrency: false, //eg. 'British pound'
                onChanged: (Country country) {
                  setState(() {
                    _selected = country;
                    print("${_selected.dialingCode}");
                    _phonecode = _selected.dialingCode.toString();
                  });
                },
                selectedCountry: _selected,
              ),

                SizedBox(
                  height: 16,
                ),
                new Row(
                  children: <Widget>[
                    new Container(
                      height: 50.0,
                      margin: const EdgeInsets.only(right:10.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor,),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child : new Center(
                         child: 
                       _phonecode == "" ? new Text("_ _") : new Text("+" + "$_phonecode", 
                       style: new TextStyle(
                         fontSize: 20.0),
                         ),
                      ),
                     ),

                   
                    new Expanded(
                      child:  TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.deepPurple)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.deepPurple)),
                    //  filled: true,
                     // fillColor: Colors.grey[100],
                      hintText: "Mobile Number"),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                      ),
                  (
              errorMessage != ''
                ? Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  )
                : Container()
                ), 

                  ],
                ),
                
                Padding(padding: EdgeInsets.all(10.0)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: new Container(
                    child: new Text(
                      "Enter your Phone Number with country code here and you will recieve an OTP through message.",
                      textAlign: TextAlign.start,
                      // textScaleFactor: 0.5,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ),
      ),
      isLoginPressed
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor

                  ),
                )
              : Container()

        ],
      ),
     
         floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
          size: 33.0,
        ),
        backgroundColor: Colors.purple,
        // foregroundColor: Colors.teal,
        onPressed: () {
          print("Entered");
          this.phoneNo = "+" + _phonecode + _phoneController.text.trim();
          verifyPhone();
        },
      ),
    );
  }

}



