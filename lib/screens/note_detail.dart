import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//put all functional code required
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';

// ignore: must_be_immutable
class NoteDetail extends StatefulWidget {
  // create constructor for AppBar title
  final String appBarTitle; //AppBarTitle step-5
  //step - 14 for functional code.
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override //AppBarTitle step-6
  State<StatefulWidget> createState() {
   return NoteDetailState(this.note, this.appBarTitle);
  } //this.appBarTitle here i use appBar title
}

class NoteDetailState extends State<NoteDetail> {
  //this.appBarTitle here i use appBar title
  String appBarTitle; //AppBarTitle step-7
  Note note;

  NoteDetailState(this.note, this.appBarTitle);

  var _formKey = GlobalKey<FormState>();
  static var _priorities = ['High', 'Low']; //value declare for dropDown menu
  // step-15 for functional code singleton instance of database helper
  DataBaseHelper helper = DataBaseHelper();

  //controller declare for TextFiled for second step-02
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    // step-16 for functional code show information
    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
        //  willPopScope use for screen pop
        onWillPop: () {
          // write some code to control things,when user press Back navigation button in device
          moveToLastScreen(); // implement method here

          return null;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            //  ultimate use appBarTitle //AppBarTitle step-8
            // leading icon use for pop operation
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // write some code to control things,when user press Back navigation button in device
                  moveToLastScreen(); // implement method here
                }),
          ),
          body: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10),
                child: ListView(
                  children: <Widget>[
                    //  First Element which is DropDown menu step -01
                    ListTile(
                      title: DropdownButton(
                          items: _priorities.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem));
                          }).toList(),
                          style: textStyle,
                          value: getPriorityAsString(note.priority),
                          // set step-17 from

                          onChanged: (valueSelectedByUser) {
                            setState(() {
                              debugPrint("User selected $valueSelectedByUser");
                              updatePriorityAsInt(
                                  valueSelectedByUser); //set step -18 from
                            });
                          }),
                    ),
                    // Second Element, Here i create TextField step-02
                    Padding(
                      padding:
                          EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'you can\'t Empty';
                          }
                          return null;
                        },
                        controller: titleController,
                        style: textStyle,
                        onChanged: (value) {
                          // we put functional code next time
                          debugPrint('Something change in title text Field');
                          updateTitle(); //from step-19
                        },
                        decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),

                    // Third Element, Here i create TextField step-03

                    Padding(
                      padding:
                          EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'you can\'t Empty';
                          }
                          return null;
                        },
                        controller: descriptionController,
                        style: textStyle,
                        onChanged: (value) {
                          // we put functional code next time
                          debugPrint(
                              'Something change in Description text Field');
                          updateDescription(); //from step-20
                        },
                        decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),

                    // Fourth Element, Here i create TextField step-04

                    Padding(
                      padding: EdgeInsets.only(top: 80, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Save",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {

                                if (_formKey.currentState.validate()) {
                                  debugPrint("Press from save button");
                                  //step-24 for function
                                  _save();//from step-21
                                }
                              });
                            },
                          ),
                          ),
                          Container(
                            width: 5.0,
                          ),
                          Expanded(
                              child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Delete",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Press from Delete button");
                                _delete();//from step-25
                              });
                            },
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ));
  }

  //  create method for pop screen
  void moveToLastScreen() {
    // step-26 pass some value for update list view true go to note list where is Navigator.pop(context,true); for step-27
    Navigator.pop(context,true);
  }

// step-17 for functional code.Convert the string priority in the form integer before saving to database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

// step-18 for functional code.Convert int priority to String priority and display it to use in Dropdown
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; //high
        break;
      case 2:
        priority = _priorities[1]; //low
        break;
    }
    return priority;
  }

// step-19 for functional code.for text field
//update the title of the note object
  void updateTitle() {
    note.title = titleController.text;
  }

// step-20 for functional code.for text field
//update the description of the note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

// step-21 for functional code.for Save button
  void _save() async {
    //step-22 for function move last page
    moveToLastScreen();

//step-23 for function date
    note.date = DateFormat.yMMMd().format(DateTime.now());
    var result;
    if (note.id != null) {
      result = await helper.updateNote(
          note); //come from step -09 insert operation :insert a Note object to database
    }
    else {
      result = await helper.insertNote(
          note); // come from step -10 Update Operation: Update a Note object and save from database
    }
    if (result != 0) {
      //success
      _showAlertDialog('Status', 'Note saved Successful');
    } else {
      //Failure
      _showAlertDialog('Status', "Problem Saving note");
    }
  }
  //step -25 for delete button
  void _delete()async{
    moveToLastScreen();
    //case 1: if user is trying to delete the new note i.e. he has come to
    //the detail page by pressing The FAB to NOteList page.
    if(note.id == null){
      _showAlertDialog("Status", "No Note was deleted");
      return;
    }
    //Case 2: USER is trying to delete the old note that already has valid Id.
   int result = await helper.deleteNote(note.id);
    if (result != 0) {
      //success
      _showAlertDialog('Status', 'Note Delete Successful');
    } else {
      //Failure
      _showAlertDialog('Status', "Error Occurred while deleting note");
    }

  }



//Create alert Dialog method for step-21
  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
