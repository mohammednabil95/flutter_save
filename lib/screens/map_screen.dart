import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:prayer_bloc/location/location.dart';




class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController _controller;

  DeviceLocation currentLocation = new DeviceLocation();
  LatLng _center;
  List<PlacesSearchResult> places = [];
  bool isLoading = false;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  Position _position;


  static const kGoogleApiKey = "AIzaSyChUH0wzLip9yk6iM4aCsQJeNZ10SR0UBU";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void getNearbyPlaces() async {

    final int markerCount = markers.length;

    String markerIdVal = 'Mosque_$_markerIdCounter';
    _markerIdCounter++;
    MarkerId markerId = MarkerId(markerIdVal);


    PlacesSearchResponse result = await _places.searchNearbyWithRadius(Location(_position.latitude, _position.longitude), 1500, type: "mosque");


    setState(() {
      this.isLoading = false;
      if (result.status == "OK") {
        this.places = result.results;
        result.results.forEach((f) {
          String markerIdVal = 'Mosque_$_markerIdCounter';
          _markerIdCounter++;
          MarkerId markerId = MarkerId(markerIdVal);
          Marker marker = Marker(
            markerId: markerId,
            position: LatLng(f.geometry.location.lat, f.geometry.location.lng),
            infoWindow: InfoWindow(title: f.name, snippet: f.formattedAddress),
            onTap: () {
            },
          );
          setState(() {
            markers[markerId] = marker;
          });
        });
      } else {
        print(result.errorMessage);
      }
    });
  }

  getCurrentLocation() async{
    _position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
      _center = LatLng(_position.latitude, _position.longitude);
    setState(() {});
    getNearbyPlaces();
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_center != null && markers.length != 0) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  Padding(
          padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Card(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        child: Text(AppLocalizations.of(context).tr('Nearest Mosques'), style: TextStyle(fontSize: 16, color: Colors.white, decoration:TextDecoration.none),),
                      )
                  ),
                ),
                SizedBox(height: 20,),
                Expanded(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: GoogleMap(
                        indoorViewEnabled: true,
                        onMapCreated: _onMapCreated,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 14.0,
                        ),
                        markers: Set<Marker>.of(markers.values),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      );
    }
    else return Center(child: CircularProgressIndicator());
  }
}