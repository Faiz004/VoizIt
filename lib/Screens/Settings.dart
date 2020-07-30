import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voizit/Screens/DataAndStorage.dart';
import 'package:voizit/Screens/NotificationsandSounds.dart';
import 'package:voizit/Screens/PrivacyandSecurity.dart';

class Settings extends StatefulWidget {
  final SharedPreferences prefs;
  Settings({this.prefs});
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final db = Firestore.instance;
  CollectionReference contactsReference;
  DocumentReference profileReference;
  DocumentSnapshot profileSnapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                expandedHeight: 110.0,
                automaticallyImplyLeading: true,
                floating: true,
                pinned: true,
                snap: true,
                forceElevated: true,
                flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    titlePadding:
                        EdgeInsetsDirectional.fromSTEB(50.0, 10.0, 0.0, 6.0),
                    title: new Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.only(top: 14.0)),
                        new Row(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  '${widget.prefs.getString('profilepic')}'),
                            ),
                            new Padding(padding: EdgeInsets.only(left: 8.0)),
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '${widget.prefs.getString('name')}',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                new Padding(padding: EdgeInsets.only(top: 5)),
                                Text(
                                  'Online',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    //fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    background: new Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).accentColor,
                        ],
                      )),
                    )),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      print('Click search');
                    },
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    enabled: true,
                    onSelected: (str) {},
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuItem<String>>[
                      const PopupMenuItem<String>(
                        value: 'Logout',
                        child: Text('Logout'),
                      ),
                    ],
                  )
                ]),
          ];
        },
        body: new Container(
          margin: EdgeInsets.only(left: 10.0),
          child: new ListView(
            children: <Widget>[
              // Padding(padding: EdgeInsets.only(top: 10.0)),
              Align(
                alignment: Alignment.centerLeft,
                child: new Container(
                  child: new Text(
                    "Account",
                    textAlign: TextAlign.start,
                    // textScaleFactor: 0.5,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),

              new Container(
                // height: 130,
                child: Column(children: <Widget>[
                  Card(
                    elevation: 0.4,
                    child: ListTile(
                      // leading:  Icon(Icons.group_add),
                      title: Text(
                        '+' + '${widget.prefs.getString('mobile')}',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      onTap: () {
                        print("Number change tapped");
                      },
                      contentPadding: EdgeInsetsDirectional.only(top: 5.0),
                      subtitle: Text("Tap to change phone number"),
                    ),
                  ),
                  Card(
                    elevation: 0.4,
                    child: ListTile(
                      // leading:  Icon(Icons.group_add),
                      title: Text(
                        '@Faiz_Hashmi',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      onTap: () {
                        print("Username tapped");
                      },
                      contentPadding: EdgeInsetsDirectional.only(top: 5.0),
                      subtitle: Text("Username"),
                    ),
                  ),
                  Card(
                    elevation: 0.4,
                    child: ListTile(
                      // leading:  Icon(Icons.group_add),
                      title: Text(
                        'Bio',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      onTap: () {
                        print("Bio tapped");
                      },

                      contentPadding: EdgeInsetsDirectional.only(top: 5.0),
                      subtitle: Text("Add few words about yourself"),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: new Container(
                      child: new Text(
                        "Settings",
                        textAlign: TextAlign.start,
                        // textScaleFactor: 0.5,
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0.4,
                    child: ListTile(
                      leading: Icon(Icons.notifications_none),
                      title: Text(
                        'Notifications and Sound',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      onTap: () {
                        print("Notifications and Sound tapped");
                        Navigator.of(context).canPop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                NotificationsandSounds()));
                      },
                    ),
                  ),
                  Card(
                    elevation: 0.4,
                    child: ListTile(
                      leading: Icon(Icons.lock_outline),
                      title: Text(
                        'Privacy and Security',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).canPop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PrivacyandSecurity()));
                      },
                    ),
                  ),
                  Card(
                    elevation: 0.4,
                    child: ListTile(
                      leading: Icon(Icons.timelapse),
                      title: Text(
                        'Data and Storage',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                       onTap: () {
                        Navigator.of(context).canPop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DataAndStorage()));
                      },
                    ),
                  ),
                  Card(
                    elevation: 0.4,
                    child: ListTile(
                      leading: Icon(Icons.chat_bubble_outline),
                      title: Text(
                        'Chat Settings',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      onTap: () {
                        print("Chat Settings tapped");
                      },
                    ),
                  ),
                  Card(
                    elevation: 0.4,
                    child: ListTile(
                      leading: Icon(Icons.laptop_chromebook),
                      title: Text(
                        'Devices',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      onTap: () {
                        print("Devices tapped");
                      },
                    ),
                  ),
                  Card(
                    elevation: 0.4,
                    child: ListTile(
                      leading: Icon(Icons.language),
                      title: Text(
                        'Language',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      onTap: () {
                        print("Language tapped");
                      },
                    ),
                  ),
                  Card(
                    elevation: 0.4,
                    child: ListTile(
                      leading: Icon(Icons.help_outline),
                      title: Text(
                        'Help',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      onTap: () {
                        print("Help tapped");
                      },
                    ),
                  ),
                  new Center(
                      child: new Text(
                    "Telegram for Android v5.15.0(1869) arm64-v8a ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      //fontSize: 22.0,
                      color: Colors.grey,
                    ),
                  )),
                  Padding(padding: EdgeInsets.all(5.0)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
