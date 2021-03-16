// needed for Directory()
import 'dart:io';
// needed for join()
import 'package:path/path.dart';
// needed for SQL database operations
import 'package:sqflite/sqflite.dart';
// needed for getApplicationDocumentsDirectory()
import 'package:path_provider/path_provider.dart';

// database table and column names
final String trips = 'trips';
final String columnId = '_id';
final String columnST = '_startTime';
final String columnET = '_endTime';
final String columnVehNO = '_vehNumber';
final String columnSM = '_startMileage';
final String columnEM = '_endMileage';


// data model class
class TripEntry {

  int id;
  String startTime;//e.g 20200503T113000 aka 03 may 2020 at 11:30:00
  String endTime;
  int vehNumber;
  int startMileage;
  int endMileage;

  TripEntry();

  bool isNumberWithinRange(int low, int high, int n) //inclusive
  {
    return (n >= low && n <= high);
  }
  String getVehicleType()
  {
    if (isNumberWithinRange(35000, 35999, vehNumber)) //35xxx 
      return 'Jeep';
    if (isNumberWithinRange(32000, 32999, vehNumber)) //32xxx
      return 'Landrover';
    if (isNumberWithinRange(59000, 59999, vehNumber)) //59xxx
      return 'MB290';
    if (isNumberWithinRange(34000, 34999, vehNumber)) //34xxx
      return 'OUV';
    if (isNumberWithinRange(41000, 41999, vehNumber)) //41xxx
      return 'GPCar';
    return 'Special';
  }

  // convenience constructor to create a Word object
  TripEntry.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    startTime = map[columnST];
    endTime = map[columnET];
    vehNumber = map[columnVehNO];
    startMileage = map[columnSM];
    endMileage = map[columnEM];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnST: startTime,
      columnET: endTime,
      columnVehNO: vehNumber,
      columnSM: startMileage,
      columnEM: endMileage
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "trips_database.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database, can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $trips (
            $columnId INTEGER PRIMARY KEY,
            $columnST TEXT NOT NULL,
            $columnET TEXT NOT NULL,
            $columnVehNO INTEGER NOT NULL,
            $columnSM INTEGER NOT NULL,
            $columnEM INTEGER NOT NULL
          )
          ''');
  }

  // Database helper methods:

  Future<int> insert(TripEntry t) async {
    Database db = await database;
    int id = await db.insert(trips, t.toMap());
    return id;
  }

  // Future<TripEntry> queryWord(int id) async {
  //   Database db = await database;
  //   List<Map> maps = await db.query(trips,
  //       columns: [columnId, columnWord, columnFrequency],
  //       where: '$columnId = ?',
  //       whereArgs: [id]);
  //   if (maps.length > 0) {
  //     return TripEntry.fromMap(maps.first);
  //   }
  //   return null;
  // }

  Future<List<TripEntry>> queryAllTrips() async {
    Database db = await database;
    List<Map> maps = await db.query(trips);
    //print('quryalltrips' + maps.length.toString());
    if (maps.length > 0) {
      List<TripEntry> t = [];
      maps.forEach((map) => t.add(TripEntry.fromMap(map)));
      return t;
    }
    return null;
  }

  Future<int> deleteTrip(int id) async {
    Database db = await database;
    return await db.delete(trips, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(TripEntry t) async {
    Database db = await database;
    return await db.update(trips, t.toMap(),
        where: '$columnId = ?', whereArgs: [t.id]);
  }

}
