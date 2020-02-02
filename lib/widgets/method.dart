import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Method extends StatefulWidget {
  @override
  _MethodState createState() => _MethodState();
}

class _MethodState extends State<Method> {
  int _crtIndex = 4;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Prayer Methods"),
      content: Container(
        height:MediaQuery.of(context).size.height / 1,
        width: MediaQuery.of(context).size.width / 1,
        child: ListView(
          children: <Widget>[
            RadioListTile(value: 0, groupValue: _crtIndex,
                title: Text("Shia Ithna-Ansari"),
                activeColor: Colors.teal,
                onChanged: (val){
                  setState(() {
                    _crtIndex = val;
                  });
                }),
            RadioListTile(value: 1, groupValue: _crtIndex,
                title: Text("University of Islamic Sciences, Karachi"),
                activeColor: Colors.teal,
                onChanged: (val){
                  setState(() {
                    _crtIndex = val;
                  });
                }),
            RadioListTile(value: 2, groupValue: _crtIndex,
                title: Text("Islamic Society of North America"),
                activeColor: Colors.teal,
                onChanged: (val){
                  setState(() {
                    _crtIndex = val;
                  });
                }),
            RadioListTile(value: 3, groupValue: _crtIndex,
                title: Text("Muslim World League"),
                activeColor: Colors.teal,
                onChanged: (val){
                  setState(() {
                    _crtIndex = val;
                  });
                }),
            RadioListTile(value: 4, groupValue: _crtIndex,
                title: Text("Umm Al-Qura University, Makkah "),
                activeColor: Colors.teal,
                onChanged: (val){
                  setState(() {
                    _crtIndex = val;
                  });
                }),
            RadioListTile(value: 5, groupValue: _crtIndex,
                title: Text("Egyptian General Authority of Survey"),
                activeColor: Colors.teal,
                onChanged: (val){
                  setState(() {
                    _crtIndex = val;
                  });
                }),
            RadioListTile(value: 7, groupValue: _crtIndex,
                title: Text("Institute of Geophysics, University of Tehran"),
                activeColor: Colors.teal,
                onChanged: (val){
                  setState(() {
                    _crtIndex = val;
                  });
                }),
            RadioListTile(value: 8, groupValue: _crtIndex,
                title: Text("Gulf Region"),
                activeColor: Colors.teal,
                onChanged: (val){
                  setState(() {
                    _crtIndex = val;
                  });
                }),
            RadioListTile(value: 9, groupValue: _crtIndex,
                title: Text("Kuwait"),
                activeColor: Colors.teal,
                onChanged: (val){
                  setState(() {
                    _crtIndex = val;
                  });
                }),
            RadioListTile(value: 10, groupValue: _crtIndex,
                title: Text("Qatar"),
                activeColor: Colors.teal,
                onChanged: (val){
                  setState(() {
                    _crtIndex = val;
                  });
                }),
            RadioListTile(value: 11, groupValue: _crtIndex,
                title: Text("Majlis Ugama Islam Singapura, Singapore"),
                activeColor: Colors.teal,
                onChanged: (val){
                  setState(() {
                    _crtIndex = val;
                  });
                }),
            RadioListTile(value: 12, groupValue: _crtIndex,
                title: Text("Union Organization islamic de France"),
                activeColor: Colors.teal,
                onChanged: (val){
                  setState(() {
                    _crtIndex = val;
                  });
                }),
            RadioListTile(value: 13, groupValue: _crtIndex,
                title: Text("Diyanet İşleri Başkanlığı, Turkey"),
                activeColor: Colors.teal,
                onChanged: (val){
                  setState(() {
                    _crtIndex = val;
                  });
                }),
            RadioListTile(value: 14, groupValue: _crtIndex,
                title: Text("Spiritual Administration of Muslims of Russia"),
                activeColor: Colors.teal,
                onChanged: (val){
                  setState(() {
                    _crtIndex = val;
                  });
                }),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text('OK'),
          onPressed: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('prayer_method', _crtIndex);
            print("method screen : $_crtIndex");
            Navigator.pop(context,_crtIndex);
          },
        )
      ],

    );
  }
}
