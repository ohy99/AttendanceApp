import 'package:flutter/material.dart';
import 'package:flutter_application/a_splash.dart';

class UserEndPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        
        body: GestureDetector(
          onTap: () {
            //go back splash
            Navigator.pop(context);
          },
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('HAVE A GOOD DAY!'),
            ),
          ],
        ),
        ),
        
      );
  }


}
