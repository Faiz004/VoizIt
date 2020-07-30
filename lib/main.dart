
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voizit/Screens/HomeScreen.dart';
import 'package:voizit/Screens/Profile.dart';
import 'package:voizit/Screens/RegistrationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voizit/Screens/SearchScreen.dart';
import 'package:voizit/provider/image_upload_provider.dart';
import 'package:voizit/provider/user_provider.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(prefs: prefs));
  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  MyApp({this.prefs});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider(),) 
      ],
          child: MaterialApp(
        title: 'VoizIt',
        theme: ThemeData(
          primaryColor: Colors.purple,
          accentColor: Colors.teal,
          backgroundColor: Colors.white
        ),
        debugShowCheckedModeBanner: false,

             home: _decideMainPage(),

      ),
    );
  }

  _decideMainPage() {
    if (prefs.getBool('is_verified') != null) {
      if (prefs.getBool('is_verified')) {
        return HomeScreen(prefs: prefs);
        // return RegistrationPage(prefs: prefs);
      } else {
        return RegistrationPage(prefs: prefs);
      }
    } else {
      return RegistrationPage(prefs: prefs);
    }
  }
}

