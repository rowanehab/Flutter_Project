import 'dart:js';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/models.dart';
class CompanyDetailsScreen extends StatefulWidget {
  final CompanyModel company;

  CompanyDetailsScreen({required this.company});

  @override
  _CompanyDetailsScreenState createState() => _CompanyDetailsScreenState();
}
class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  String _distance = '';
  String _duration = '';

  @override
  void initState() {
    super.initState();
    _calculateDistanceAndDuration();
  }

  Future<void> _calculateDistanceAndDuration() async {
    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Calculate distance and duration using Geolocator's distanceBetween method
    double distance = await Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        widget.company.latitude,
        widget.company.longitude);

    // Calculate duration assuming an average speed of 50 km/h
    double duration = distance / 50000;

    setState(() {
      _distance = '${distance.toStringAsFixed(2)} meters';
      _duration = '${duration.toStringAsFixed(2)} hours';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Company: ${widget.company.name}'),
            SizedBox(height: 16.0),
            Text('Distance: $_distance'),
            SizedBox(height: 16.0),
            Text('Duration: $_duration'),
          ],
        ),
      ),
    );
  }
}
void _onCompanySelected(CompanyModel company) {
  Navigator.push(
    context as BuildContext,
    MaterialPageRoute(
      builder: (context) => CompanyDetailsScreen(company: company),
    ),
  );
}
