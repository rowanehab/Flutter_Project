/*import 'package:assignment1/models/models.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../cubit/homeCubit.dart';

class ServiceSearchScreen extends StatefulWidget {
  @override
  _ServiceSearchScreenState createState() => _ServiceSearchScreenState();
}

class _ServiceSearchScreenState extends State<ServiceSearchScreen> {
  List<ServiceModel>? _services = [];
  List<CompanyModel>? _companies = [];
  String? _selectedService;
  CompanyModel? _selectedCompany;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final services = await AppHomeCubit.get(context).getServices();
    final companies = await AppHomeCubit.get(context).getCompanies();
    setState(() {
      _services = services;
      _companies = companies;
    });
  }

  void _onServiceSelected(String? service) {
    setState(() {
      _selectedService = service;
      _selectedCompany = null; // Reset the selected company when a new service is selected.
    });
  }

  void _onCompanySelected(CompanyModel company) {
    setState(() {
      _selectedCompany = company;
    });
  }

  void _showCompanyLocationOnMap() {
    if (_selectedCompany != null) {
      double latitude = _selectedCompany!.latitude;
      double longitude = _selectedCompany!.longitude;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapScreen(latitude: latitude, longitude: longitude),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('Search by service', maxLines: 2),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedService,
              items: _services
                  ?.map((service) => DropdownMenuItem(
                value: service.name,
                child: Text(service.name),
              ))
                  .toList(),
              onChanged: _onServiceSelected,
              decoration: InputDecoration(
                labelText: 'Select a service',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _companies!.length,
              itemBuilder: (context, index) {
                final company = _companies![index];
                final services = _services
                    ?.where((service) =>
                service.companyId == company.id &&
                    service.name == _selectedService)
                    .toList();
                if (_selectedService != null && services!.isEmpty) {
                  return SizedBox.shrink();
                }
                return ListTile(
                  title: Text(company.name),
                  subtitle: Text(
                      'Services provided: ${services?.map((s) => s.name).join(', ')}'),
                  onTap: () {
                    _onCompanySelected(company);
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _showCompanyLocationOnMap,
            child: Text('Map'),
          ),
        ],
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapScreen({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Company Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: MarkerId('company_location'),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(title: 'Company Location'),
          ),
        },
      ),
    );
  }
}
*/