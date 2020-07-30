import 'package:flutter/material.dart';
import 'package:voizit/Models/ChartModel.dart';


class NewPodcast extends StatefulWidget {
  @override
  _NewPodcastState createState() => _NewPodcastState();
}

class _NewPodcastState extends State<NewPodcast> {
 
 @override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
      //  centerTitle : true,
        title: Text('New Podcast',
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

      actions: <Widget>[
           IconButton(
                  icon: Icon(Icons.check),
                  iconSize: 35.0,
                  onPressed: () {
                    print('Click search');
                  },
                ),
                ] 
        
      ),
      
      body: new Container(
        child: new Column(
        children: <Widget>[
          new Padding(padding: EdgeInsets.all(10.0)),

        new Row(
          children: <Widget>[
            new Padding(padding: EdgeInsets.all(10.0)),
            CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage('https://cdn0.iconfinder.com/data/icons/user-avatar/32/user_avatar_add_man_insert_character-512.png'),
              ),

            new Padding(padding: EdgeInsets.all(10.0)),

              new Expanded(
               // width: 240.0,
               child: TextField(
                style: TextStyle(
                fontSize: 18.0,
                  height: 2.0,
                ),
              decoration: InputDecoration(
                hintText: 'Podcast Name',
                contentPadding: new EdgeInsets.all(10.0), 
                
              ),
            ),
    
              )

          ],
        ),

        new Container(
          child: new Column(
            children: <Widget>[

              TextField(
                style: TextStyle(
                  fontSize: 18.0,
                  height: 2.0,
                ),
              decoration: InputDecoration(
                hintText: ' Description',
                contentPadding: new EdgeInsets.all(10.0), 
                
              ),
            ),

             new Padding(padding: EdgeInsets.all(07.0)),

            
            new Text("You can provide an optional description for your Podcast.", 
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
               ),
               )
            ],
          )
              )

          ],
        )
      ),
      
    );
}


}