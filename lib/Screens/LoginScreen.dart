import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './HomeScreen.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {

  Country _selected;
  String number;
  String _phonecode = "";

  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  Future<bool> loginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;

          if (user != null) {
            print("Entered");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
          } else {
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "Enter the OTP here ",
                    style: new TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.deepPurple,
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);
                        AuthResult result =
                            await _auth.signInWithCredential(credential);
                        FirebaseUser user = result.user;
                        if (user != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ));
                        } else {
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
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
      body: SingleChildScrollView(
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
                        border: Border.all(color: Colors.deepPurple,),
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
          final phone = "+" + _phonecode + _phoneController.text.trim();
          loginUser(phone, context);
        },
      ),
    );
  }
}
