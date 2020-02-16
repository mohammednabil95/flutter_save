import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_save/models/Languages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageDialog extends StatefulWidget {

  final data;

  @override
  _LanguageDialogState createState() => _LanguageDialogState(data: this.data);

  LanguageDialog({this.data});
}

class _LanguageDialogState extends State<LanguageDialog> {

  var data;
  int lang;
  Languages radioLang;

  _LanguageDialogState({this.data}){
    if(data.savedLocale.countryCode == "ar"){
      radioLang = Languages.ar;
    }else{
      radioLang = Languages.en;
    }
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).tr('Select Language')),
      content: SizedBox(
        height: 115,
        child: Column(

          children: <Widget>[
            RadioListTile<Languages>(
              title: const Text('English'),
              value: Languages.en,
              groupValue: radioLang,
              onChanged: (Languages value) { radioButtonChanges(value); },
            ),
            RadioListTile<Languages>(
              title: const Text('عربي'),
              value: Languages.ar,
              groupValue: radioLang,
              onChanged: (Languages value) { radioButtonChanges(value); },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            changeLanguage(data,radioLang.index);
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context).tr('OK')),
        )
      ],
    );
  }

  void radioButtonChanges(Languages value) {
    setState(() {
      radioLang = value;
      print(value);
    });
  }

  //change language to given value:
  void changeLanguage(var data,int value){
    this.setState(() {
      switch (value) {
        case 0:
          updateLanguageInSharedPrefs(value);
          data.changeLocale(Locale("en"));
          print("changeLanguage(): EN selected");
          break;
        case 1:
          updateLanguageInSharedPrefs(value);
          data.changeLocale(Locale("ar"));
          print("changeLanguage(): AR selected");
          break;
      }

    });
  }

  void updateLanguageInSharedPrefs(int lang) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('language', lang);
  }
}
