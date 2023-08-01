
import 'dart:convert';
import 'dart:math';

import 'package:assignment1/screens/abstract.dart';
import 'package:assignment1/screens/cubit/states.dart';
import 'package:assignment1/screens/home/distance_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;
import '../../models/models.dart';
import '../home/service_profile.dart';
import '../home/edit_screen.dart';
import '../home/favorites_screen.dart';
import '../home/sevices_screen.dart';
import '../home/specific_company_services_screen.dart';

class AppHomeCubit extends Cubit<AppStates> {
  AppHomeCubit() : super(AppHomeInitialState());

  static AppHomeCubit get(context) => BlocProvider.of(context);

  ///////////////////////////////////////////////////////////////
  List<Widget> screens = [
    ServicesScreen(),
    MyFavouriteServiceScreen(),
    SpecificCompanyServicesScreen(),
    DistanceCalculatorScreen(),
    EditScreen(),
  ];

  int currentIndex = 0;

  List<String> titles = [
    'Home',
    'Favorites',
    'Services',
    'Distance',
    'Profile'
  ];

  void changeNavBar(index) {
    currentIndex = index;
    emit(AppHomeChangeNavBarState());
  }

// favorite screen


  void changeFavourite(ServiceModel model) {
    try {
      model.isFavourite = !model.isFavourite;
      print('Is Favorite : ${model.isFavourite}');
      emit(AppChangeFavState());
    } catch (e) {
      print(e.toString());
    }
  }

//////////////////////////////////////////////////////////////


  late List<ServiceModel> serviceModel = [
    ServiceModel(
      companyId: 1,
        name: 'Charging Mobile',
        price: 5.5,
        isFavourite: true,
        description: "Description of service 1",
        companyName: "DEF Inc.",

    ),
    ServiceModel(
        companyId: 1,
        name: 'Service A',
        price: 35,
        isFavourite: true,
        description: "Description of service 2",
        companyName: "DEF Inc.",
    ),
    ServiceModel(
        companyId: 63,
        name: 'Service d',
        price: 700,
        isFavourite: true,
        description: "Description of service d",
        companyName: "DEF Inc.",
    ),
    ServiceModel(
        companyId: 64,
        name: 'Jo service ',
        price: 150,
        isFavourite: true,
        description: "Description of service 4",
        companyName:  "DEF Inc.",
    ),

  ];


// business services for a specific company

  // getServices();


  var companies = [
    'Orascom',
    'Vodafone',
    'We',
  ];

  String selectedCompanyName ="";
  void selectSpecificCompany(newValue) {
    // selectedCompany?.name = newValue ;
    emit(AppSelectCompanyState());
  }
  void saveName(String name){
    selectedCompanyName = name;
    print(selectedCompanyName);
    emit(AppSelectCompanyState());
  }
   int counter = 0;
  void incrementCounter(){
    counter+=1;
  }
  void startCounter(){
    counter = 0;
  }
  int countCompanyServices(CompanyModel companyModel){
    return companyModel.services!.length;
  }
  List<CompanyModel> companyModel = [
    CompanyModel(
      id: 50,
      name: 'Vodafone',
      services: [
        ServiceModel(
          companyId: 50,
          name: 'Service 1',
            price: 250,
            isFavourite: true,
            description: "Description of service 1",
          companyName: 'Vodafone',

        ),
        ServiceModel(
          companyId: 50,
            name: 'Service 2',
            price: 0,
            isFavourite: true,
            description: "Description of service 2",
           companyName: 'Vodafone',
        ),
      ],
      description: "Description of Vodafone company "

    ),
    CompanyModel(
        id: 51,
      name: 'Orascom',
      services: [
        ServiceModel(
          companyId: 51,
            name: 'Service 3',
            price: 250,
            isFavourite: true,
            description: "Description of service 3",
          companyName: 'Orascom',
        ),
        ServiceModel(
          companyId: 51,
            name: 'Service 4',
            price: 0,
            isFavourite: true,
            description: "Description of service 4",
          companyName: 'Orascom',
        ),
      ],
        description: "Description of Orascom company "
    ),
    CompanyModel(
        id: 52,
      name: 'We',
        services: [
          ServiceModel(
            companyId: 52,
              name: 'Service 5',
              price: 250,
              isFavourite: true,
              description: "Description of service 5",
            companyName: 'We',
          ),
          ServiceModel(
            companyId: 52,
              name: 'Service 6',
              price: 0,
              isFavourite: true,
              description: "Description of service 6",
            companyName: 'We',
          ),
        ],
        description: "Description of We company "

    ),
  ];
  void changeCompanyServiceFavourite(CompanyModel model) {
    try {
      model.services![counter].isFavourite = !model.services![counter].isFavourite;
      print('Is Favorite : ${model.services![counter].isFavourite}');
      emit(AppChangeCompanyServiceFavState());
    } catch (e) {
      print(e.toString());
    }
  }
  ServiceModel? selctedService;
  navigateToTheService(ServiceModel model,context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceInfoScreen()));
  }
