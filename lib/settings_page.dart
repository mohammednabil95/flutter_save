import 'package:prayer_bloc/bloc/bloc.dart';
import 'package:prayer_bloc/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prayer_bloc/models/Options.dart';
import 'package:prayer_bloc/repository/options_repository.dart';

class ParentSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OptionsBloc>(
      create: (BuildContext context) => OptionsBloc(OptionsRepositoryImp()),
        child: SettingsPage());
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int selectedRadio;
  OptionsBloc optionsBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedRadio=0;
    optionsBloc = BlocProvider.of<OptionsBloc>(context);
    optionsBloc.add(FetchOptionsEvent());
  }

  @override
   build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: BlocListener<OptionsBloc, OptionsState>(
          listener: (context, state) {

          },
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
          )
        )));
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
                    value: 1,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Egyptian General Authority of Survey",
                    ),
                    onChanged: (val) {
                      //print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 2,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "University Of Islamic Sciences, Karachi (Shafi)",
                    ),
                    onChanged: (val) {
                      //print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 3,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "University Of Islamic Sciences, Karachi (Hanafi)",
                    ),
                    onChanged: (val) {
                      //print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 4,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "	Islamic Circle of North America ",
                    ),
                    onChanged: (val) {
                      //print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 5,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Muslim World League",
                    ),
                    onChanged: (val) {
                      //print(val);
                      setSelectedRadio(val);
                    }),
                RadioListTile(
                    value: 6,
                    groupValue: selectedRadio,
                    activeColor: Colors.black,
                    title: Text(
                      "Umm Al-Qura",
                    ),
                    onChanged: (val) {
                      //print(val);
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



