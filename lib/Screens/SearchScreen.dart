import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:gradient_app_bar/gradient_app_bar.dart";
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voizit/Models/user.dart';
import 'package:voizit/Widgets/CustomTile.dart';

import 'ChatPage.dart';

class SearchScreen extends StatefulWidget {
  final SharedPreferences prefs;
  SearchScreen({this.prefs});
  
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = Firestore.instance;
   CollectionReference contactsReference;
  DocumentReference profileReference;
  DocumentSnapshot profileSnapshot;

  List<User> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

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

    getCurrentUser().then((FirebaseUser user) {
      fetchAllUsers(user).then((List<User> list) {
        setState(() {
          userList = list;
        });
      });
    });


  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

    Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await db.collection("Users").getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
     
    }
    return userList;
  }


  searchAppBar(BuildContext context) {
    return GradientAppBar(
      backgroundColorStart: Theme.of(context).primaryColor,
      backgroundColorEnd: Theme.of(context).accentColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: Colors.black,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 30,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        : userList.where((User user) {
            String _getUsername = user.name.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool matchesUsername = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);

            return (matchesUsername || matchesName);

            // (User user) => (user.username.toLowerCase().contains(query.toLowerCase()) ||
            //     (user.name.toLowerCase().contains(query.toLowerCase()))),
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        User searchedUser = User(
            mobile: suggestionList[index].mobile,
            profilepic: suggestionList[index].profilepic,
            name: suggestionList[index].name);

        return CustomTile(
          mini: false,
          onTap: () async {
              QuerySnapshot result = await db
                  .collection('Chats')
                  .where('contact1', isEqualTo: widget.prefs.getString('userid'))
                  .where('contact2', isEqualTo: searchedUser.mobile)
                  .getDocuments();
              List<DocumentSnapshot> documents = result.documents;
              if (documents.length == 0) {
                result = await db
                    .collection('Chats')
                    .where('contact2', isEqualTo: widget.prefs.getString('userid'))
                    .where('contact1', isEqualTo: searchedUser.mobile)
                    .getDocuments();
                documents = result.documents;
                if (documents.length == 0) {
                  await db.collection('Chats').add({
                    'contact1': widget.prefs.getString('userid'),
                    'contact2': searchedUser.mobile
                  }).then((documentReference) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          prefs: widget.prefs,
                          chatId: documentReference.documentID,
                          title: searchedUser.name,
                          reciever: searchedUser,
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
                        title: searchedUser.mobile,
                        reciever: searchedUser,
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
                      title: searchedUser.mobile,
                      reciever: searchedUser,
                    ),
                  ),
                );
              }
            },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilepic),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchedUser.name,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text( "+" +
            searchedUser.mobile,
            style: TextStyle(color: Colors.blueGrey),
          ),
           trailing: Icon(Icons.chevron_right),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(query),
      ),
    );
  }
}


//  return ListView.builder(
//       itemCount: suggestionList.length,
//       itemBuilder: ((context, index) {
//         User searchedUser = User(
//             uid: suggestionList[index].uid,
//             profilePhoto: suggestionList[index].profilePhoto,
//             name: suggestionList[index].name,
//             username: suggestionList[index].username);

//         return CustomTile(
//           mini: false,
//           onTap: () {;
//           },
//           leading: CircleAvatar(
//             backgroundImage: NetworkImage(searchedUser.profilePhoto),
//             backgroundColor: Colors.grey,
//           ),
//           title: Text(
//             searchedUser.username,
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           subtitle: Text(
//             searchedUser.name,
//             style: TextStyle(color: UniversalVariables.greyColor),
//           ),
//         );
//       }),
//     );