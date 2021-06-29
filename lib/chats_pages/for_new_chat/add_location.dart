import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:ezhlha/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AddLocation extends StatefulWidget {
  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  Completer<GoogleMapController> _controller = Completer();

  LatLng currentLocation = _initialCameraPosition.target;

  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(24.744887, 46.696865),
    zoom: 12,
  );
  //////////////////////////////////
  // Future<File> _fileFromImageUrl(String url) async {
  //   final response = await http.get(url);

  //   final documentDirectory = await getApplicationDocumentsDirectory();

  //   final file = File(join(documentDirectory.path, 'imagetest.png'));

  //   file.writeAsBytesSync(response.bodyBytes);

  //   return file;
  // }

  Future<ui.Image> getImage(String path) async {
    Completer<ImageInfo> completer = Completer();
    var img = new NetworkImage(path);
    img
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }

  // Future<ui.Image> getImageFromPath(String imagePath) async {
  //   var imageFile = await _fileFromImageUrl(imagePath);

  //   Uint8List imageBytes = imageFile.readAsBytesSync();

  //   final Completer<ui.Image> completer = new Completer();

  //   ui.decodeImageFromList(imageBytes, (ui.Image img) {
  //     return completer.complete(img);
  //   });

  //   return completer.future;
  // }

  Future<BitmapDescriptor> getMarkerIcon(
      String imagePath, String name, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = Colors.blue;
    final double tagWidth = 40;

    final Paint shadowPaint = Paint()..color = Colors.transparent;
    final double shadowWidth = 13.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 3.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(shadowWidth, shadowWidth,
              size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    // Add tag circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(size.width, 0, name.length.toDouble() * 15, tagWidth),
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        tagPaint);

    // Add tag text
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: name,
      style: TextStyle(fontSize: 15.0, color: Colors.black),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(0, tagWidth / 2.4 - textPainter.height));

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    ui.Image image = await getImage(
        imagePath); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

