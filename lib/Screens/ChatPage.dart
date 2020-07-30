import 'dart:math';
import 'dart:io' as io;
import 'dart:math';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voizit/Models/user.dart';
import 'package:voizit/Screens/CallScreens/VoiceCall.dart';
import 'package:voizit/provider/image_upload_provider.dart';
import 'package:voizit/utils/call_utils.dart';
import 'package:voizit/utils/permissions.dart';
import 'GalleryPage.dart';

class ChatPage extends StatefulWidget {
  final SharedPreferences prefs;
  final User reciever;
  User sender;

  final String chatId;
  final String title;
  final String number;
  ChatPage({this.prefs, this.chatId, this.title, this.number, this.reciever});
  @override
  ChatPageState createState() {
    return new ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
  Recording _recording = new Recording();
  bool _isRecording = false;
  Random random = new Random();
  TextEditingController _controller = new TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = Firestore.instance;
  CollectionReference chatReference;
  final TextEditingController _textController = new TextEditingController();
  bool _isWritting = false;

  String _currentUserId;
  User sender;

  @override
  void initState() {
    super.initState();
    chatReference =
        db.collection("Chats").document(widget.chatId).collection('messages');

    setState(() {
      // print(user.uid);
      sender = User(
        mobile: widget.prefs.getString('mobile'),
        name: widget.prefs.getString('name'),
        profilepic: widget.prefs.getString('profilepic'),
      );
    });
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }



  List<Widget> generateSenderLayout(DocumentSnapshot documentSnapshot) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    child: new CircleAvatar(
                      backgroundImage:
                          new NetworkImage(documentSnapshot.data['profilepic']),
                    )),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(documentSnapshot.data['sender_name'],
                        style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: documentSnapshot.data['imageurl'] != ''
                          ? InkWell(
                              child: new Container(
                                child: Image.network(
                                  documentSnapshot.data['imageurl'],
                                  fit: BoxFit.fitWidth,
                                ),
                                height: 150,
                                width: 150.0,
                                color: Color.fromRGBO(0, 0, 0, 0.2),
                                padding: EdgeInsets.all(5),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => GalleryPage(
                                      imagePath:
                                          documentSnapshot.data['imageurl'],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * .6),
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).accentColor,
                                  ],
                                ),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                              ),
                              child: new Text(documentSnapshot.data['text'],
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> generateReceiverLayout(DocumentSnapshot documentSnapshot) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(documentSnapshot.data['sender_name'],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: documentSnapshot.data['imageurl'] != ''
                  ? InkWell(
                      child: new Container(
                        child: Image.network(
                          documentSnapshot.data['imageurl'],
                          fit: BoxFit.fitWidth,
                        ),
                        height: 150,
                        width: 150.0,
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                        padding: EdgeInsets.all(5),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => GalleryPage(
                              imagePath: documentSnapshot.data['imageurl'],
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .6),
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          topLeft: Radius.circular(25),
                          // bottomRight: Radius.circular(25),
                        ),
                        border: Border.all(width: 0.8, color: Colors.blueGrey),
                      ),
                      child: new Text(documentSnapshot.data['text'],
                          style: TextStyle(
                            color: Colors.black,
                          )),
                    ),
            ),
          ],
        ),
      ),
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: new CircleAvatar(
                backgroundImage:
                    new NetworkImage(documentSnapshot.data['profilepic']),
              )),
        ],
      ),
    ];
  }

  generateMessages(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map<Widget>((doc) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: new Row(
                children:
                    doc.data['sender_id'] != widget.prefs.getString('userid')
                        ? generateReceiverLayout(doc)
                        : generateSenderLayout(doc),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Row(
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
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
            onPressed: () {
              Navigator.of(context).canPop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => VoiceCall(
                      prefs: widget.prefs, reciever: widget.reciever)));
            },
            icon: Icon(Icons.phone),
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.video_call),
            color: Colors.white,
            onPressed: () async =>
                await Permissions.cameraAndMicrophonePermissionsGranted()
                    ? CallUtils.dial(
                        from: sender, to: widget.reciever, context: context)
                    : {},
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
            color: Colors.white,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: new Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream:
                  chatReference.orderBy('time', descending: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return new Text("No Chat");
                return Expanded(
                  child: new ListView(
                    reverse: true,
                    children: generateMessages(snapshot),
                  ),
                );
              },
            ),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
            new Builder(builder: (BuildContext context) {
              return new Container(width: 0.0, height: 0.0);
            })
          ],
        ),
      ),
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isWritting ? () => _sendText(_textController.text) : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isWritting
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Container(
                // margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(
                      Icons.perm_media,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () async {
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      int timestamp = new DateTime.now().millisecondsSinceEpoch;
                      StorageReference storageReference = FirebaseStorage
                          .instance
                          .ref()
                          .child('chats/img_' + timestamp.toString() + '.jpg');
                      StorageUploadTask uploadTask =
                          storageReference.putFile(image);
                      await uploadTask.onComplete;
                      String fileUrl = await storageReference.getDownloadURL();
                      _sendImage(messageText: null, imageUrl: fileUrl);
                    }),
              ),
              new Flexible(
                child: new TextField(
                  decoration: InputDecoration(
                    hintText: "Press & Hold to Record..",
                    hintStyle: TextStyle(
                      color: Colors.blueGrey,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  readOnly: true,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle),
                child: InkWell(
                  child: Icon(
                    Icons.keyboard_voice,
                    color: Colors.white,
                  ),
                  onLongPress: () {
                    setState(() {});
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle),
                child: InkWell(
                  child: Icon(
                    Icons.keyboard_voice,
                    color: Colors.white,
                  ),
                  onLongPress: () {
                    setState(() {});
                  },
                ),
              )
            ],
          ),
        ));
  }

  Future<Null> _sendText(String text) async {
    _textController.clear();
    chatReference.add({
      'text': text,
      'sender_id': widget.prefs.getString('userid'),
      'sender_name': widget.prefs.getString('name'),
      'profilepic': widget.prefs.getString('profilepic'),
      'imageurl': '',
      'time': FieldValue.serverTimestamp(),
    }).then((documentReference) {
      setState(() {
        _isWritting = false;
      });
    }).catchError((e) {});
  }

  void _sendImage({String messageText, String imageUrl}) {
    chatReference.add({
      'text': messageText,
      'sender_id': widget.prefs.getString('userid'),
      'sender_name': widget.prefs.getString('name'),
      'profilepic': widget.prefs.getString('profilepic'),
      'imageurl': imageUrl,
      'time': FieldValue.serverTimestamp(),
    });
  }

  
}
