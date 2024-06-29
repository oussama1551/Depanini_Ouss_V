import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:DiPANINI/screens/about_screen.dart';
import 'package:DiPANINI/screens/home_map_screen_helptruck.dart';
import 'package:DiPANINI/screens/login_screen.dart';
import 'package:DiPANINI/screens/profile_DT_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../resource/app_colors.dart';
import '../resource/consts.dart';

class HomeMapScreen_Client extends StatefulWidget {
  const HomeMapScreen_Client({Key? key}) : super(key: key);

  @override
  State createState() => HomeMapScreen_ClientState();
}

class HomeMapScreen_ClientState extends State<HomeMapScreen_Client> {
  mapbox.MapboxMap? _mapController;
  LocationData? currentLocation;
  bool isInitialLoad = true;
  bool isPermissionGranted = false;
  bool isStyleLoaded = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _suggestions = [];
  mapbox.PolylineAnnotationManager? _polylineAnnotationManager;
  List<mapbox.Position>? _routeCoordinates;
  Timer? _navigationTimer;
  mapbox.PointAnnotationManager? _pointAnnotationManager;
  List<mapbox.PointAnnotation> helpMarkers = [];
  mapbox.PointAnnotation? _selectedHelpMarker;
  String _selectedHelpMarkerName = '';
  String _selectedHelpMarkerPhone = '';

  mapbox.PolylineAnnotation? _destinationPolyline;
  mapbox.PolylineAnnotation? _helpMarkerPolyline;
  // ignore: unused_field
  double? _helpMarkerRouteDistance;
  double? _helpMarkerRouteDuration;

  double? _routeDistance;
  double? _routeDuration;
  double? _originalRouteDistance;
  double? _originalRouteDuration;

  Map<mapbox.PointAnnotation, Map<String, String>> helpMarkerMetadata = {};
  mapbox.PointAnnotation? _destinationMarker;