/////////////////////////////////////////////////////////////////
  var addServiceFormKey = GlobalKey<FormState>();
  var serviceNameController = TextEditingController();
  var serviceDescriptionController = TextEditingController();
  var priceController = TextEditingController();
  void validateAdd(serviceData,context) {
    if (addServiceFormKey.currentState!.validate()) {
      // backend
      addService(serviceData,context);
      print('Addition success');
      emit(AppDisplayServicesState());
    } else {
      print('Addition fail');
      emit(AppFailureAddState());
    }
  }
  bool yesSelected = false;
  bool noSelected = false;
  void changeYesRadio(value){
    yesSelected = value;
    noSelected = !value;
    emit(AppChangeRadioState());
  }
  void changeNoRadio(value){
    noSelected = value;
    yesSelected = !value;
    emit(AppChangeRadioState());
  }
  Future<List<ServiceModel>> getServicesByCompany(int id) async {
    var response = await http.get(
        Uri.parse('https://rky-apis.000webhostapp.com/api/companies/$id/services'));
    if (response.statusCode == 200) {
        var servicesInJson = json.decode(response.body);
        List<ServiceModel> services = [];
        for (var serviceJson in servicesInJson['data']) {
            ServiceModel service = ServiceModel(
              name: serviceJson['name'],
              price: double.parse(serviceJson['price'].toString()),
              isFavourite: true /*serviceJson['isFavourite']*/,
              description: serviceJson['description'],
              companyId: serviceJson['company']['id'],
            );
            services.add(service);

        }
        emit(AppSuccusfulReturnServicesState());
        return services;
      } else {
        throw Exception('Failed to load services');
      }


  }
  Future<List<ServiceModel>> getServicesByCompanyName(String name) async {
    var response = await http.get(
        Uri.parse('https://rky-apis.000webhostapp.com/api/companies/$name/services'));
    if (response.statusCode == 200) {
      var servicesInJson = json.decode(response.body);
      List<ServiceModel> services = [];
      for (var serviceJson in servicesInJson['data']) {
        ServiceModel service = ServiceModel(
          name: serviceJson['name'],
          price: double.parse(serviceJson['price'].toString()),
          isFavourite: true /*serviceJson['isFavourite']*/,
          description: serviceJson['description'],
          companyId: serviceJson['company']['id'],
        );
        services.add(service);
      }
      emit(AppSuccusfulReturnServicesState());
      return services;
    } else {
      throw Exception('Failed to load services');
    }


  }
  int specificCompanyId=1;
  saveId(id){
    specificCompanyId = id;
  }
  Future<List<CompanyModel>> getCompanies() async {
    var response = await http.get(
        Uri.parse('https://rky-apis.000webhostapp.com/api/companies/all'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization' : 'Bearer 47|RTIVVxywwxUYSIo4c81BPEqa8mV6K3H3BCh2FerJ',
      },
    );

    if (response.statusCode == 200) {
      var companiesInJson = json.decode(response.body);
      // var token = companiesInJson['token'];
      List<CompanyModel> companies = [];
      for (var companyJson in companiesInJson['data']) {
        CompanyModel company = CompanyModel(
          id: companyJson['id'],
          name: companyJson['company_name'],
          description: companyJson['company_industry'],

        );
        companies.add(company);
      }
      emit(AppSuccusfulReturnCompaniesState());
      return companies;
    } else {
      throw Exception('Failed to load companies');
    }

  }


  Future<List<ServiceModel>> getServices() async {
      var response = await http.get(
          Uri.parse('https://rky-apis.000webhostapp.com/api/services'));
      if (response.statusCode == 200) {
        var servicesInJson = json.decode(response.body);
        List<ServiceModel> services = [];
        for (var serviceJson in servicesInJson['data']) {
          ServiceModel service = ServiceModel(
            name: serviceJson['name'],
            price: double.parse(serviceJson['price'].toString()),
            isFavourite: true,
            description: serviceJson['description'],
            companyId: serviceJson['company']['id'],
          );
          insertServicesToDataBase(service: service);
          services.add(service);
        }
        emit(AppSuccusfulReturnServicesState());
        return services;
      } else {
        throw Exception('Failed to load services');
      }

  }
  Future<void> addService(serviceData,context) async {
    // Create the request body
    var host = "https://rky-apis.000webhostapp.com";

    // Step 1: Make the second request
    var addServiceResponse = await post(
      Uri.parse('https://rky-apis.000webhostapp.com/api/services'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(serviceData),
    );

    if (addServiceResponse.statusCode == 201) {
      var parsedResponse = json.decode(addServiceResponse.body);
      var token = parsedResponse['token']; // Extract the user ID
      var serviceId = parsedResponse['id'];
      print('Service: $parsedResponse');
      print('Add successful');
      emit(AppSuccessfulAddState());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Abstract()));

    } else {
      var x = jsonDecode(addServiceResponse.body);
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Row(
              children: const [
                Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Add Failed",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            content: Text(x['message'].toString().replaceFirst(
                x['message'][0], x['message'][0].toUpperCase())),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'))
            ],
          ));
      print('Add failed: ${addServiceResponse.body}');
      // Handle signup failure
    }
  }

  late Future<List<ServiceModel>> servicesFuture;
  late Future<List<ServiceModel>> servicesFromCompanyFuture;
  late Future<List<CompanyModel>> companiesFuture;
  void initStateOfGettingServices(){
    servicesFuture = getServices();
  }
  void initStateOfGettingCompanines(){
    companiesFuture = getCompanies();
  }
  // void initStateOfGettingServicesFromCompany(id){
  //   getServicesByCompany(id).then((value) {
  //     servicesFromCompanyFuture =value;
  //   });
  // }
  ////////////////////////////////////////////////////////////////
