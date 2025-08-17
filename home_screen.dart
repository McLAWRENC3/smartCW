import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  LatLng? _userLocation;
  final MapController _mapController = MapController();

  // Example incident/alert locations (replace with your real data)
  final List<LatLng> _incidentLocations = [
    LatLng(-15.4180, 28.2820),
    LatLng(-15.4205, 28.2800),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled.
      // You might want to show a dialog or something here.
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try again.
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, handle appropriately.
      return;
    }

    // Get the current position.
    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
      // Move map to user location smoothly if map controller is ready
      _mapController.move(_userLocation!, 15);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildGradientButton(String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.2 * 255).round()),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeIn,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3E8EDE), Color(0xFF00BCD4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SizedBox.expand(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.volunteer_activism,
                                  color: Colors.white),
                              tooltip: 'Donations',
                              onPressed: () {
                                Navigator.pushNamed(context, '/donations');
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.notifications,
                                  color: Colors.white),
                              tooltip: 'Emergency Alerts',
                              onPressed: () {
                                Navigator.pushNamed(context, '/alerts');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.26 * 255).round()),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            center: _userLocation ?? LatLng(-15.4167, 28.2833),
                            zoom: 13,
                            // you can add more options here like onTap if needed
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: const ['a', 'b', 'c'],
                              userAgentPackageName:
                              'com.example.smart_civic_watch',
                            ),
                            MarkerLayer(
                              markers: [
                                // User location marker (blue dot)
                                if (_userLocation != null)
                                  Marker(
                                    width: 20,
                                    height: 20,
                                    point: _userLocation!,
                                    builder: (ctx) => Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),

                                // Incident / alert markers (red pins)
                                ..._incidentLocations.map(
                                      (loc) => Marker(
                                    width: 40,
                                    height: 40,
                                    point: loc,
                                    builder: (ctx) => const Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildGradientButton('Report Incident', () {
                      Navigator.pushNamed(context, '/report');
                    }),
                    const SizedBox(height: 16),
                    _buildGradientButton('Emergency Contacts', () {
                      Navigator.pushNamed(context, '/contacts');
                    }),
                    const SizedBox(height: 16),
                    _buildGradientButton('Logout', () {
                      Navigator.pushReplacementNamed(context, '/');
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
