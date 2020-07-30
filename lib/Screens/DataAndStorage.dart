import 'package:flutter/material.dart';

class NumberList {
  String number;
  int index;
  NumberList({this.number, this.index});
}

class DataAndStorage extends StatefulWidget {
  @override
  _DataAndStorageState createState() => _DataAndStorageState();
}

List<NumberList> nList = [
  NumberList(
    index: 1,
    number: "Never",
  ),
  NumberList(
    index: 2,
    number: "Only while roaming",
  ),
  NumberList(
    index: 3,
    number: "Only on Mobile Data",
  ),
  NumberList(
    index: 4,
    number: "Always",
  ),
];

class _DataAndStorageState extends State<DataAndStorage> {
  int _currentTimeValue = 3;
  int id = 1;
  String radioItemHolder = 'One';

  bool MobileDataStatus = false;
  bool WifiStatus = false;
  bool RoamingStatus = false;
  bool GifsStatus = false;
  bool VideosStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //  centerTitle : true,
        title: Text(
          'Data and Storage',
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
                    "Disk and Network Usage",
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
                    title: const Text('Storage Usage'),
                    // value: Chatstatus,
                    onTap: () {},
                   
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: ListTile(
                    title: const Text('Data Usage'),
                    // value: Chatstatus,
                    onTap: () {},
                   
                  ),
                ),

                Align(
              alignment: Alignment.centerLeft,
              child: new Container(
                child: new Text(
                    "Automatic Media Download",
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
                    title: const Text('When using Mobile Data'),
                    subtitle: new Text("Photos, Vidoes(10MB), Files(1MB)"),
                    value: MobileDataStatus,
                    onChanged: (bool value) {
                      setState(() {
                        MobileDataStatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: SwitchListTile(
                    title: const Text('When connected on Wi-Fi'),
                    subtitle: new Text("Photos, Vidoes(15MB), Files(3MB)"),
                    value: WifiStatus,
                    onChanged: (bool value) {
                      setState(() {
                        WifiStatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                 Card(
                  elevation: 0.4,
                  child: SwitchListTile(
                    title: const Text('When Roaming'),
                    subtitle: new Text("Photos"),
                    value: RoamingStatus,
                    onChanged: (bool value) {
                      setState(() {
                        RoamingStatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),

                  Card(
                  elevation: 0.4,
                  child: ListTile(
                    title:  Text('Reset Auto-Download Settings', style: new TextStyle(color: Colors.red, fontSize: 17.0)),
                    // value: Chatstatus,
                    onTap: () {},
                   
                  ),
                ),

                 Align(
              alignment: Alignment.centerLeft,
              child: new Container(
                child: new Text(
                    "Auto-play Media",
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
                    title: const Text('Gifs'),
                    value: GifsStatus,
                    onChanged: (bool value) {
                      setState(() {
                        GifsStatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),
                Card(
                  elevation: 0.4,
                  child: SwitchListTile(
                    title: const Text('Videos'),
                    value: VideosStatus,
                    onChanged: (bool value) {
                      setState(() {
                        VideosStatus = value;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                ),

                  Align(
              alignment: Alignment.centerLeft,
              child: new Container(
                child: new Text(
                    "Calls",
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
                    title: const Text('Use less data for Calls'),
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
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                    trailing: new Text("$radioItemHolder",
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
                    title: const Text('Respond with Text'),
                    // value: Chatstatus,
                    onTap: () {},
                   
                  ),
                ),
               
                Padding(padding: EdgeInsets.all(5.0)),
              ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
