
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voizit/Screens/Calls.dart';
import 'package:voizit/Screens/Contacts.dart';
import 'package:voizit/Screens/HomeScreen.dart';
import 'package:voizit/Screens/NewGroup.dart';
import 'package:voizit/Screens/NewPodcast.dart';
import 'package:voizit/Screens/NewSecretChat.dart';
import 'package:voizit/Screens/RegistrationPage.dart';
import 'package:voizit/Screens/Settings.dart';

import 'NewMessage.dart';


class DrawerScreen extends StatefulWidget {
  final SharedPreferences prefs;
  DrawerScreen({this.prefs});
  @override
  _DrawerScreenState createState() => _DrawerScreenState();

}

class _DrawerScreenState extends State<DrawerScreen> {
  @override

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          
          UserAccountsDrawerHeader(
              accountName: Text('${widget.prefs.getString('name')}', 
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold
              ),
              ),
              
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage( '${widget.prefs.getString('profilepic')}'),
              ),
              accountEmail: Text( '+'+'${widget.prefs.getString('mobile')}'),
              decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
                end: Alignment.bottomRight,
               colors: [
             Theme.of(context).primaryColor,
             Theme.of(context).accentColor,  
          ],
            )          
         ),
              ),
          DrawerListTile(
            iconData: Icons.group,
            title: 'New Audio Group',
            onTilePressed: () {
              Navigator.of(context).canPop();
              Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => NewGroup(prefs: widget.prefs,)));
                    },
          ),

          DrawerListTile(
            iconData: Icons.message,
            title: 'New Message',
            onTilePressed: () {
              Navigator.of(context).canPop();
              Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => NewMessage(prefs: widget.prefs,)));
                    },
          ),

          DrawerListTile(
            iconData: Icons.lock,
            title: 'New Secret Voice Chat',
            onTilePressed: () {
              Navigator.of(context).canPop();
              Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => NewSecretChat()));
            },
          ),
          DrawerListTile(
            iconData: Icons.notifications,
            title: 'Create Podcast',
            onTilePressed: () {
              Navigator.of(context).canPop();
              Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => NewPodcast()));
            },
          ),
          DrawerListTile(
            iconData: Icons.contacts,
            title: 'Contacts',
            
            onTilePressed: () {
              Navigator.of(context).canPop();
              Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Contacts(prefs: widget.prefs)));
            },
          ),
          
          DrawerListTile(
            iconData: Icons.phone,
            title: 'Calls',
              onTilePressed: () {
              Navigator.of(context).canPop();
              Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Calls()));
            },
              ),
           
          DrawerListTile(
            iconData: Icons.settings,
            title: 'Settings',
            onTilePressed: () {
              Navigator.of(context).canPop();
              Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Settings(prefs: widget.prefs,)));
            },
          ),

          DrawerListTile(
            iconData: Icons.arrow_back,
            title: 'Logout',
            onTilePressed: () {
                            FirebaseAuth.instance.signOut().then((response) {
                              widget.prefs.remove('is_verified');
                              widget.prefs.remove('mobile');
                              widget.prefs.remove('userid');
                              widget.prefs.remove('name');
                              widget.prefs.remove('profilepic');
                              Navigator.of(context).canPop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RegistrationPage(prefs: widget.prefs),
                                ),
                              );
                            });
                          },
          ),
          Divider(),
           DrawerListTile(
            iconData: Icons.person_add,
            title: 'Invite Friends',
            onTilePressed: () {},
          ),
          DrawerListTile(
            iconData: Icons.help_outline,
            title: 'VoizIt FAQs',
            onTilePressed: () {},
          )
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final VoidCallback onTilePressed;

  const DrawerListTile({Key key, this.iconData, this.title, this.onTilePressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTilePressed,
      dense: true,
      leading: Icon(iconData),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}
