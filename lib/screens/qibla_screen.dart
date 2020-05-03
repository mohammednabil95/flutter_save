import 'dart:math' as math;
import 'dart:math';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class QiblaScreen extends StatefulWidget {
  @override
  _QiblaScreenState createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  bool _hasPermissions = false;
  Position _position;
  double qiblaDegrees;
  bool _foundLocation = false;
  @override
  void initState() {
    super.initState();
    getLocationAndQibla();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        child: Text(AppLocalizations.of(context).tr('Qibla'), style: TextStyle(fontSize: 16, color: Colors.white, decoration:TextDecoration.none),),
                      )
                  ),
                ),
              ],
            ),
          ],
        ),
        _buildCompass(),
      ],
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<double>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }
        if (!snapshot.hasData || _foundLocation == false ) {
          return Center(
            child: Container(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(),
            ),
          );
        }
        double direction = snapshot.data;
        return Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: Transform.rotate(
            angle: - qiblaDegrees + ((direction ?? 0) * (math.pi / 180) * -1),
            child: Image.asset('assets/qibla31.png',),
          ),
        );
      },
    );
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Location Permission Required'),
          RaisedButton(
            child: Text('Request Permissions'),
            onPressed: () {
              PermissionHandler().requestPermissions(
                  [PermissionGroup.locationWhenInUse]).then((ignored) {
                _fetchPermissionStatus();
              });
            },
          ),
          SizedBox(height: 16),
          RaisedButton(
            child: Text('Open App Settings'),
            onPressed: () {
              PermissionHandler().openAppSettings().then((opened) {
              });
            },
          )
        ],
      ),
    );
  }

  void _fetchPermissionStatus() {
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }

  getLocationAndQibla() async {
    qiblaDegrees = await getDegreesToQibla();
    setState(() {
      _foundLocation = true;
    });
  }

  //get degrees needed to rotate the compass to qibla direction based on current location
  Future<double> getDegreesToQibla() async{
    _position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.low);
    print('getDegreesToQibla: calculating degrees to Qibla...');
    //Qibla coordinates:
    double latQibla = 39.83;
    double longQibla = 21.53;
//    double latQibla = 21.422487;
//    double longQibla = 39.826206;
    double dLon = radians(longQibla-_position.longitude);
    double lat = radians(_position.latitude);
    latQibla = radians(latQibla);
    double y = sin(dLon) * cos(latQibla);
    double x = cos(lat)*sin(latQibla) -
        sin(lat)*cos(latQibla)*cos(dLon);
    double bearing = degrees(atan2(y, x));
    print('getDegreesToQibla: final degrees: $bearing');
    return bearing;
  }
}
