// Required Packages

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io'; //deal with file and folders
import 'package:path_provider/path_provider.dart';
import 'package:note_keeper/models/note.dart';

// first step create Database helper class with singleton object
class DataBaseHelper {
  // first i create singleton object-01
  static DataBaseHelper _databaseHelper; //singleton DataBaseHelper
  static Database _database; //singleton DataBase

  // here i define DataBase table instance
  // String colId is column name
  String noteTable = "note_table";
  String colId = "id";
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  //third i create name constructor - 3
  DataBaseHelper._createInstance(); // name constructor to create instance of DataBaseHelper

// factory Constructor use for get some return value
  //second i create constructor of DataBaseHelper class - 02
  factory DataBaseHelper() {
    // here i define object
    if (_databaseHelper == null) {
      _databaseHelper = DataBaseHelper
          ._createInstance(); //  This is executed only once,singleton object
    }
    return _databaseHelper;
  }

  //step -07 Create getter for database reference variable which is declare static Database _database; over there
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDataBase();
    }
    return _database;
  }

  // hear i create method for initialize data-05
  Future<Database> initializeDataBase() async {
    // get the directory path for both android & ios to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    //define the path to our database
    String path = directory.path + 'note.db';
    //  Open/create the database at a given path -06
    var notesDataBase =
        await openDatabase(path, version: 1, onCreate: _crateDb);
    return notesDataBase;
  }

  // create method for create my database table -04
  void _crateDb(Database db, int newVersion) async {
    //this statement help to create required column into DataBase
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colTitle TEXT, $colDescription TEXT,$colPriority INTEGER,$colDate TEXT)');
  }

  //step -08 Fetch Operation: get all Note object from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    //var result = await db.rawQuery("SELECT * FROM $noteTable order by $colPriority ASC");
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

  // step -09 insert operation :insert a Note object to database
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  //step -10 Update Operation: Update a Note object and save from database
  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

//step-11 Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete("DELETE FROM $noteTable Where $colId =$id");
    return result;
  }

// step -12 Get number of Note object in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

//step - 9 for functional code.
// Get the "Map List"[List<Map>] and convert it to "Note List"[List<Note>]
  Future<List<Note>> getNoteList() async {
    var notMapList = await getNoteMapList(); //get 'map list ' from the database
    int count =
        notMapList.length; // count the number of map entries in db table
    List<Note> noteList = List<Note>();

    for (var i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(notMapList[i]));
    }
    return noteList;
  }
}
