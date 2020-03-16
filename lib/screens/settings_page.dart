import 'package:flutter_save/bloc/bloc.dart';
import 'package:flutter_save/repository/prayer_repository.dart';
import 'package:flutter_save/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_save/models/Options.dart';
import 'package:flutter_save/repository/options_repository.dart';

class ParentSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<OptionsBloc>(
            create: (BuildContext context) => OptionsBloc(OptionsRepositoryImp()),
              ),
          BlocProvider<PrayerBloc>(
            create: (BuildContext context) => PrayerBloc(repository: PrayerRepositoryImpl()),
          ),
        ],
        child: SettingsPage()
              );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int selectedRadio;
  OptionsBloc optionsBloc;
  PrayerBloc prayerBloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //selectedRadio = 0;
    optionsBloc = BlocProvider.of<OptionsBloc>(context);
    optionsBloc.add(FetchOptionsEvent());
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: BlocListener<OptionsBloc, OptionsState>(
              listener: (context, state) {},
              child: BlocBuilder<OptionsBloc, OptionsState>(
                builder: (context, state) {
                  if (state is InitialOptionsState) {
                    return buildLoading();
                  } else if (state is OptionsLoadedState) {
                    print("state");
                    print(state.options.selectedMethod);
                    return BuildList(options: state.options);
                  }
                },
              ))),
      floatingActionButton: Container(
        width: 150.0,
        height: 70.0,
        child: FloatingActionButton(onPressed: () {
          Options save = Options(selectedRadio);
          optionsBloc.add(SaveOptionsEvent(save));
          prayerBloc = BlocProvider.of<PrayerBloc>(context);
          prayerBloc.add(FetchPrayerMethodEvent(method: selectedRadio));
          Navigator.pop(context);
        },
          child: Text('Save'),
      ),
      ),
    );
  }


  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class BuildList extends StatefulWidget {

  Options options;
  BuildList({this.options});
  @override
  BuildList_State createState() => BuildList_State();
}

class BuildList_State extends State<BuildList> {


  OptionsBloc optionsBloc;
  int selectedRadio;
  setSelectedRadio(int val){
    setState(() {
      selectedRadio = val;
    });
  }

  setSelectecMethod(){
    setState(() {
      selectedRadio = widget.options.selectedMethod;
    });
  }

  @override
  void initState() {
    super.initState();
    optionsBloc = BlocProvider.of<OptionsBloc>(context);
    setSelectecMethod();
    print("init $selectedRadio");
    print(widget.options.selectedMethod);
  }

  @override
  Widget build(BuildContext context) {
    //save.selectedMethod = selectedRadio;
    //print(selectedRadio);
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Prayer Methods",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              children: <Widget>[
                RadioListTile(
                    value: 4,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Umm Al-Qura University, Makkah ",
                    ),
                    onChanged: (val) {
                      print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 1,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "University of Islamic Sciences, Karachi",
                    ),
                    onChanged: (val) {
                      print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 2,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Islamic Society of North America",
                    ),
                    onChanged: (val) {
                      print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 3,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "	Muslim World League ",
                    ),
                    onChanged: (val) {
                      print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 5,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Egyptian General Authority of Survey",
                    ),
                    onChanged: (val) {
                      print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 7,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Institute of Geophysics, University of Tehran",
                    ),
                    onChanged: (val) {
                      print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 8,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Gulf Region",
                    ),
                    onChanged: (val) {
                      print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 9,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Kuwait",
                    ),
                    onChanged: (val) {
                      print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 10,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Qatar",
                    ),
                    onChanged: (val) {
                      print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 11,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Majlis Ugama Islam Singapura, Singapore",
                    ),
                    onChanged: (val) {
                      print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 12,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Union Organization islamic de France",
                    ),
                    onChanged: (val) {
                      print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 13,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Diyanet İşleri Başkanlığı, Turkey",
                    ),
                    onChanged: (val) {
                      print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 14,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Spiritual Administration of Muslims of Russia",
                    ),
                    onChanged: (val) {
                      print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 0,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Ithna-Ansari",
                    ),
                    onChanged: (val) {
                      print(val);
                      setSelectedRadio(val);
                    }),
                FloatingActionButton(
                  onPressed: (){
                    Options save = Options(selectedRadio);

                    optionsBloc.add(SaveOptionsEvent(save));
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}