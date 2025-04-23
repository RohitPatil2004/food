import 'package:flutter/material.dart';
import './restaurant_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/theme_service.dart';

class RestaurantSearchScreen extends StatefulWidget {
  const RestaurantSearchScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  bool _locationEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    final enabled = await LocationService.checkPermission();
    setState(() => _locationEnabled = enabled);
  }

  @override
  Widget build(BuildContext context) {
    if (!_locationEnabled) {
      return _buildLocationDisabledScreen();
    }

    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Nearby Restaurants'),
            backgroundColor: Colors.deepOrange,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          body: FutureBuilder<Position?>(
            future: LocationService.getCurrentLocation(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                  ),
                );
              }
              if (snapshot.hasError || snapshot.data == null) {
                return _buildLocationErrorScreen();
              }
              return _buildRestaurantList(snapshot.data!);
            },
          ),
        );
      },
    );
  }

  Widget _buildRestaurantList(Position position) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: LocationService.getNearbyRestaurants(position),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
            ),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return _buildErrorScreen('Failed to load restaurants');
        }

        final restaurants = snapshot.data!;
        if (restaurants.isEmpty) {
          return _buildErrorScreen('No restaurants found nearby');
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            final restaurant = restaurants[index];
            return Card(
              margin: EdgeInsets.only(bottom: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantDetailsScreen(restaurant: restaurant),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.restaurant, color: Colors.deepOrange, size: 40),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant['properties']['name'] ?? 'Unnamed Restaurant',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              restaurant['vicinity'] ?? '',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.deepOrange),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorScreen(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.deepOrange),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => setState(() {}),
            child: Text(
              'Retry',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDisabledScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 64, color: Colors.deepOrange),
          SizedBox(height: 16),
          Text(
            'Location Services Disabled',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => LocationService.openLocationSettings(),
            child: Text(
              'Enable Location',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationErrorScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: Colors.deepOrange),
          SizedBox(height: 16),
          Text(
            'Could not fetch location',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: _checkLocation,
            child: Text(
              'Retry',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}