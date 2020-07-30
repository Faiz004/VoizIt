import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voizit/Models/call.dart';
import 'package:voizit/Models/call_methods.dart';
import 'package:voizit/Models/user.dart';
import 'package:voizit/Screens/CallScreens/CallScreens.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({User from, User to, context}) async {
    Call call = Call(
      callerId: from.mobile,
      callerName: from.name,
      callerPic: from.profilepic,
      receiverId: to.mobile,
      receiverName: to.name,
      receiverPic: to.profilepic,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}