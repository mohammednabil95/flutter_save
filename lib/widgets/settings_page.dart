import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_save/models/enum_prayer_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Languages.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  final data;
  final method;

  SettingsPage({this.data,this.method});

  @override
  _SettingsPageState createState() => _SettingsPageState(data: this.data,method: method);

}

class _SettingsPageState extends State<SettingsPage> {
  var data;
  int method;

  PrayerMethods selectedMethod = PrayerMethods.Umm_Al_Qura_University_Makkah;
  Languages radioLang;


  _SettingsPageState({this.data,this.method}){
    if(method!=null){
      selectedMethod = PrayerMethods.values[method];
      print("starting setting page: selectdMethod: [$method]: [${selectedMethod.toString()}]");
    }
  }

  @override
  void initState() {
    print("initState: data: $data");
    print("initState: data.toString(): ${data.toString()}");
    print("initState: data.savedLocale.toString(): ${data.savedLocale.toString()}");
    if(data.savedLocale!=null){
      print("initState: data.savedLocale.languageCode: ${data.savedLocale.languageCode}");
      if(data.savedLocale.languageCode == "ar"){
        radioLang = Languages.ar;
      }else{
        radioLang = Languages.en;
      }
    }

    print("initState: radioLand: $radioLang");
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: new Text(AppLocalizations.of(context).tr("Settings")),
        backgroundColor: Color(0xFF614729),
        elevation: 10,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Text(AppLocalizations.of(context).tr("Language"),
                          style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
                ),
                Column(
                  children: <Widget>[
                    RadioListTile(
                      value: Languages.en,
                      groupValue: radioLang,
                      activeColor: Colors.black,
                      onChanged: (val){
                        setState(() {
                          radioLang = val;
                        });
                      },
                      title: Text("English",),),
                    RadioListTile(
                      value: Languages.ar,
                      groupValue: radioLang,
                      activeColor: Colors.black,
                      onChanged: (val){
                        setState(() {
                          radioLang = val;
                        });
                      },
                      title: Text(AppLocalizations.of(context).tr("Arabic"),
                        ),),
                  ],
                ),
                Divider(
                  height: 50,
                  color: Colors.brown,
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Text(AppLocalizations.of(context).tr("Prayer Methods"),
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ),
                Column(
                  children: <Widget>[
                RadioListTile(value: PrayerMethods.Umm_Al_Qura_University_Makkah, groupValue: selectedMethod,
                    activeColor: Colors.black,
                    title: Text(AppLocalizations.of(context).tr("Umm Al-Qura University, Makkah", )),
                    onChanged: (val){
                      setState(() {
                        selectedMethod = val;
                      });
                    }),
                    RadioListTile(value: PrayerMethods.Muslim_WorldLeague, groupValue: selectedMethod,
                        activeColor: Colors.black,
                        title: Text(AppLocalizations.of(context).tr("Muslim World League"),
                        ),
                        onChanged: (val){
                          setState(() {
                            selectedMethod = val;
                          });
                        }),
                    RadioListTile(value: PrayerMethods.Gulf_Region, groupValue: selectedMethod,
                        activeColor: Colors.black,
                        title: Text(AppLocalizations.of(context).tr("Gulf Region"),
                        ),
                        onChanged: (val){
                          setState(() {
                            selectedMethod = val;
                          });
                        }),
                    RadioListTile(value: PrayerMethods.Kuwait, groupValue: selectedMethod,
                        activeColor: Colors.black,
                        title: Text(AppLocalizations.of(context).tr("Kuwait"),
                        ),
                        onChanged: (val){
                          setState(() {
                            selectedMethod = val;
                          });
                        }),
                    RadioListTile(value: PrayerMethods.Qatar, groupValue: selectedMethod,
                        activeColor: Colors.black,
                        title: Text(AppLocalizations.of(context).tr("Qatar"),
                        ),
                        onChanged: (val){
                          setState(() {
                            selectedMethod = val;
                          });
                        }),
                    RadioListTile(value: PrayerMethods.University_of_Islamic_Sciences_Karachi, groupValue: selectedMethod,
                        activeColor: Colors.black,
                        title: Text(AppLocalizations.of(context).tr("University of Islamic Sciences, Karachi",)),
                        onChanged: (val){
                          setState(() {
                            selectedMethod = val;
                          });
                        }),
                    RadioListTile(value: PrayerMethods.Islamic_Society_of_North_America, groupValue: selectedMethod,
                        activeColor: Colors.black,
                        title: Text(AppLocalizations.of(context).tr("Islamic Society of North America"),
                          ),
                        onChanged: (val){
                          setState(() {
                            selectedMethod = val;
                          });
                        }),
                    RadioListTile(value: PrayerMethods.Egyptian_GeneralAuthority_of_Survey, groupValue: selectedMethod,
                        activeColor: Colors.black,
                        title: Text(AppLocalizations.of(context).tr("Egyptian General Authority of Survey"),
                        ),
                        onChanged: (val){
                          setState(() {
                            selectedMethod = val;
                          });
                        }),
                    RadioListTile(value: PrayerMethods.Shia_Ithna_Ansari, groupValue: selectedMethod,
                        activeColor: Colors.black,
                        title: Text(AppLocalizations.of(context).tr("Ithna-Ashari"),
                        ),
                        onChanged: (val){
                          setState(() {
                            selectedMethod = val;
                          });
                        }),
                    RadioListTile(value: PrayerMethods.Institute_ofGeophysics_University_of_Tehran, groupValue: selectedMethod,
                        activeColor: Colors.black,
                        title: Text(AppLocalizations.of(context).tr("Institute of Geophysics, University of Tehran"),
                        ),
                        onChanged: (val){
                          setState(() {
                            selectedMethod = val;
                          });
                        }),
                    RadioListTile(value: PrayerMethods.MajlisUgama_Islam_Singapura_Singapore, groupValue: selectedMethod,
                        activeColor: Colors.black,
                        title: Text(AppLocalizations.of(context).tr("Majlis Ugama Islam Singapura, Singapore"),
                        ),
                        onChanged: (val){
                          setState(() {
                            selectedMethod = val;
                          });
                        }),
                    RadioListTile(value: PrayerMethods.UnionOrganization_islamic_de_France, groupValue: selectedMethod,
                        activeColor: Colors.black,
                        title: Text(AppLocalizations.of(context).tr("Union Organization islamic de France"),
                          ),
                        onChanged: (val){
                          setState(() {
                            selectedMethod = val;
                          });
                        }),
                    RadioListTile(value: PrayerMethods.DiyanetIsleri_Baskanligi_Turkey, groupValue: selectedMethod,
                        activeColor: Colors.black,
                        title: Text(AppLocalizations.of(context).tr("Diyanet İşleri Başkanlığı, Turkey"),
                        ),
                        onChanged: (val){
                          setState(() {
                            selectedMethod = val;
                          });
                        }),
                    RadioListTile(value: PrayerMethods.SpiritualAdministration_of_Muslims_of_Russia, groupValue: selectedMethod,
                        activeColor: Colors.black,
                        title: Text(AppLocalizations.of(context).tr("Spiritual Administration of Muslims of Russia"),
                        ),
                        onChanged: (val){
                          setState(() {
                            selectedMethod = val;
                        });
                        }),
                  ],
                ),
              ],
            ),
          ],

        ),
      ),

      floatingActionButton: Container(
        width: 100.0,
        height: 50.0,
        child: FloatingActionButton(onPressed: () async{
          _onLoading();
          if(selectedMethod.index != method){
            //await updateLanguageAndMethod();
          }
          Navigator.pop(context);
          changeLanguage(data,radioLang.index);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
        },
        child: new Text(AppLocalizations.of(context).tr("Save"),style: TextStyle(fontSize: 15.0),),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 10,
          backgroundColor: Color(0xFF614729),
        ),
      ),
    );
  }
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

  dynamic getLanguageInSharedPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get('language');
  }

  Future<String> updateMethodInSharedPrefs(int method) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('prayer_method', method);
    String value = "updateMethod: $method";
    print(value);
    return value;

  }



  void _onLoading() {
    showDialog(
      builder: (_) => Center(child: CircularProgressIndicator()),
      context: context,
      barrierDismissible: false,
    );
  }

}
