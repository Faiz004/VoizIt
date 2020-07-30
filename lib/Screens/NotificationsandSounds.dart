import 'package:flutter/material.dart';

class NumberList {
  String number;
  int index;
  NumberList({this.number, this.index});
}

class NotificationsandSounds extends StatefulWidget {
  @override
  _NotificationsandSoundsState createState() => _NotificationsandSoundsState();
}

List<NumberList> nList = [
  NumberList(
    index: 1,
    number: "Disabled",
  ),
  NumberList(
    index: 2,
    number: "Default",
  ),
  NumberList(
    index: 3,
    number: "Short",
  ),
  NumberList(
    index: 4,
    number: "Long",
  ),
  NumberList(
    index: 5,
    number: "Only if Silent",
  ),
];

class _NotificationsandSoundsState extends State<NotificationsandSounds> {
  int _currentTimeValue = 3;
  int id = 1;
  String radioItemHolder = 'One';

  bool Chatstatus = false;
  bool Grouptatus = false;
  bool Podcastsstatus = false;
  bool Enabledstatus = false;
  bool Mutedchatsstatus = false;
  bool Unreadmsgstatus = false;
  bool Soundstatus = false;
  bool Vibratestatus = false;
  bool Previewstatus = false;
  bool Chatsoundsstatus = false;
  bool Impstatus = false;
  bool Contactsjoinedstatus = false;
  bool Pinnedmsgstatus = false;
  bool Keepalivestatus = false;
  bool Backgroundstatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //  centerTitle : true,
        title: Text(
          'Notifications and Sounds',
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
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
      body: new Container(
        margin: EdgeInsets.only(left: 10.0),
        child: new ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 13.0)),
            Align(
              alignment: Alignment.centerLeft,
              child: new Container(
                child: new Text(
                  "Notifications for chats",
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
                  child: SwitchListTile(
                    title: Text(
                      'Private Chats',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                    value: Chatstatus,
                    subtitle: Text(
                      'Tab to Change',
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        Chatstatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: SwitchListTile(
                    title: Text(
                      'Groups',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                    value: Grouptatus,
                    subtitle: Text(
                      'Tab to Change',
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        Grouptatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: SwitchListTile(
                    title: Text(
                      'Podcasts',
                      style: new TextStyle(fontSize: 15.0),
                    ),
                    value: Podcastsstatus,
                    subtitle: Text(
                      'Tab to Change',
                    ),
                    onChanged: (bool value) {
                      setState(() {
                        Podcastsstatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: new Container(
                    child: new Text(
                      "Voice calls",
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
                    title: const Text('Vibrate'),
                    // value: Chatstatus,
                    onTap: () {
                      return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Vibrate',style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
                            content: new Container(
                              height: 300.0,
                              child: new Column(
                                children: nList
                                    .map((data) => RadioListTile(
                                          title: Text("${data.number}"),
                                          groupValue: id,
                                          value: data.index,
                                          onChanged: (val) {
                                            setState(() {
                                              radioItemHolder = data.number;
                                              id = data.index;
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text('CANCEL'),
                                onPressed: () {
                                  //Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                    trailing: new Text("Default",
                    style: new TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,),
                      ),
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: ListTile(
                    title: const Text('Vibrate'),
                    // value: Chatstatus,
                    onTap: () {
                      return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Vibrate',style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
                            content: new Container(
                              height: 300.0,
                              child: new Column(
                                children: nList
                                    .map((data) => RadioListTile(
                                          title: Text("${data.number}"),
                                          groupValue: id,
                                          value: data.index,
                                          onChanged: (val) {
                                            setState(() {
                                              radioItemHolder = data.number;
                                              id = data.index;
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text('CANCEL'),
                                onPressed: () {
                                  //Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                    trailing: new Text("Default",
                    style: new TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,),
                      ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: new Container(
                    child: new Text(
                      "Badge Counter",
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
                  child: SwitchListTile(
                    title: const Text('Enabled'),
                    value: Enabledstatus,
                    onChanged: (bool value) {
                      setState(() {
                        Enabledstatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: SwitchListTile(
                    title: const Text('Include Muted Chats'),
                    value: Mutedchatsstatus,
                    onChanged: (bool value) {
                      setState(() {
                        Mutedchatsstatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: SwitchListTile(
                    title: const Text('Count Unread Messages'),
                    value: Unreadmsgstatus,
                    onChanged: (bool value) {
                      setState(() {
                        Unreadmsgstatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: new Container(
                    child: new Text(
                      "In-app Notifications",
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
                  child: SwitchListTile(
                    title: const Text('In-App Sounds'),
                    value: Soundstatus,
                    onChanged: (bool value) {
                      setState(() {
                        Soundstatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: SwitchListTile(
                    title: const Text('In-App Vibrate'),
                    value: Vibratestatus,
                    onChanged: (bool value) {
                      setState(() {
                        Vibratestatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: SwitchListTile(
                    title: const Text('In-App Preview'),
                    value: Previewstatus,
                    onChanged: (bool value) {
                      setState(() {
                        Previewstatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: SwitchListTile(
                    title: const Text('In-Chat Sounds'),
                    value: Chatsoundsstatus,
                    onChanged: (bool value) {
                      setState(() {
                        Chatsoundsstatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: SwitchListTile(
                    title: const Text('Importance'),
                    value: Impstatus,
                    onChanged: (bool value) {
                      setState(() {
                        Impstatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: new Container(
                    child: new Text(
                      "Events",
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
                  child: SwitchListTile(
                    title: const Text('Contacts Joined Telegram'),
                    value: Contactsjoinedstatus,
                    onChanged: (bool value) {
                      setState(() {
                        Contactsjoinedstatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: SwitchListTile(
                    title: const Text('Pinned Messages'),
                    value: Pinnedmsgstatus,
                    onChanged: (bool value) {
                      setState(() {
                        Pinnedmsgstatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: new Container(
                    child: new Text(
                      "Other",
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
                  child: SwitchListTile(
                    title: const Text('Keep-Alive Service'),
                    subtitle: new Text(
                        "Relaunch app when shut down. Enable for reliable notifications."),
                    value: Keepalivestatus,
                    onChanged: (bool value) {
                      setState(() {
                        Keepalivestatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: SwitchListTile(
                    title: const Text('Background Connection'),
                    subtitle: Text(
                        "Keep a low impact background connection to Voizit for reliable notifications."),
                    value: Backgroundstatus,
                    onChanged: (bool value) {
                      setState(() {
                        Backgroundstatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: SwitchListTile(
                    title: const Text('Repeat Notifications'),
                    value: Grouptatus,
                    onChanged: (bool value) {
                      setState(() {
                        Grouptatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: new Container(
                    child: new Text(
                      "Reset",
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
                    title: const Text('Reset All Notifications'),
                    // value: Grouptatus,
                    subtitle: Text(
                        'Undo all custom notifications settings for all your contacts,groups and podcasts.'),
                    onTap: () {
                      return showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Reset all notifications',
                              style: new TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                                'Are you sure you want to reset all notification settings to default?'),
                            actions: <Widget>[
                              FlatButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  //Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text(
                                  'Reset',
                                  style: new TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  // Navigator.of(context)
                                  //     .pop(ConfirmAction.ACCEPT);
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(padding: EdgeInsets.all(5.0)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
