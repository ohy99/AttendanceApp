//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_application/database_helper.dart';
import 'package:intl/intl.dart';


class MileageApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mileage Generator App',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: LogMileagePage(title: 'Welcome'),
    );
  }
}

class LogMileagePage extends StatefulWidget {
  LogMileagePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LogMileageState createState() => _LogMileageState();
  
}
enum AddTripAction { cancel, addtrip }
class _LogMileageState extends State<LogMileagePage> {

  final _formKey = GlobalKey<FormState>();
  final _vehiclePlateController = TextEditingController();
  final _dateController = TextEditingController();
  final _startDTController = TextEditingController();
  final _endDTController = TextEditingController();
  final _startMileageController = TextEditingController();
  final _endMileageController = TextEditingController();
  //DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null)
      setState(() {
        //selectedDate = picked;
        controller.text = DateFormat('ddMMyy').format(picked);
      });
  }

    Future<Null> _selectTime(BuildContext context, TextEditingController controller) async {
      final TimeOfDay picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
        );
    if (picked != null)
      setState(() {
        //selectedDate = picked;
        controller.text = picked.hour.toString() + ":" + picked.minute.toString();
      });
  }

  Future<void> _addLogMileage() async {
    switch (await showDialog<AddTripAction>(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: SimpleDialog(
            title: const Text('Add Trip'),
            children: <Widget>[
              Column( // VEH PLATE //
                        children: [
                        Text('Vehicle Plate'),
                        TextFormField(
                          controller: _vehiclePlateController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required field';
                            }
                            return null;
                          },
                        ),],
                      ),
                Column( // DATE PICKER //
                  children: [
                      Text('Date'),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dateController,
                              enabled: false,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Required field';
                                }
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: ()=>_selectDate(context, _dateController), child: Text('Select Date'))
                          ),
                        ]
                      ),
                    ],
                ),
                Expanded(
                  child:Row(
                  children: [
                    Column(
                      children: [
                        Text('Start Time'),
                        ListTile(
                          title: TextFormField(
                                controller: _startDTController,
                                enabled: false,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Required field';
                                  }
                                  return null;
                                },
                              ),
                          trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: ()=>_selectTime(context, _startDTController),
                          ),
                        ),
                      ],
                    ),
                    Column( // END TIME PICKER //
                      children: [
                          Text('End Time'),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _endDTController,
                                  enabled: false,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Required field';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: ()=>_selectTime(context, _endDTController), child: Text('Select Time'))
                              ),
                            ]
                          ),
                        ],
                    ),
                  ],
                  
                ),
                 
                
              ),
              Row(
                  children: [
                    Expanded(
                      child: Column( // START MILEAGE //
                        children: [
                            Text('Start Odometer'),
                            TextFormField(
                              controller: _startMileageController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Required field';
                                }
                                return null;
                              },
                            ),
                          ],
                      ),
                    ),
                    Expanded(
                      child:  Column( // END MILEAGE //
                        children: [
                            Text('End Odometer'),
                            TextFormField(
                              controller: _endMileageController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Required field';
                                }
                                return null;
                              },
                            ),
                          ],
                      ),
                    ),
                  ],
              ),
          
              Row(
                children: [
                  Expanded(

                    child: SimpleDialogOption(
                      onPressed: () { Navigator.pop(context, AddTripAction.cancel); },
                      child: const Text(
                        'Cancel', 
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.lightBlue),
                        ),
                    ),
                  ), 
                  Expanded(
                    child: SimpleDialogOption(
                      onPressed: () { Navigator.pop(context, AddTripAction.addtrip); },
                      child: const Text(
                        'Add', 
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.lightBlue),
                        ),
                    )
                  ),
                ],
              ),
            ],
          )
        );
      }
    )) {
      case AddTripAction.cancel:
        // Let's go.
        // ...
      break;
      case AddTripAction.addtrip:
        // ...
        if (_formKey.currentState.validate()) {
          // Process data.
          String vplate = _vehiclePlateController.value.text;
          print(vplate);
        }
      break;
      default:
      
      
    }

    
    _vehiclePlateController.clear();
    _startDTController.clear();
    _endDTController.clear();
    _startMileageController .clear();
    _endMileageController.clear();
  }
  void _onLogMileageButtonPressed() 
  {
      _addLogMileage();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              //child: const Card(child: Text('Entry A')),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Driven a detail?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton( onPressed: _onLogMileageButtonPressed,
                      //tooltip: 'Add an entry',
                      child: Text('Log Mileage'),
                        )
                      ),
                    ],
                  ),
                ),
            ),
            MileageCardListWidget(),
          ],
        ),
      ),
    );
  }
}

class MileageCardListWidget extends StatefulWidget
{
  const MileageCardListWidget({
    Key key,
  }) : super(key: key);

  @override
  MileageCardListState createState() => MileageCardListState();

}

class MileageCardListState extends State<MileageCardListWidget>{

  // @override
  // void initState()
  // {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) { MyTripStorage.instance.loadTrips(); });
  // }
  Widget _generateCard(TripEntry tripEntry)
  {
    DateTime startDT = DateTime.parse(tripEntry.startTime);
    DateTime endDT = DateTime.parse(tripEntry.endTime);
    String dateString = DateFormat('dd MMM yyyy').format(startDT);
    String startTimeString = DateFormat('Hm').format(startDT);
    String endTimeString = DateFormat('Hm').format(endDT);
    String diffMileageString = (tripEntry.endMileage - tripEntry.startMileage).toString();

    return  Card(
          
          child: Container (
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            child: Row(
              
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    
                    child: Card (child: Column(
                        children: [Text(dateString), Text(startTimeString + '-' + endTimeString) ],
                      )
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      
                      //display vehicle and mileage
                      children: [ Card (child: Text(
                        tripEntry.vehNumber.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                        textAlign: TextAlign.center,
                        )), Text(diffMileageString,textAlign: TextAlign.end)],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                    //display from-to mileage
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                     children: [ Text(tripEntry.startMileage.toString()), Text(tripEntry.endMileage.toString()), Text(tripEntry.getVehicleType()) ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      //padding: EdgeInsets.symmetric(horizontal: 5.0),
                      fit: BoxFit.fitWidth,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.0),
                          child: ElevatedButton(
                            child: Icon(Icons.edit),
                            onPressed: ()=>{},
                        ),
                      ),
                      
                  ),
                    
                  ),
              ],
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder (
        future: DatabaseHelper.instance.queryAllTrips(),
        builder: (context, snapshot){
          print(snapshot.hasData);
          if(snapshot.hasData)
          {
            List<TripEntry> tripsList = snapshot.data;
            return Column(
              children: List<Widget>.generate(10, (int index) {
                      return _generateCard(tripsList[index]); 
                      }),
            );
          }
          else if (snapshot.hasError){
            throw snapshot.error;
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
      });
      
  }

}