////////////////////////////
  Marker marker;

  Set<Marker> _markers = {};

  Uint8List dataBytes;

  List<LatLng> loc = [
    LatLng(24.78309, 46.74601),
    LatLng(24.78329, 46.74654),
    LatLng(24.8115, 46.76871),
  ];

  Future<Uint8List> getmarker() async {
    List<String> iconurl = [
      'https://storage.googleapis.com/ezhalha-275202.appspot.com/places/5bdc3bc41a2925003285f8e4/11W1TAUQ8VS8.png',
      'https://storage.googleapis.com/ezhalha-275202.appspot.com/places/50a53cb0e4b0c2165f43aaf8/5ISHGWBPKFG4.png',
      'https://storage.googleapis.com/ezhalha-275202.appspot.com/places/58abd28955d6223a8434ab74/FGX0SZ3QE8RN.png',
    ];

    List<String> name = ['mish cafe', 'Al Majlis el khaliji', 'Shawerma house'];

    for (int i = 0; i < name.length; i++) {
      // var dataBytes;
      // var request = await http.get(iconurl[i]);
      // var bytes = request.bodyBytes;

      // setState(() {
      //   dataBytes = bytes;
      // });

      // final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
      //   bytes,
      //     targetWidth: 50,
      //      targetHeight: 50);

      // final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
      // final ByteData byteData = await frameInfo.image.toByteData(
      //   format: ui.ImageByteFormat.png,
      // );

      // final Uint8List resizedMarkerImageBytes = byteData.buffer.asUint8List();

      final Marker marker = Marker(
        markerId: MarkerId('$i'),
        icon: await getMarkerIcon(iconurl[i], name[i], Size(100.0, 100.0)),
        //BitmapDescriptor.fromBytes(
        // dataBytes.buffer.asUint8List()
        // resizedMarkerImageBytes),
        position: loc[i],
        infoWindow: InfoWindow(title: name[i], snippet: "Coffee"),
      );
      print(name[i]);
      _markers.add(marker);
    }
    setState(() {});
  }

  GoogleMapController mapController;
  LatLng _lastMapPosition = _center;

  static LatLng _center = LatLng(24.744887, 46.696865);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _controller.complete(controller);

    LatLng latLng_1 = _center;
    LatLng latLng_2 = calculateDistane(loc, _center);
    LatLngBounds bound = LatLngBounds(southwest: latLng_1, northeast: latLng_2);

    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
    this.mapController.animateCamera(u2).then((void v) {
      check(u2, this.mapController);
    });
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    mapController.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      check(u, c);
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  initState() {
    getmarker();
    _getMyLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,

            // (controller) async {
            //   // String style = await DefaultAssetBundle.of(context)
            //   //     .loadString('assets/map_style.json');
            //   //customize your map style at: https://mapstyle.withgoogle.com/
            //   // controller.setMapStyle(style);
            //   _controller.complete(controller);
            // },
            onCameraMove: (e) => currentLocation = e.target,
            markers: _markers,
          ),
          Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: Icon(Icons.circle, color: Colors.blue[300], size: 12),
            ),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _setMarker(currentLocation),
            child: Icon(Icons.location_on),
          ),
          FloatingActionButton(
            onPressed: () => _getMyLocation(),
            child: Icon(Icons.gps_fixed),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 20,
        alignment: Alignment.center,
        child: Text(
            "lat: ${currentLocation.latitude}, long: ${currentLocation.longitude}"),
      ),
    );
  }

  void _setMarker(LatLng _location) {
    Marker newMarker = Marker(
      markerId: MarkerId(_location.toString()),
      icon: BitmapDescriptor.defaultMarker,
      // icon: _locationIcon,
      position: _location,
      infoWindow: InfoWindow(
          title: "Title",
          snippet: "${currentLocation.latitude}, ${currentLocation.longitude}"),
    );
    if (_markers.isNotEmpty) {
      // _markers.clear();
      _markers.add(newMarker);
    } else {
      _markers.add(newMarker);
    }

    setState(() {});
  }

  // Future<void> _buildMarkerFromAssets() async {
  //   if (_locationIcon == null) {
  //     // Marker(
  //     //   markerId: markerId,
  //     //   icon: BitmapDescriptor.fromBytes(dataBytes.buffer.asUint8List()),
  //     //   position: LatLng(
  //     //     lat,
  //     //     lng,
  //     //   ),
  //     //   infoWindow: InfoWindow(title: address, snippet: desc),
  //     // );
  //   }
  // }

  Future<LatLng> _frisetLocation() async {
    LocationData _myLocation = await LocationService().getLocation();
    // currentLocation =
    return LatLng(_myLocation.latitude, _myLocation.longitude);
    // print("$currentLocation" + 'llll');
  }

  Future<void> _getMyLocation() async {
    LocationData _myLocation = await LocationService().getLocation();
    currentLocation = LatLng(_myLocation.latitude, _myLocation.longitude);
    _center = LatLng(_myLocation.latitude, _myLocation.longitude);
    _animateCamera(LatLng(_myLocation.latitude, _myLocation.longitude));
  }

  Future<void> _animateCamera(LatLng _location) async {
    // LatLng latLng_1 = _location;
    // LatLng latLng_2 = calculateDistane(loc, _location);
    // LatLngBounds bound = LatLngBounds(southwest: latLng_1, northeast: latLng_2);

    // CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
    // this.mapController.animateCamera(u2).then((void v) {
    //   check(u2, this.mapController);
    // });
    final GoogleMapController controller = await _controller.future;

    CameraPosition _cameraPosition = CameraPosition(
      target: _location,
      zoom: 11.00,
    );
    // print(
    //     "animating camera to (lat: ${_location.latitude}, long: ${_location.longitude}");
    controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  LatLng calculateDistane(List<LatLng> polyline, LatLng center) {
    double distance = 0;
    double last = 0;
    LatLng lati;
    polyline.add(center);
    for (int i = 0; i < polyline.length; i++) {
      if (i < polyline.length - 1) {
        // skip the last index
        distance = getStraightLineDistance(
            polyline.last.latitude,
            polyline.last.longitude,
            polyline[i].latitude,
            polyline[i].longitude);
      }
      if (last < distance) {
        last = distance;
        lati = polyline[i];
      }
    }
    return lati;
  }

  double getStraightLineDistance(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1);
    var dLon = deg2rad(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(deg2rad(lat1)) *
            math.cos(deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = R * c; // Distance in km
    return d * 1000; //in m
  }

  dynamic deg2rad(deg) {
    return deg * (math.pi / 180);
  }
}
