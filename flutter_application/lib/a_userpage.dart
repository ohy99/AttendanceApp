import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'a_splash.dart';

class UserPage extends StatefulWidget  {

  const UserPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => UserState();
}

class UserState extends State<UserPage> {

  final _formKey = GlobalKey<FormState>();
  final name_input_controller = TextEditingController();
  //final name_input_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Saving data'),
      // ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [ 
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: FittedBox(
                
                fit: BoxFit.contain,
                child: Image.asset('assets/happyman.png'),
              ),
            )
          ),
          Expanded(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      
                      mainAxisSize: MainAxisSize.max,
                      //crossAxisAlignment: CrossAxisAlignment.,
                      children: [
                        FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.contain,
                          child: Image.asset('assets/idicon.png'),
                        ),

                        Expanded(
                         child: Container(
                          //height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Colors.deepPurple[400],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                controller: name_input_controller,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: "Please input your ID",
                                  hintStyle: TextStyle(color: Color.fromARGB(120, 255, 255, 255))),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Expanded(
                      //   flex: 1,
                      //   child: FittedBox(
                      //     alignment: Alignment.center,
                      //     fit: BoxFit.contain,
                      //     child: Image.asset('assets/idicon.png'),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.topCenter,
              //margin: EdgeInsets.only(bottom: 50),
              child: OutlinedButton(
                child: Text('Submit'),
                onPressed: () {
                  //Submit entry
                  submit_info();
                },
              )
            ),
          ),
        ],
      ),
    );
  }


  void submit_info() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> data = prefs.getStringList('qrData');
    //0 = company name //1 = class name //2 = uid
    String compName = data[0];
    String className = data[1];
    String uid = data[2];
    
    print("uid " + FirebaseAuth.instance.currentUser.uid);
    
    CollectionReference comCol = FirebaseFirestore.instance.collection('AppDatabase');
    DocumentReference classDoc = comCol.doc(uid);
    CollectionReference classCol = classDoc.collection(className);
    classCol.doc(DateFormat('dd MMMM yyyy').format(DateTime.now())).update({
      name_input_controller.text: FieldValue.serverTimestamp()
    }).then((value) => print('added info'));

    Navigator.popAndPushNamed(context, '/$AppPage.userendpage');

    // classCol.get().then((QuerySnapshot querySnapshot) => {
    //   querySnapshot.docs.add(value)
    // })
    // .get().then((DocumentSnapshot documentSnapshot) => {
    //   if (documentSnapshot.exists) {
    //     print('Document data: ${documentSnapshot.data()}')
    //     documentSnapshot.
    //   } else {
    //     print('Document does not exist on the database')
    //   }
    // });
    
  }
}
