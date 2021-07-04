import 'package:armotaleadmin/widgets&helpers/helpers/styling.dart';
import 'package:armotaleadmin/widgets&helpers/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  LatLng currentPosition;
  CameraPosition cameraPosition;
  bool loading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? SpinKitThreeBounce(
            size: 40,
            color: black,
          )
        : Container(
            alignment: Alignment.center,
            child: FutureBuilder(
              future: getCurrentPosition(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                cameraPosition = snapshot.data;
                if (snapshot.hasData) {
                  return GoogleMap(
                    initialCameraPosition: cameraPosition,
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitThreeBounce(
                    size: 40,
                    color: black,
                  );
                }
                return Center(
                  child: CustomText(
                    text: snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                  ),
                );
              },
            ),
          );
  }

  Future<CameraPosition> getCurrentPosition() async {
    setState(() {
      loading = true;
    });
    var position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = LatLng(position.latitude, position.longitude);
    cameraPosition = CameraPosition(target: LatLng(currentPosition.latitude, currentPosition.longitude));
    setState(() {
      loading = false;
    });
    return cameraPosition;
  }
}
