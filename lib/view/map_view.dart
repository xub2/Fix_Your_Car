import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(36.9959, 127.1330); // 기본 위치
  final Location _location = Location();
  List<Marker> _markers = []; // 마커 리스트
  final String _apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';

  @override
  void initState() {
    super.initState();
    _requestLocationPermission(); // 위치 권한 요청
  }

  // 위치 권한 요청 함수
  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return; // 위치 서비스가 활성화되지 않음
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return; // 권한 거부
      }
    }
  }

  // 현재 위치로 이동
  Future<void> _currentLocation() async {
    try {
      final locationData = await _location.getLocation();
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(locationData.latitude!, locationData.longitude!),
            zoom: 15.0,
          ),
        ),
      );

      // 주변 공업사 검색
      _searchNearbyPlaces(
        locationData.latitude!,
        locationData.longitude!,
        "car_repair",
      );
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // Google Places API로 주변 공업사 검색
  Future<void> _searchNearbyPlaces(
      double latitude, double longitude, String placeType) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?key=$_apiKey&location=$latitude,$longitude&radius=5000&type=$placeType';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null) {
          List<Marker> newMarkers = [];
          for (var place in data['results']) {
            final marker = Marker(
              markerId: MarkerId(place['place_id']),
              position: LatLng(
                place['geometry']['location']['lat'],
                place['geometry']['location']['lng'],
              ),
              infoWindow: InfoWindow(
                title: place['name'],
                snippet: place['vicinity'],
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue, // 마커 색상 변경 가능
              ),
              onTap: () {
                print("Marker tapped: ${place['name']}");
              },
            );
            newMarkers.add(marker);
          }

          setState(() {
            _markers = newMarkers;
          });
        }
      } else {
        print("Failed to fetch places: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching places: $e");
    }
  }

  // Google Map 초기화
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // 위치 변경 시 자동으로 공업사 검색
    _location.onLocationChanged.listen((locationData) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(locationData.latitude!, locationData.longitude!),
            zoom: 15.0,
          ),
        ),
      );

      _searchNearbyPlaces(
        locationData.latitude!,
        locationData.longitude!,
        "car_repair",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: const Text('자동차 공업사 지도', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
        myLocationEnabled: true, // 지도에 현재 위치 표시
        myLocationButtonEnabled: true, // 기본 위치 버튼 활성화
        markers: Set<Marker>.of(_markers), // 마커 추가
      ),
    );
  }
}
