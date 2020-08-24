import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoteDetail extends StatefulWidget {
  // create constructor for AppBar title
  String appBarTitle; //AppBarTitle step-5
  NoteDetail(this.appBarTitle);

  @override //AppBarTitle step-6
  _NoteDetailState createState() => _NoteDetailState(
      this.appBarTitle); //this.appBarTitle here i use appBar title
}

class _NoteDetailState extends State<NoteDetail> {
  //this.appBarTitle here i use appBar title
  String appBarTitle; //AppBarTitle step-7

  _NoteDetailState(this.appBarTitle);

  var _formKey = GlobalKey<FormState>();
  static var _priorities = ['High', 'Low']; //value declare for dropDown menu

  //controller declare for TextFiled for second step-02
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return WillPopScope(
        //  willPopScope use for screen pop
       onWillPop:(){
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
                          value: 'Low', // default value is low

                          onChanged: (valueSelectedByUser) {
                            setState(() {
                              debugPrint("User selected $valueSelectedByUser");
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
                                }
                              });
                            },
                          )),
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
    Navigator.pop(context);
  }
}
