import 'package:flutter/material.dart';
import 'package:flutter_application/a_splash.dart';
import 'a_userpage.dart';

import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanPage extends StatefulWidget  {

  const ScanPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => QRState();
}

class QRState extends State<ScanPage> {

  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool _ff_initialized = false;
  bool _ff_error = false;
  bool _scan_success = false;
  bool _anony_login = false;


  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _ff_initialized = true;

        FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
          if (user == null) {
            print('User is currently signed out!');
          } else {
            print('User is signed in!');
          }
        });
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _ff_error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    
    super.initState();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Align(
            alignment: Alignment(0,0),
            child: 
              _buildQrView(context),
            
          ),

        ],
      ),
      
      bottomNavigationBar: BottomAppBar(
        
          child: (_ff_error || (!_ff_initialized && _scan_success)) ? Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  _ff_error ? 'Error in initialising' : 'Loading',
                  style: TextStyle(color: Colors.white)
                ),
              ),
              
              Spacer(),

              _ff_error ? 
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: TextButton(
                  onPressed: () {
                    //exit app
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  
                  child: Text(
                    'Exit',
                    style: TextStyle(color: Colors.white70),
                    )
                )
              )
              : SizedBox(
                height: 50,
              )
            ],
          )
          : null
        )
    );
  }

    Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.deepPurple[400],
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea,
          overlayColor: Color.fromARGB(240, 255, 255, 255)),
    );
  }
  
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        print(describeEnum(result.format) + ' ' + result.code);

        String resCode = result.code;
        resCode = resCode.replaceAll(RegExp('\\n| '), '');//replace all linebreaks and space to nothing
        //print("after replace " + resCode);
        RegExp exp = RegExp('\\[\\w+\\]|\\w+');
        Iterable<String> res = exp.allMatches(resCode).map((e) => e.group(0));
        List<String> list = [];
        print("res len " + res.length.toString());
        for(int i = 0; i < res.length; ++i)
        {
          String s = res.elementAt(i).replaceAll(RegExp('\\[|\\]'), '');
          print(i.toString() + ": " + s);
          list.add(s);
        }

        if (res.length != 3)
        {
          print('Invalid QR Code');
          return;
        }
        //0 = company name //1 = class name //2 = uid
        String companyName = res.elementAt(0);
        String className = res.elementAt(1);
        String uid = res.elementAt(2); 

        _scan_success = true;
        //attempt to login

        if ((_scan_success && _ff_initialized) == false)
        {
          //waiting to load
          print('stil loading flutterfire');
          return;
        }

        if (_anony_login )
        {
          print('logging in please wait');
          return;
        }
        anonymous_login(list);
        _anony_login = true;
        
      });
    });
  }

  void anonymous_login(List<String> data) async
  {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('qrData', data);

    //enter info page
    controller.stopCamera();
    Navigator.pushReplacementNamed(context, '/$AppPage.userpage');
  }


  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
