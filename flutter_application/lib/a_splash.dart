//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_application/database_helper.dart';
//import 'package:intl/intl.dart';
import 'my_widget_builder.dart';
import 'dart:math' as math;
import 'a_userpage.dart';
import 'a_scanpage.dart';
import 'a_userendpage.dart';

enum AppPage
{
  splash,
  login,
  userpage,
  userendpage
}
class AttendanceApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance App',
      theme: ThemeData(
        //primaryColor: Colors.deepPurple[400],
        primarySwatch: Colors.deepPurple,
        
        //accentColor: Colors.white,
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.deepPurple[400],
          
        ),
      ),
      home: SplashPage(),
      routes: <String, WidgetBuilder> {
        '/$AppPage.splash' : (BuildContext context) => new SplashPage(),
        '/$AppPage.login' : (BuildContext context) => new ScanPage(),
        '/$AppPage.userpage' : (BuildContext context) => new UserPage(),
        '/$AppPage.userendpage' : (BuildContext context) => new UserEndPage(),
        //'/screen4' : (BuildContext context) => new Screen4()
      },
    );
  }
}

class SplashPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Saving data'),
      // ),
      body: Stack(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [ 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child :ElevatedButton(
              
              style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0)) ),
              child: Text('Enter'),
              onPressed: (){ 
                //do something
                Navigator.pushNamed(context, '/$AppPage.login');
              },
              ),
            ),
            ],
          ),
          MyWidgetBuilder.build_circle_bottomright(200, 200, -50, -100, Color(0xFFC898D8)),
          MyWidgetBuilder.build_circle_bottomright(200, 200, -30, 10, Color(0xFF5EC9DA)),
          MyWidgetBuilder.build_circle_bottomright(150, 150, -75, 75, Color(0xFF7058C5)),

          MyWidgetBuilder.build_circle_topleft(200, 200, -100, 20, Color(0xFFC898D8)),
          MyWidgetBuilder.build_circle_topleft(150, 150, 50, -60, Color(0xFF7058C5)),
          MyWidgetBuilder.build_circle_topleft(200, 200, -50, -50, Color(0xFF5EC9DA)),
          MyWidgetBuilder.build_circle_topright(50, 50, 80, 230, Color(0xF0C898D8)),
          MyWidgetBuilder.build_circle_topright(50, 50, 100, 220, Color(0xF07058C5)),
          Positioned(
            bottom: 10.0,
            left: -30.0,
            child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Image.asset('assets/sitting-8.png', width: 200, height: 200,)
          ),
          ),
          
          
          
          

          
        ],
      ),
    );
  }
  
}
