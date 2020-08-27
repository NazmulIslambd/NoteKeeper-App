import 'package:flutter/material.dart';
import 'package:note_keeper/screens/note_detail.dart';

//put all functional code required
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';

class NoteList extends StatefulWidget {
  int count = 0; //show how many list create
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  //step -1 for functional code create object of database_helper class
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    //step -2 for functional code
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getListView(), // implement method for listView step -1

      // implement floating action button step -2
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Here i declare navigator for screen route from build method : first step for navigator
          navigatorToDetail(Note('',2,''),"Add Note"); //AppBarTitle step-4
          //step-12 for functional code
        },
        tooltip: "Add Note",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getListView() {
    // Step -1 here i declare method
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              // here i declare icon and background color which is yellow
              //step -7 for functional code.
              backgroundColor: getPriorityColor(
                  this.noteList[position].priority), //from method-3
              child: getPriorityIcon(
                  this.noteList[position].priority), //from method-4
            ),
            title: Text(
              this.noteList[position].title, //title from database
              style: textStyle,
            ),
            subtitle: Text(this.noteList[position].date),
            //date from database
            //step -8 for functional code. saw step -9 in database_helper.dart
            //if i use delete icon for onTap must be use gestureDetector widget
            trailing: GestureDetector(
                //remember when ever use onTap even handler just warp GestureDetector widget
                child: Icon(
                  Icons.delete,
                  color: Colors.grey,
                ),
                onTap: () {
                  _delete(context, noteList[position]);
                } //context for snackBar
                ),
            onTap: () {
              // declare onTap handler for go to next Page
              // Here i declare navigator for screen route from build method  : 02 step for navigator
              navigatorToDetail(this.noteList[position],"Edit Note"); // AppBarTitle step-3
              // step-13 for functional code go to note detail.dart for step-14
            },
          ),
        );
      },
    );
  }

// Here i create method for navigator which is use for screen route
  //step-27 use database use also if condition
  void navigatorToDetail(Note note,String title) async{ //step-11 for functional code use Note for add new list
    //here i use string title for AppBarTitle step-1
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note,title); //AppBarTitle step-2
    }));
    if(result == true){
      updateListView();
    }
  }

//step -3 for functional code.create method for priority color
  Color getPriorityColor(priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

//step -4 for functional code.create method for priority Icon
  Icon getPriorityIcon(priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

//step -5 for functional code.create method for delete list from database
  void _delete(BuildContext context, Note note) async {
    int result = await dataBaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();//from step -10
    }
  }

//step -6 for functional code.create method for showSnackBar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  //step -10 for functional code.create method for
  void updateListView() {
    final Future<Database> dbFuture = dataBaseHelper
        .initializeDataBase(); //i will get the singleton instance of our database once you get the database then execute 'then 'Function
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = dataBaseHelper
          .getNoteList(); //get the method from database helper class step -9 getNoteList
      noteListFuture.then((noteList){
      setState(() {//use setState function for update UI
        this.noteList = noteList;
        this.count = noteList.length;
      });
      });
    });
  }
}