// Distance screen
  String locationMessage = 'Current location of the company';
  Position? currentPosition;
  late double lat;
  late double long;
  var llatController = TextEditingController();
  var longController = TextEditingController();

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabeld');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
    emit(AppSuccessfulGetLocationState());
    return await Geolocator.getCurrentPosition();
  }

  Future<void> openMap(String lat, String long) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : "Couldn't launch";
  }

  void liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  double calculateDistance(businessLat,businessLong) {
    if (currentPosition == null) {
      return 0.0;
    }
    const double earthRadius = 6371.0; // km
    final double lat1 = currentPosition!.latitude;
    final double lon1 = currentPosition!.longitude;
    final double lat2 = businessLat;
    final double lon2 = businessLong;

    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            pow(sin(dLon / 2), 2);
    final double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }

   void getCurrentPosition(){
     getCurrentLocation().then((value) {
       currentPosition = value;
       lat = value.latitude;
       long = value.longitude;
       latController.text = lat.toString();
       longController.text = long.toString();
       locationMessage = 'Latitude: $lat,\nLongitude: $long';
       emit(AppSuccessfulGetLocationState());
       // liveLocation();
     });
   }
  Future<List<Placemark>?> getPlacemarks(String address) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      return placemarks;
    } catch (error) {
      print(error);
      return null;
    }
  }
  Future<void> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      String address = placemarks[0].name! + ", " + placemarks[0].locality! + ", " + placemarks[0].country!;
      print(address);
    } catch (err) {
      print(err);
    }
  }




  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();
  double? distance;
  List<Placemark>? placemarks;
  String? streetAddress;
  String? city;
  String? cstate;
  String? country;
  Future<void> calculateDistanceee() async {
    Position currentPosition = await Geolocator.getCurrentPosition();
    double startLatitude = currentPosition.latitude;
    double startLongitude = currentPosition.longitude;
    double endLatitude = double.parse(latController.text.trim());
    double endLongitude = double.parse(lngController.text.trim());

    distance = await Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
    print(distance);

  }
  void display(){
    calculateDistanceee().then((value) {
      emit(AppSuccessfulCalculateDistanceState());
    });
  }
  Future<void> getAddress() async {
    double latitude = double.parse(latController.text.trim());
    double longitude = double.parse(lngController.text.trim());
    placemarks = await placemarkFromCoordinates(latitude, longitude);

    streetAddress = placemarks![0].thoroughfare;
     city = placemarks![0].locality;
     cstate = placemarks![0].administrativeArea;
    country = placemarks![0].country;

    print('$streetAddress, $city, $cstate, $country');
  }
  void displayAddress(){
    getAddress().then((value) {
      emit(AppSuccessfulGetAddressState());
    });
  }


  late Database database;
  List<Map> addedServices = [];

  void createServicesInDataBase() {
    openDatabase(
      'app1.db',
      version: 1,
      onCreate: (database, version) async {
        print('database created');
        await database.execute(
            'CREATE TABLE services (id INTEGER PRIMARY KEY, name TEXT,description TEXT, price TEXT)');
        print('Table services created');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertServicesToDataBase(
      {
        required ServiceModel service,
      }) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO services(name,description,price) VALUES("${service.name}","${service.description}","${service.price}")')
          .then((value) {
        print('$value Inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database).then((value) {
          addedServices = value;
          print('Services in local DB: $addedServices');
        });
      }).catchError((error) {
        print('Error when inserting new record ${error.toString()}');
      });
      return Future(() => null);
    });
  }
  Future<List<Map>> getDataFromDatabase(database) async {
    // newAccounts=[];
    // emit(AppGetDatbaseLoadingState());

    return await database.rawQuery('SELECT * FROM services');
  }
///////////////////////////////////////////////////////////////
}