  Timer? _helpMarkerTimer;
  int _helpMarkerCount = 0;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndInitializeLocation();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _requestPermissionAndInitializeLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      setState(() {
        isPermissionGranted = true;
      });
      await _getCurrentLocation();
    } else {
      _showPermissionDeniedSnackBar();
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    var location = Location();
    try {
      currentLocation = await location.getLocation();
      setState(() {});

      location.onLocationChanged.listen((LocationData loc) {
        setState(() {
          currentLocation = loc;
          if (isInitialLoad) {
            _flyToLocation(loc, zoom: 14.0);
            isInitialLoad = false;
            _startAddingHelpMarkers(); // Start adding help markers after initial load
          }
        });
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _onMapCreated(mapbox.MapboxMap controller) {
    _mapController = controller;

    // Enable user location
    _mapController!.location.updateSettings(
      mapbox.LocationComponentSettings(
        enabled: true,
      ),
    );

    _checkStyleLoaded();

    _mapController!.annotations
        .createPolylineAnnotationManager()
        .then((manager) {
      _polylineAnnotationManager = manager;
    });

    _mapController!.annotations.createPointAnnotationManager().then((manager) {
      _pointAnnotationManager = manager;
    });

    if (isInitialLoad && currentLocation != null) {
      _flyToLocation(currentLocation!, zoom: 14.0);
      setState(() {
        isInitialLoad = false;
      });
    }
  }

  Future<void> _checkStyleLoaded() async {
    if (await _mapController!.style.isStyleLoaded()) {
      print('Map style loaded');
      setState(() {
        isStyleLoaded = true;
      });
    }
  }

  void _flyToLocation(LocationData loc,
      {double zoom = 14.0, bool setDestinationMarker = false}) async {
    if (_mapController != null &&
        loc.latitude != null &&
        loc.longitude != null) {
      final point = mapbox.Point(
        coordinates: mapbox.Position(loc.longitude!, loc.latitude!),
      );

      _mapController!.flyTo(
        mapbox.CameraOptions(
          center: point,
          zoom: zoom,
        ),
        mapbox.MapAnimationOptions(
          duration: 1500,
        ),
      );

      if (setDestinationMarker) {
        final ByteData destinationMarkerBytes =
            await rootBundle.load('assets/marker-des.png');
        final Uint8List destinationMarkerImageData = await _resizeImage(
            destinationMarkerBytes.buffer.asUint8List(), 60, 60);

        final destinationMarker = mapbox.PointAnnotationOptions(
          geometry: point,
          image: destinationMarkerImageData,
        );

        await _pointAnnotationManager!.create(destinationMarker);
      }
    } else {
      print('Map controller is not initialized or location data is null.');
    }
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      _getSuggestions(_searchController.text);
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

  Future<void> _getSuggestions(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=pk.eyJ1Ijoib3Vzc2FtYTE1NTExIiwiYSI6ImNseGJ2eTZxMjAyNGsya3M1c2hiM2tsemQifQ.XiDdZI0tbyFJn651smkaCg'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _suggestions = data['features'];
        });
      } else {
        throw Exception('Failed to load suggestions');
      }
    } catch (e) {
      print('Error getting suggestions: $e');
    }
  }

  void _onSuggestionSelected(dynamic suggestion) async {
    final coordinates = suggestion['geometry']['coordinates'];
    final location = LocationData.fromMap({
      'latitude': coordinates[1],
      'longitude': coordinates[0],
    });
    _searchController.text = suggestion['place_name'];

    // Remove existing destination marker
    if (_destinationMarker != null && _pointAnnotationManager != null) {
      _pointAnnotationManager!.delete(_destinationMarker!);
      _destinationMarker = null; // Clear the destination marker variable
    }

    // Hide the keyboard
    FocusScope.of(context).unfocus();

    _flyToLocation(location);
    await _drawRoute(location, useDestinationMarker: true);

    setState(() {
      _suggestions = [];
    });
  }

  Future<void> _drawRoute(LocationData destination,
      {bool useDestinationMarker = false,
      bool isHelpMarkerRoute = false}) async {
    if (currentLocation == null) return;

    final url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/${currentLocation!.longitude},${currentLocation!.latitude};${destination.longitude},${destination.latitude}?geometries=geojson&access_token=pk.eyJ1Ijoib3Vzc2FtYTE1NTExIiwiYSI6ImNseGJ2eTZxMjAyNGsya3M1c2hiM2tsemQifQ.XiDdZI0tbyFJn651smkaCg';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['routes'][0]['geometry']['coordinates'];
      final distance = data['routes'][0]['distance'];
      final duration = data['routes'][0]['duration'];

      final List<mapbox.Position> coordinates = [];
      for (var point in route) {
        coordinates.add(mapbox.Position(point[0], point[1]));
      }

      final polyline = mapbox.PolylineAnnotationOptions(
        geometry: mapbox.LineString(
          coordinates: coordinates,
        ),
        lineColor: isHelpMarkerRoute ? Colors.red.value : Colors.blue.value,
        lineWidth: 4.0,
      );

      if (isHelpMarkerRoute) {
        // Remove existing help marker polyline before adding a new one
        if (_helpMarkerPolyline != null) {
          _polylineAnnotationManager!.delete(_helpMarkerPolyline!);
        }
        _helpMarkerPolyline =
            await _polylineAnnotationManager!.create(polyline);
        setState(() {
          _helpMarkerRouteDistance = distance / 1000; // Convert to kilometers
          _helpMarkerRouteDuration = duration / 60; // Convert to minutes
        });
      } else {
        // Remove existing destination polyline before adding a new one
        if (_destinationPolyline != null) {
          _polylineAnnotationManager!.delete(_destinationPolyline!);
        }
        _destinationPolyline =
            await _polylineAnnotationManager!.create(polyline);
        setState(() {
          _routeDistance = distance / 1000; // Convert to kilometers
          _routeDuration = duration / 60; // Convert to minutes
          _originalRouteDistance = _routeDistance;
          _originalRouteDuration = _routeDuration;
          _routeCoordinates = route
              .map<mapbox.Position>(
                  (point) => mapbox.Position(point[0], point[1]))
              .toList();
        });
      }

      // Add destination marker
      if (useDestinationMarker) {
        final ByteData destinationMarkerBytes =
            await rootBundle.load('assets/marker-des.png');
        final Uint8List destinationMarkerImageData = await _resizeImage(
            destinationMarkerBytes.buffer.asUint8List(), 60, 60);

        final point = mapbox.Point(
          coordinates:
              mapbox.Position(destination.longitude!, destination.latitude!),
        );

        final destinationMarkerOptions = mapbox.PointAnnotationOptions(
          geometry: point,
          image: destinationMarkerImageData,
        );

        _destinationMarker =
            await _pointAnnotationManager!.create(destinationMarkerOptions);
      }
    } else {
      print('Failed to fetch route: ${response.statusCode}');
    }
  }

  Future<Uint8List> _resizeImage(Uint8List data, int width, int height) async {
    final img.Image? image = img.decodeImage(data);
    if (image != null) {
      final img.Image resized =
          img.copyResize(image, width: width, height: height);
      return Uint8List.fromList(img.encodePng(resized));
    }
    return data;
  }

  Future<void> _addHelpMarkers(LocationData loc) async {
    if (_mapController == null) return;

    final ByteData helpMarkerBytes = await rootBundle.load('assets/marker.png');
    final Uint8List helpMarkerImageData =
        await _resizeImage(helpMarkerBytes.buffer.asUint8List(), 60, 60);

    // Fetch Driver Help Truck data from Firestore
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('user_type', isEqualTo: 'Driver Help Truck')
        .get();

    final double lat = loc.latitude!;
    final double lng = loc.longitude!;
    final Random random = Random();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      final driverData = doc.data() as Map<String, dynamic>;
      final String driverName = driverData['full_name'];
      final String driverPhone = driverData['phone_number'];

      final double distance =
          (random.nextDouble() * 10) + 1; // Distance between 1 and 10 km
      final double angle = random.nextDouble() * 2 * pi;
      final double offsetLat =
          lat + (distance / 111) * cos(angle); // 1 degree latitude ~ 111 km
      final double offsetLng = lng +
          (distance / (111 * cos(lat * pi / 180))) *
              sin(angle); // Adjust for longitude

      final point = mapbox.Point(
        coordinates: mapbox.Position(offsetLng, offsetLat),
      );

      final marker = mapbox.PointAnnotationOptions(
        geometry: point,
        image: helpMarkerImageData,
      );

      final createdMarker = await _pointAnnotationManager!.create(marker);

      // Store marker data for info display
      helpMarkers.add(createdMarker);
      helpMarkerMetadata[createdMarker] = {
        'name': driverName,
        'phone': driverPhone
      };
    }
  }

  void _checkForMarkerTap(mapbox.Point point) {
    const double tapThreshold = 0.01; // Adjust as needed

    for (var marker in helpMarkers) {
      final markerLat = marker.geometry.coordinates.lat;
      final markerLng = marker.geometry.coordinates.lng;

      if ((point.coordinates.lat - markerLat).abs() < tapThreshold &&
          (point.coordinates.lng - markerLng).abs() < tapThreshold) {
        setState(() {
          _selectedHelpMarker = marker;
          _selectedHelpMarkerName =
              helpMarkerMetadata[marker]?['name'] ?? 'Unknown';
          _selectedHelpMarkerPhone =
              helpMarkerMetadata[marker]?['phone'] ?? 'Unknown';
        });
        _drawRoute(
            LocationData.fromMap({
              'latitude': markerLat,
              'longitude': markerLng,
            }),
            isHelpMarkerRoute: true);
        break;
      }
    }
  }

  void _startNavigation() {
    if (_routeCoordinates != null && _routeCoordinates!.isNotEmpty) {
      int i = 0;
      _navigationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (i < _routeCoordinates!.length) {
          final point = _routeCoordinates![i];
          _flyToLocation(
            LocationData.fromMap({
              'latitude': point.lat,
              'longitude': point.lng,
            }),
          );
          setState(() {
            _routeDistance =
                _routeDistance! - (_routeDistance! / _routeCoordinates!.length);
            _routeDuration =
                _routeDuration! - (_routeDuration! / _routeCoordinates!.length);
          });
          i++;
        } else {
          timer.cancel();
        }
      });
    }
  }

  void _stopNavigation() {
    if (_navigationTimer != null) {
      _navigationTimer!.cancel();
      _navigationTimer = null;
      if (currentLocation != null) {
        _flyToLocation(currentLocation!, zoom: 14.0);
        setState(() {
          _routeDistance = _originalRouteDistance;
          _routeDuration = _originalRouteDuration;
        });
      }
    }
  }

  void _showPermissionDeniedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location permission is required to use this feature.'),
      ),
    );
  }

  void _startAddingHelpMarkers() {
    _helpMarkerCount = 0;
    _helpMarkerTimer?.cancel();
    _helpMarkerTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      if (_helpMarkerCount < 1 && currentLocation != null) {
        await _addHelpMarkers(currentLocation!);
        _helpMarkerCount++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _stopNavigation(); // Stop navigation if the widget is disposed
    _helpMarkerTimer
        ?.cancel(); // Cancel the help marker timer if the widget is disposed
    super.dispose();
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search Destination",
          hintStyle: const TextStyle(
              fontSize: 12,
              color: AppColors.hinttextGGColor,
              fontFamily: 'Poppins'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(
              style: BorderStyle.none,
              width: 1.0,
            ),
          ),
          filled: true,
          fillColor: AppColors.whiteColor,
          contentPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.015,
            horizontal: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsList(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          color: Colors.white,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = _suggestions[index];
              return ListTile(
                title: Text(
                  suggestion['place_name'],
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                onTap: () => _onSuggestionSelected(suggestion),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRouteInfo(BuildContext context) {
    if (_routeDistance != null && _routeDuration != null) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(130, 27, 15, 158),
              blurRadius: 8.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Text(
                'Distance: ${_routeDistance!.toStringAsFixed(2)} km, Duration: ${_routeDuration!.toStringAsFixed(2)} mins',
                style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: const Divider(
                thickness: 3.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
                vertical: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Paiment Expected : ',
                      style: TextStyle(
                          color: AppColors.primColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold)),
                  Text('${(_routeDistance! * 80).toStringAsFixed(2)} DA',
                      style: const TextStyle(
                          color: AppColors.blackColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Future<void> _sendNotification() async {
    if (_selectedHelpMarker == null) return;

    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'driverId': _selectedHelpMarker!.id,
        'clientId': FirebaseAuth.instance.currentUser!.uid,
        'message': 'You have a new request from ${_selectedHelpMarkerName}',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification sent to driver!')),
      );

      setState(() {
        _selectedHelpMarker = null; // Clear the selected marker
      });
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification sent to driver!')),
      );
      _selectedHelpMarker = null;
    }
  }

  Widget _buildHelpMarkerInfo(BuildContext context) {
    if (_selectedHelpMarker == null || _helpMarkerRouteDuration == null)
      return Container();

    return Positioned(
      top: MediaQuery.of(context).size.height * 0.25,
      left: MediaQuery.of(context).size.width * 0.05,
      right: MediaQuery.of(context).size.width * 0.05,
      child: Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(130, 27, 15, 158),
              blurRadius: 8.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Truck Helper Info, arriving in ${_helpMarkerRouteDuration!.toStringAsFixed(2)} mins',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Image.asset(imP),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _selectedHelpMarkerName,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _selectedHelpMarkerPhone,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 60),
                Image.asset(imcall),
                const SizedBox(width: 10),
                Image.asset(immess)
              ],
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              child: const Column(
                children: [
                  const Row(
                    children: [
                      Text('Statut : ',
                          style: TextStyle(
                              color: AppColors.primColor,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold)),
                      Text('Available',
                          style: TextStyle(
                              color: Color.fromARGB(255, 32, 178, 105),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(82, 214, 214, 214),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  child: Row(
                    children: [
                      Image.asset(imcash),
                      const SizedBox(
                        width: 12,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cash',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Change Payment method',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 170, 167, 167)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      const Icon(Icons.navigate_next_rounded)
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedHelpMarker = null;
                    });
                  },
                  child: Text(
                    'Profile',
                    style: TextStyle(color: AppColors.primColor),
                  ),
                ),
                ElevatedButton(
                  onPressed: _sendNotification,
                  child: Text(
                    'Send',
                    style: TextStyle(color: AppColors.primColor),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedHelpMarker = null;
                    });
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: AppColors.primColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    thickness: 3.0,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: AppColors.primColor,
                    ),
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Home',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                        Icon(Icons.navigate_next_rounded)
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(
                    thickness: 3.0,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: AppColors.primColor,
                    ),
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Account',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                        Icon(Icons.navigate_next_rounded)
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreenDT()),
                      );
                    },
                  ),
                  const Divider(
                    thickness: 3.0,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.history,
                      color: AppColors.primColor,
                    ),
                    title: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'history',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                        Icon(Icons.navigate_next_rounded)
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(
                    thickness: 3.0,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.feedback,
                      color: AppColors.primColor,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Feedback',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(Icons.navigate_next_rounded)
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(
                    thickness: 3.0,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person_add_alt_1,
                      color: AppColors.primColor,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Invite',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(Icons.navigate_next_rounded)
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(
                    thickness: 3.0,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.list,
                      color: AppColors.primColor,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Terms and Conditions',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(Icons.navigate_next_rounded)
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(
                    thickness: 3.0,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.privacy_tip,
                      color: AppColors.primColor,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Privacy Policy',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(Icons.navigate_next_rounded)
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(
                    thickness: 3.0,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.info,
                      color: AppColors.primColor,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'About',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(Icons.navigate_next_rounded)
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutScreen()),
                      );
                    },
                  ),
                  const Divider(
                    thickness: 3.0,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.language,
                      color: AppColors.primColor,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Langue',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(Icons.navigate_next_rounded)
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.swap_horizontal_circle_sharp,
                      color: AppColors.primColor,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Switch to Driver Help ',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(Icons.navigate_next_rounded)
                      ],
                    ),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeMapScreen_Driver_Help()),
                      );
                    },
                  ),
                  const Divider(
                    thickness: 3.0,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: AppColors.primColor,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Logout',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                        const Icon(Icons.navigate_next_rounded)
                      ],
                    ),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login_Screen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
            child: isPermissionGranted
                ? mapbox.MapWidget(
                    onMapCreated: _onMapCreated,
                    onTapListener: (context) {
                      _checkForMarkerTap(context.point);
                    },
                  )
                : Center(
                    child: Text(
                      'Location permission is required to use this feature.',
                    ),
                  ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.135,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            child: Column(
              children: [
                _buildRouteInfo(context),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.primBackg,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(82, 18, 40, 169),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Where do you want the truck to take you?",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.textGGColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    _buildSearchBar(context),
                  ],
                ),
              ),
              if (_suggestions.isNotEmpty) _buildSuggestionsList(context),
            ],
          ),
          if (_selectedHelpMarker != null) _buildHelpMarkerInfo(context),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.04,
                    bottom: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: FloatingActionButton(
                    onPressed: () async {
                      if (currentLocation != null) {
                        _flyToLocation(currentLocation!, zoom: 14.0);
                      } else {
                        await _getCurrentLocation();
                        if (currentLocation != null) {
                          _flyToLocation(currentLocation!, zoom: 14.0);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Unable to fetch current location.'),
                            ),
                          );
                        }
                      }
                    },
                    child: const Icon(Icons.my_location),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.012),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.04,
                    bottom: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: FloatingActionButton(
                    onPressed: _startNavigation,
                    child: const Icon(Icons.navigation),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.012),
                Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.04,
                    bottom: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: FloatingActionButton(
                    onPressed: _stopNavigation,
                    child: const Icon(Icons.stop),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
