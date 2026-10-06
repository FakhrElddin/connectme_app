import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectme_app/core/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Google Map Controller to control camera movements
  GoogleMapController? _mapController;

  // Set of markers to display all community members on the map
  final Set<Marker> _markers = {};

  // Loading state while requesting permission and fetching data
  bool _isLoading = true;

  // Error message if permission is denied or location services are disabled
  String? _errorMessage;

  // Default fallback location (Cairo) in case user location is unavailable
  static const LatLng _defaultLocation = LatLng(30.0444, 31.2357);

  // User's current location
  LatLng _currentLocation = _defaultLocation;

  @override
  void initState() {
    super.initState();
    // Start getting user location and loading members when screen opens
    _initMapAndLoadMembers();
  }

  /// 1. Requests location permission, gets current position,
  /// 2. Saves (latitude, longitude) to the current user's Firestore document,
  /// 3. Fetches all users from Firestore and creates markers.
  Future<void> _initMapAndLoadMembers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Step A: Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permissions are denied.';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage =
              'Location permissions are permanently denied, please enable them from settings.';
          _isLoading = false;
        });
        return;
      }

      // Step B: Get the current device GPS position
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _currentLocation = LatLng(position.latitude, position.longitude);

      // Step C: Update current user's document in Firestore with (latitude, longitude)
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
      }

      // Step D: Fetch all community members from Firestore to show their markers
      await _fetchUsersAndCreateMarkers(currentUser?.uid);

      // Step E: Move map camera to current user's position
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_currentLocation, 14.5),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load map location: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Requirement 4: Hardcoded member locations across different cities
  static const List<Map<String, dynamic>> _hardcodedMembers = [
    {
      'id': 'hardcoded_cairo',
      'name': 'Ahmed Hassan',
      'city': 'Cairo',
      'lat': 30.0430,
      'lng': 31.2370,
    },
    {
      'id': 'hardcoded_alex',
      'name': 'Sarah Mohamed',
      'city': 'Alexandria',
      'lat': 31.2001,
      'lng': 29.9187,
    },
    {
      'id': 'hardcoded_giza',
      'name': 'Karim Mostafa',
      'city': 'Giza',
      'lat': 29.9870,
      'lng': 31.2118,
    },
  ];

  /// Fetches users from Firestore and combines with hardcoded city members
  Future<void> _fetchUsersAndCreateMarkers(String? currentUserId) async {
    final Set<Marker> newMarkers = {};

    // 1. Add Requirement 4: Hardcoded members across different cities
    for (final member in _hardcodedMembers) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(member['id']),
          position: LatLng(member['lat'], member['lng']),
          infoWindow: InfoWindow(
            title: member['name'],
            snippet: member['city'],
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
      );
    }

    // 2. Add dynamic Firestore users (including current user)
    final querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    for (var doc in querySnapshot.docs) {
      final data = doc.data();

      if (data['latitude'] != null && data['longitude'] != null) {
        final double lat = (data['latitude'] as num).toDouble();
        final double lng = (data['longitude'] as num).toDouble();
        final String name = data['name'] ?? 'Community Member';
        final String city = data['city'] ?? 'Cairo';
        final bool isCurrentUser = doc.id == currentUserId;

        newMarkers.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: isCurrentUser ? 'You ($name)' : name,
              snippet: city,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              isCurrentUser
                  ? BitmapDescriptor.hueAzure
                  : BitmapDescriptor.hueViolet,
            ),
          ),
        );
      }
    }

    _markers.clear();
    _markers.addAll(newMarkers);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Loading State
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.homeBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primaryColor),
              SizedBox(height: 16),
              Text(
                'Locating community members...',
                style: TextStyle(
                  fontFamily: 'CircularStd',
                  fontSize: 15,
                  color: AppColors.darkTextColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 2. Error / Permission Denied State
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.homeBackgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_off_rounded,
                  size: 64,
                  color: AppColors.redColor,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'CircularStd',
                    fontSize: 15,
                    color: AppColors.darkTextColor,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _initMapAndLoadMembers,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 3. Map View with Markers
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 14.5,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),

          // Floating Action Button to re-center on my location
          Positioned(
            bottom: 110,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'my_location_btn',
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () {
                if (_mapController != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLngZoom(_currentLocation, 15),
                  );
                }
              },
              child: const Icon(Icons.my_location_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
