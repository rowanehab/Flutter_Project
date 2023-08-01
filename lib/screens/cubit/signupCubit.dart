// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:assignment1/models/models.dart';
import 'package:assignment1/screens/cubit/homeCubit.dart';
import 'package:assignment1/screens/cubit/states.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect/multiselect.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../components/components.dart';
import '../../components/screen_size.dart';
import '../abstract.dart';
import '../home/edit_screen.dart';
import 'package:http/http.dart';
import 'loginCubit.dart';

class AppSignupCubit extends Cubit<AppStates> {
  AppSignupCubit() : super(AppSignupInitialState());

  static AppSignupCubit getSignup(context) => BlocProvider.of(context);

  // Sign up
  var companyNameController = TextEditingController();

  var companyAddressController = TextEditingController();

  var contactPersonNameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var confirmPasswordController = TextEditingController();

  var contactPersonMobileNumberController = TextEditingController();

  int companyId = 2;
  static int getCompanyId(companyId){
    return companyId;
  }
  String userToken = "";

  var items = [
    'Micro',
    'Small',
    'Mini',
    'Large',
  ];

  String selectedCompanySize = 'Micro';
  var latController = TextEditingController();
  var longController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  String? gender;
  int currentRole = 1;
  int currentStep = 0;
  List<String> industries = [
    'Manufacturing',
    'Production',
    'Technology',
    'Retail',
    'Construction',
    'Marketing',
    'Trade',
    'Food industry',
    'Education',
    'Economics',
    'Accounting'
  ];
  List<String> selectedIndustries = [];
  bool isChecked = false;

  void changeCheckbox(value) {
    isChecked = value;
    emit(AppChangeCheckboxState());
  }

  void selectCompanySize(newValue) {
    selectedCompanySize = newValue;
    emit(AppSelectCompanySizeState());
    // widget.onCompanySizeChanged(selectedCompanySize);
  }

  void selectIndustry(value) {
    print('selected industry $value');
    selectedIndustries = value;
    print('you have selected $selectedIndustries industries.');
  }

