import 'package:assignment1/models/models.dart';
import 'package:flutter/material.dart';

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
      _selectedCompany = null; // Clear selected company when changing service
    });
  }

  void _onCompanySelected(CompanyModel company) {
    setState(() {
      _selectedCompany = company;
    });
  }

  void _showCompanyLocationOnMap() {
    if (_selectedCompany != null) {
      // TODO: Implement the logic to show the company location on the map.
      // You can use the google_maps_flutter package or any other map package for Flutter.
      // Refer to the package documentation for instructions on displaying a location on the map.
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
                  onTap: () => _onCompanySelected(company),
                );
              },
            ),
          ),
          if (_selectedCompany != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _showCompanyLocationOnMap,
                child: Text('Map'),
              ),
            ),
        ],
      ),
    );
  }
}
