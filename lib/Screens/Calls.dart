import 'package:flutter/material.dart';
import 'package:voizit/Models/ChartModel.dart';


class Calls extends StatefulWidget {
  @override
  _CallsState createState() => _CallsState();
}

class _CallsState extends State<Calls> {
 
 @override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
      //  centerTitle : true,
        title: Text('Calls',
         style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold
                ),
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
            )          
         ),        
     ),    
        
      ),
      body: new Container(
         
             child: 
             new Center(
               child: new Text("You haven't made any calls yet.", 
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.grey,
               ),
               )
             )
             


      ),
      
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.phone,
            color: Colors.white, 
            size: 33.0,
            
            ),
            backgroundColor: Colors.purple,
           // foregroundColor: Colors.teal,
            onPressed: (){}
            ),
    );
}


}