  List<Step> getSteps() => [
        Step(
          isActive: currentStep >= 0,
          title: const Text(
            'Company',
            style: TextStyle(fontSize: 12),
          ),
          content: Form(
            key: formKeys[0],
            child: Column(
              children: [
                TextFieldComponent(
                  label: 'Company Name',
                  controller: companyNameController,
                  keyType: TextInputType.text,
                  picon: const Icon(Icons.home_work_outlined),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please enter company name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: ScreenSize.screenHeight * 0.02,
                ),
                TextFieldComponent(
                  label: 'Company Address',
                  controller: companyAddressController,
                  keyType: TextInputType.text,
                  picon: const Icon(Icons.add_home_outlined),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please enter company address';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: ScreenSize.screenHeight * 0.02,
                ),
                DropDownMultiSelect(
                  options: industries,
                  selectedValues: selectedIndustries,
                  onChanged: (value) {
                    selectIndustry(value);
                    emit(AppChooseIndustryState());
                  },
                  whenEmpty: 'Company industry',
                ),
                SizedBox(
                  height: ScreenSize.screenHeight * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Company Size',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  iconSize: 20,
                  isExpanded: true,
                  // Initial Value
                  value: selectedCompanySize.isNotEmpty
                      ? selectedCompanySize
                      : null,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (newValue) {
                    selectCompanySize(newValue);
                  },
                ),
                SizedBox(
                  height: ScreenSize.screenHeight * 0.02,
                ),
                Text(
                  locationMessage.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: ScreenSize.screenHeight * 0.01,
                ),
                defaultButton(
                  text: 'Get current location',
                  onpressed: () {
                    getCurrentLocation().then((value) {
                      currentPosition = value;
                      lat = '${value.latitude}';
                      long = '${value.longitude}';
                      latController.text = lat;
                      longController.text = long;
                      locationMessage = 'Latitude: $lat,\nLongitude: $long';
                      // liveLocation();
                      emit(AppSuccessfulGetLocationState());
                    });
                  },
                ),
                // defaultButton(text: 'Open Google Map', onpressed: (){openMap(lat,long);})
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 1,
          title: const Text(
            'Required info',
            style: TextStyle(fontSize: 12),
          ),
          content: Form(
            key: formKeys[1],
            child: Column(
              children: [
                TextFieldComponent(
                  label: 'Contact Person Name',
                  controller: contactPersonNameController,
                  keyType: TextInputType.text,
                  picon: const Icon(Icons.person_outline),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please enter contact person name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: ScreenSize.screenHeight * 0.02,
                ),
                TextFieldComponent(
                  label: 'Contact Person Phone Number',
                  controller: contactPersonMobileNumberController,
                  keyType: TextInputType.phone,
                  picon: const Icon(Icons.call),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please enter your phone number';
                    } else if (contactPersonMobileNumberController
                            .text.length !=
                        11) {
                      return "please enter valid number";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: ScreenSize.screenHeight * 0.02,
                ),
                TextFieldComponent(
                  label: 'Email',
                  controller: emailController,
                  keyType: TextInputType.emailAddress,
                  picon: const Icon(Icons.email_outlined),
                  validator: (value) {
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]")
                        .hasMatch(value);
                    if (value.isEmpty) {
                      return 'please enter your email';
                    } else if (!emailValid) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: ScreenSize.screenHeight * 0.02,
                ),
                TextFieldComponent(
                  label: 'Password',
                  controller: passwordController,
                  isPassword: true,
                  picon: const Icon(Icons.lock_outline_rounded),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please enter your password';
                    } else if (passwordController.text.length < 8) {
                      return "Password should be more than 8 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: ScreenSize.screenHeight * 0.02,
                ),
                TextFieldComponent(
                  label: 'Confirm Password',
                  controller: confirmPasswordController,
                  isPassword: true,
                  picon: const Icon(Icons.lock_outline_rounded),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please enter the confirm password';
                    }
                    if (value != passwordController.text) {
                      return 'The confirm password must be the same password';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: ScreenSize.screenHeight * 0.02,
                ),
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 2,
          title: const Text(
            'Complete',
            style: TextStyle(fontSize: 12),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Company name: ',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                companyNameController.text,
                style: const TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: ScreenSize.screenHeight * 0.02,
              ),
              const Text(
                'Contact person name: ',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                contactPersonNameController.text,
                style: const TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: ScreenSize.screenHeight * 0.02,
              ),
              const Text(
                'Contact person number: ',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                contactPersonMobileNumberController.text,
                style: const TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: ScreenSize.screenHeight * 0.02,
              ),
              const Text(
                'Email: ',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                emailController.text,
                style: const TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: ScreenSize.screenHeight * 0.02,
              ),
            ],
          ),
        ),
      ];

  String locationMessage = 'Current location of the company';
  Position? currentPosition;
  late String lat;
  late String long;

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
      lat = position.latitude.toString();
      long = position.longitude.toString();
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





  void continueStep(context) {
    if (currentStep == getSteps().length - 1) {
      print('Completed');
      var firstScreenData = {
        "company_name": companyNameController.text,
        "company_industry": industries,
        "company_address": companyAddressController.text,
        "company_location": '$long,$lat',
        "company_size": selectedCompanySize.toString(),
      };
      var secondScreenData = {
        "email": emailController.text,
        "password": passwordController.text,
        "password_confirmation": passwordController.text,
        "name": contactPersonNameController.text,
        "phone_number": contactPersonMobileNumberController.text
      };
      performSignup(
        firstScreenData: firstScreenData,
        secondScreenData: secondScreenData,
        context: context,
      );
    } else {
      if (formKeys[currentStep].currentState!.validate()) {
        currentStep += 1;
        emit(AppContinueStepState());
      } else {
        emit(AppFailStepState());
      }
    }
  }

  void cancelStep() {
    if (currentStep != 0) {
      currentStep -= 1;
    }
    emit(AppCancelStepState());
  }
  final String tokenTest = '1|zmK4tIba5JKPa4vEg3DUfVvusMuu2O4M7VkjpTil';
  late CompanyModel newCompany;
  UserModel? companyUser = null;
  Future<void> performSignup(
      {required Map<String, Object> firstScreenData,
      required Map<String, Object> secondScreenData,
      required BuildContext context}) async {
    // Create the request body
    var host = "https://rky-apis.000webhostapp.com";

    // Step 1: Make the second request
    var registerResponse = await post(
      Uri.parse('https://rky-apis.000webhostapp.com/api/users/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(secondScreenData),
    );

    if (registerResponse.statusCode == 201) {
      var secondParsedResponse = json.decode(registerResponse.body);
      companyUser?.name = secondParsedResponse['name'];
      companyUser?.email = secondParsedResponse['email'];
      companyUser?.phone_number = secondParsedResponse['phone_number'];
      var token = secondParsedResponse['token']; // Extract the user ID

      // Step 2: Make the first request
      var createResponse = await post(
        Uri.parse('$host/api/companies'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer $token"
        },
        body: json.encode(firstScreenData),
      );

      print('Signup successful');

      if (createResponse.statusCode == 201) {
        var firstParsedResponse = json.decode(createResponse.body);

        print('Company: $firstParsedResponse');
        // Print any other relevant response data
        // insertToDataBase(
        //     company_name: companyNameController.text,
        //     contact_person_name: contactPersonNameController.text,
        //     company_industry: industries.toString(),
        //     contact_person_phone_number:
        //         contactPersonMobileNumberController.text,
        //     email: emailController.text,
        //     company_address: companyAddressController.text,
        //     company_location: 'long: $long, lat: $lat',
        //     company_size: selectedCompanySize,
        //     password: passwordController.text);
        companyId = firstParsedResponse['id'];
        newCompany.id =companyId;
        newCompany.name = firstParsedResponse['company_name'];
        newCompany.industires = firstParsedResponse['company_industry'];
        newCompany.address = firstParsedResponse['company_address'];
        newCompany.size = firstParsedResponse['company_size'];
        newCompany.user = companyUser;
        insertToDataBase(company: newCompany);
        // sendToken(tokenTest);
        // userToken = firstParsedResponse['token'];
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Abstract()));
        emit(AppSuccessfulSignupState());

      } else {
        print('create failed: ${createResponse.body}');
        // Handle signup failure
      }
    } else {
      var x = jsonDecode(registerResponse.body);
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
                  "Signup Failed",
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
      print('Signup failed: ${registerResponse.body}');
      // Handle signup failure
    }
  }

  void validateSignup(context) {
    if (formKey.currentState!.validate()) {
      // backend
      print('Signup success');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => EditScreen()));
      emit(AppSuccessfulSignupState());
    } else {
      print('Signup fail');
      emit(AppFailureSignupState());
    }
  }

///////////////////////////////////////////////////////////////
  // Info
  PickedFile? imageFile;
  late File? file;
  final ImagePicker picker = ImagePicker();
  var updateKey = GlobalKey<FormState>();

  void validateUpdate(context, updateKey) {
    if (updateKey.currentState!.validate()) {
      print('update success');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Row(
              children: const [
                Icon(
                  Icons.gpp_good_outlined,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Update success",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'))
            ],
          ));
      Navigator.pop(context);
      emit(AppSuccessfulUpdateState());
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Row(
              children: const [
                Icon(
                  Icons.gpp_bad_outlined,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Update fail",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ok'))
            ],
          ));
      print('Update fail');
      emit(AppFailureUpdateState());
    }
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    imageFile = PickedFile(pickedFile!.path);
    file = File(imageFile!.path);
    emit(AppSuccessfulUploadImageState());
  }

  /////////////////////////////////////////////////////////////////////
  late Database database;
  List<Map> newCompanies = [];

  void createDataBase() {
    openDatabase(
      'app.db',
      version: 1,
      onCreate: (database, version) async {
        print('database created');
        await database.execute(
            'CREATE TABLE companys (id INTEGER PRIMARY KEY, company_name TEXT,contact_person_name TEXT, company_industry TEXT, contact_person_phone_number TEXT, email TEXT, company_address TEXT, company_location TEXT, company_size TEXT, password TEXT)');
        print('Table created');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDataBase(
      {
        required CompanyModel company,
        // required String company_name,
        // required String contact_person_name,
        // required String company_industry,
        // required String contact_person_phone_number,
        // required String email,
        // required String company_address,
        // required String company_location,
        // required String company_size,
        // required String password
      }) async {
    return await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO companys(company_name,contact_person_name,company_industry,contact_person_phone_number,email,company_address,company_location,company_size) VALUES("${company.name}","${company.user?.name}","${company.industires}","${company.user?.phone_number}","${company.user?.email}","${company.address}","${company.lat}, ${company.long}","${company.size}")')
          .then((value) {
        print('$value Inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database).then((value) {
          newCompanies = value;
          print('Companies in local DB: $newCompanies');
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

    return await database.rawQuery('SELECT * FROM companys');
  }

  void updateData({
    required int id,
  }) {
    database.rawUpdate('Update companys WHERE id = ?', ['$id']).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }
}
