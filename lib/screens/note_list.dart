import 'package:flutter/material.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: getListView(), // implement method for listView step -1

      // implement floating action button step -2
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("Tap floating Button");
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
              backgroundColor: Colors.yellow,
              child: Icon(Icons.keyboard_arrow_right),
            ),
            title: Text(
              "dummy Title",
              style: textStyle,
            ),
            subtitle: Text("Dummy Text"),
            trailing: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onTap: () {
              // declare onTap handaler for go to next Page
              //  we declare functional code next time..
              debugPrint("Press on top for next page");
            },
          ),
        );
      },
    );
  }
}
