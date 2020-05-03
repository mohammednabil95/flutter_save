import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_save/bloc/bloc.dart';
import 'package:flutter_save/bloc/notification_bloc.dart';
import 'package:flutter_save/bloc/prayer_bloc.dart';
import 'package:flutter_save/repository/options_repository.dart';
import 'package:flutter_save/screens/home_page.dart';
import 'package:flutter_save/repository/notifications_repository.dart';
import 'package:flutter_save/repository/prayer_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_save/screens/calendar_screen.dart';
import 'package:flutter_save/screens/map_screen.dart';
import 'package:flutter_save/screens/qibla_screen.dart';
import 'package:flutter_save/screens/settings_page.dart';
import 'models/ticker.dart';

void main() => runApp(EasyLocalization(child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return EasyLocalizationProvider(
        data: data,
        child: MaterialApp(
          title: 'Salah Times',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            EasylocaLizationDelegate(
                locale: data.locale ?? Locale('en', 'US'),
                path: 'assets/langs'),
          ],
          supportedLocales: [Locale('en', 'US'), Locale('ar', 'SA')],
          locale: data.savedLocale,
          theme: ThemeData(
            primarySwatch: Colors.brown,
          ),
          home: MultiBlocProvider(
            providers: [
              BlocProvider<PrayerBloc>(
                create: (BuildContext context) =>
                    PrayerBloc(repository: PrayerRepositoryImpl()),
              ),
              BlocProvider<NotificationBloc>(
                create: (BuildContext context) => NotificationBloc(
                    notificationsRepository: NotificationsRepositoryImp()),
              ),
              BlocProvider<TimerBloc>(
                create: (BuildContext context) => TimerBloc(ticker: Ticker()),
              ),
              BlocProvider<OptionsBloc>(
                create: (BuildContext context) =>
                    OptionsBloc(OptionsRepositoryImp()),
              ),
            ],
            child: MainScreen(),
          ),
        ));
  }
}

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => new MainScreenState();
}

// SingleTickerProviderStateMixin is used for animation
class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  // Create a tab controller
  TabController controller;
  int lang;

  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    //TimesScreen(),
    ParentCalendarPage(),
    MapsScreen(),
    QiblaScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize the Tab Controller
    controller = new TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    print(Localizations.localeOf(context).languageCode);
    //var index;
    return EasyLocalizationProvider(
      data: data,
      child: Stack(
        children: <Widget>[
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/AppBackground.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          WillPopScope(
            onWillPop: () async {
              SystemNavigator.pop();
            },
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: <Widget>[
                      IconButton(
                        icon: new Image.asset(
                          "assets/SalawatLogoIcon1.png",
                          fit: BoxFit.contain,
                        ),
                        iconSize: 50.0,
                      ),
                      //Image(image: AssetImage("assets/SalawatLogoIcon1.png"), fit: BoxFit.contain,),
                      Padding(padding: EdgeInsets.all(1)),
                      Text(
                        AppLocalizations.of(context).tr('Salah Times'),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.black38,
                  elevation: 0,
                  actions: <Widget>[
                    PlatformIconButton(
                      iosIcon: Icon(
                        CupertinoIcons.ellipsis,
                        size: 28.0,
                      ),
                      androidIcon: Icon(Icons.menu),
                      //icon: Icon( Icons.menu),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ParentSettingsPage()));
                      },
                    ),
                  ]),

              body: _children[_currentIndex],
              //extendBody: true,
              bottomNavigationBar: Container(
                child: BottomNavigationBar(
                  selectedItemColor: Colors.white70,
                  unselectedItemColor: Colors.white30,
                  backgroundColor: Colors.black12,
                  type: BottomNavigationBarType.fixed,
                  elevation: 0,
                  onTap: onTabTapped,
                  currentIndex: _currentIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.home),
                      title: Text(AppLocalizations.of(context).tr('Home')),
                    ),
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.calendar_today),
                      title: Text(AppLocalizations.of(context).tr('Calendar')),
                    ),
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.map),
                      title: Text(AppLocalizations.of(context).tr('Mosques')),
                    ),
                    BottomNavigationBarItem(
                      icon: new Icon(Icons.navigation),
                      title: Text(AppLocalizations.of(context).tr('Qibla')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
