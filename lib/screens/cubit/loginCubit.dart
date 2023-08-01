import 'dart:convert';

import 'package:assignment1/screens/cubit/states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../abstract.dart';
import '../home/edit_screen.dart';
import 'package:http/http.dart';
import '../signup/signup_with_stepper.dart';

class AppLoginCubit extends Cubit<AppStates> {
  AppLoginCubit() : super(AppLoginInitialState());

  static AppLoginCubit get(context) => BlocProvider.of(context);

  ///////////////////////////////////////////////////////////////

  // Login
  var loginEmailController = TextEditingController();
  var loginPasswordController = TextEditingController();
  var loginFormKey = GlobalKey<FormState>();

  Future<void> validateLogin(context) async {
    if (loginFormKey.currentState!.validate()) {
      // if(loginEmailController.text =);

      var url = Uri.parse('https://rky-apis.000webhostapp.com/api/users/login');
      // var url = Uri.parse('http://127.0.0.1:8000/api/users/login');
      var data = {
        'email': loginEmailController.text,
        'password': loginPasswordController.text,
      };
      var response = await post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(data),
      );
      if (response.statusCode != 200) {
        var x = jsonDecode(response.body);
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
                        "Login Failed",
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
        print(x['message']);
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${jsonDecode(response.body)}');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Abstract()));
        loginEmailController.clear();
        loginPasswordController.clear();
      }
      if (kDebugMode) {
        print('Login success');
      }

      emit(AppSuccessfulLoginState());
    } else {
      if (kDebugMode) {
        print('Login fail');
      }
      emit(AppFailureLoginState());
    }
  }

  void enterSignup(context) {
    emit(AppEnterSignupState());
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Signup1Screen()));
  }

////////////////////////////////////////////////////////////////
  //
  // //Database
  late Database database;
  List<Map> newAccounts = [];

  void createDataBase() {
    openDatabase('app.db', version: 1, onCreate: (database, version) async {
      if (kDebugMode) {
        print('database created');
      }
      await database.execute(
          'CREATE TABLE companys (id INTEGER PRIMARY KEY, company_name TEXT,contact_person_name TEXT, company_industry TEXT, contact_person_phone_number TEXT, email TEXT, company_address TEXT, company_location TEXT, company_size TEXT, password TEXT)');
      if (kDebugMode) {
        print('Table created');
      }
    }, onOpen: (database) {
      getDataFromDatabase(database).then((value) {
        newAccounts = value;
        if (kDebugMode) {
          print(newAccounts);
        }
      });
      if (kDebugMode) {
        print('database opened');
      }
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    return await database.rawQuery('SELECT * FROM companys');
  }
}

/*
  // // Sign up
  // var companyNameController = TextEditingController();
  //
  // var companyAddressController = TextEditingController();
  //
  // var contactPersonNameController = TextEditingController();
  //
  // var emailController = TextEditingController();
  //
  // var passwordController = TextEditingController();
  //
  // var confirmPasswordController = TextEditingController();
  //
  // var contactPersonMobileNumberController = TextEditingController();
  // var items = [
  //   'Micro',
  //   'Small',
  //   'Mini',
  //   'Large',
  // ];
  // String selectedCompanySize = 'Micro';
  // var formKey = GlobalKey<FormState>();
  // List<GlobalKey<FormState>> formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>(),GlobalKey<FormState>()];
  // String? gender;
  // int currentRole = 1;
  // int currentStep = 0;
  // List<String> industries = [
  //   'Manufacturing',
  //   'Production',
  //   'Technology',
  //   'Retail',
  //   'Construction',
  //   'Marketing',
  //   'Trade',
  //   'Food industry',
  //   'Education',
  //   'Economics',
  //   'Accounting'
  // ];
  // List<String> selectedIndustries = [];
  // final Map<int, Widget> roles = const <int, Widget>{
  //   0: Padding(
  //     padding: EdgeInsets.all(15),
  //     child: Text('Hall owner', maxLines: 1),
  //   ),
  //   1: Padding(
  //     padding: EdgeInsets.all(15),
  //     child: Text('User', maxLines: 1),
  //   ),
  //   2: Padding(
  //     padding: EdgeInsets.all(10),
  //     child: Text('Planner', maxLines: 1),
  //   ),
  // };
  // final Map<int, String> rolesString = const <int, String>{
  //   0: "Hall owner",
  //   1: "User",
  //   2: "Planner",
  // };
  // int personGender = 1;
  // final Map<int, Widget> gender_ = const <int, Widget>{
  //   0: Padding(
  //     padding: EdgeInsets.all(20),
  //     child: Text('Male'),
  //   ),
  //   1: Padding(
  //     padding: EdgeInsets.all(20),
  //     child: Text('Female'),
  //   ),
  // };
  // bool isChecked = false;
  // void changeCheckbox(value){
  //   isChecked = value;
  //   emit(AppChangeCheckboxState());
  // }
  // void selectCompanySize(newValue){
  //   selectedCompanySize = newValue;
  //   emit(AppSelectCompanySizeState());
  //   // widget.onCompanySizeChanged(selectedCompanySize);
  // }
  // void selectIndustry(value){
  //   print('selected industry $value');
  //   selectedIndustries = value;
  //   print('you have selected $selectedIndustries industries.');
  // }
  // List<Step> getSteps() => [
  //   Step(
  //     isActive: currentStep >=0,
  //     title: Text('Company',style: TextStyle(
  //       fontSize: 12
  //     ),),
  //     content: Form(
  //       key: formKeys[0],
  //       child: Column(
  //         children: [
  //           TextFieldComponent(
  //             label: 'Company Name',
  //             controller: companyNameController,
  //             keyType: TextInputType.text,
  //             picon: Icon(Icons.home_work_outlined),
  //             validator: (value) {
  //               if (value.isEmpty) {
  //                 return 'please enter company name';
  //               }
  //               return null;
  //             },
  //           ),
  //           SizedBox(
  //             height: ScreenSize.screenHeight * 0.02,
  //           ),
  //           TextFieldComponent(
  //             label: 'Company Address',
  //             controller: companyAddressController,
  //             keyType: TextInputType.text,
  //             picon: Icon(Icons.add_home_outlined),
  //             validator: (value) {
  //               if (value.isEmpty) {
  //                 return 'please enter company address';
  //               }
  //               return null;
  //             },
  //           ),
  //           SizedBox(
  //             height: ScreenSize.screenHeight * 0.02,
  //           ),
  //           DropDownMultiSelect(
  //             options: industries,
  //             selectedValues: selectedIndustries,
  //             onChanged: (value) {
  //               selectIndustry(value);
  //               emit(AppChooseIndustryState());
  //             },
  //             whenEmpty: 'Company industry',
  //           ),
  //           SizedBox(
  //             height: ScreenSize.screenHeight * 0.02,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Text('Company Size',style: TextStyle(fontSize: 18),),
  //             ],
  //           ),
  //           DropdownButton<String>(
  //             iconSize: 20,
  //             isExpanded: true,
  //             // Initial Value
  //             value: selectedCompanySize.isNotEmpty ? selectedCompanySize : null,
  //
  //             // Down Arrow Icon
  //             icon: const Icon(Icons.keyboard_arrow_down),
  //
  //             // Array list of items
  //             items: items.map((String items) {
  //               return DropdownMenuItem(
  //                 value: items,
  //                 child: Text(items),
  //               );
  //             }).toList(),
  //             // After selecting the desired option,it will
  //             // change button value to selected value
  //             onChanged: (newValue) {
  //               selectCompanySize(newValue);
  //             },
  //           ),
  //
  //         ],
  //       ),
  //     ),
  //   ),
  //   Step(
  //     isActive: currentStep >=1,
  //     title: Text('Required info',style: TextStyle(
  //         fontSize: 12
  //     ),),
  //     content: Form(
  //       key: formKeys[1],
  //       child: Column(
  //         children: [
  //           TextFieldComponent(
  //             label: 'Contact Person Name',
  //             controller: contactPersonNameController,
  //             keyType: TextInputType.text,
  //             picon: Icon(Icons.person_outline),
  //             validator: (value) {
  //               if (value.isEmpty) {
  //                 return 'please enter contact person name';
  //               }
  //               return null;
  //             },
  //           ),
  //           SizedBox(
  //             height: ScreenSize.screenHeight * 0.02,
  //           ),
  //           TextFieldComponent(
  //             label: 'Contact Person Phone Number',
  //             controller: contactPersonMobileNumberController,
  //             keyType: TextInputType.phone,
  //             picon: Icon(Icons.call),
  //             validator: (value) {
  //               if (value.isEmpty) {
  //                 return 'please enter your phone number';
  //               }
  //               else if (contactPersonMobileNumberController.text.length != 11) {
  //                 return "please enter valid number";
  //               }
  //               return null;
  //             },
  //           ),
  //           SizedBox(
  //             height: ScreenSize.screenHeight * 0.02,
  //           ),
  //           TextFieldComponent(
  //             label: 'Email',
  //             controller: emailController,
  //             keyType: TextInputType.emailAddress,
  //             picon: Icon(Icons.email_outlined),
  //             validator: (value) {
  //               bool emailValid = RegExp(
  //                   r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]")
  //                   .hasMatch(value);
  //               if (value.isEmpty) {
  //                 return 'please enter your email';
  //               }
  //               else if (!emailValid) {
  //                 return "Enter a valid email";
  //               }
  //               return null;
  //             },
  //           ),
  //           SizedBox(
  //             height: ScreenSize.screenHeight * 0.02,
  //           ),
  //
  //
  //           TextFieldComponent(
  //             label: 'Password',
  //             controller: passwordController,
  //             isPassword: true,
  //             picon: Icon(Icons.lock_outline_rounded),
  //             validator: (value) {
  //               if (value.isEmpty) {
  //                 return 'please enter your password';
  //               }
  //               else if (passwordController.text.length < 8) {
  //                 return "Password should be more than 8 characters";
  //               }
  //               return null;
  //             },
  //           ),
  //           SizedBox(
  //             height: ScreenSize.screenHeight * 0.02,
  //           ),
  //           TextFieldComponent(
  //             label: 'Confirm Password',
  //             controller: confirmPasswordController,
  //             isPassword: true,
  //             picon: Icon(Icons.lock_outline_rounded),
  //             validator: (value) {
  //               if (value.isEmpty) {
  //                 return 'please enter the confirm password';
  //               }
  //               if (value != passwordController.text){
  //                 return 'The confirm password must be the same password';
  //               }
  //               return null;
  //             },
  //           ),
  //           SizedBox(
  //             height: ScreenSize.screenHeight * 0.02,
  //           ),
  //         ],
  //       ),
  //     ),
  //   ),
  //   Step(
  //     isActive: currentStep >=2,
  //     title: Text('Complete',style: TextStyle(
  //         fontSize: 12
  //     ),),
  //     content: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text('Company name: ',style: TextStyle(fontSize: 20),),
  //         Text(companyNameController.text,style: TextStyle(fontSize: 18),),
  //         SizedBox(
  //           height: ScreenSize.screenHeight * 0.02,
  //         ),
  //         Text('Contact person name: ',style: TextStyle(fontSize: 20),),
  //         Text(contactPersonNameController.text,style: TextStyle(fontSize: 18),),
  //         SizedBox(
  //           height: ScreenSize.screenHeight * 0.02,
  //         ),
  //         Text('Contact person number: ',style: TextStyle(fontSize: 20),),
  //         Text(contactPersonMobileNumberController.text,style: TextStyle(fontSize: 18),),
  //         SizedBox(
  //           height: ScreenSize.screenHeight * 0.02,
  //         ),
  //         Text('Email: ',style: TextStyle(fontSize: 20),),
  //         Text(emailController.text,style: TextStyle(fontSize: 18),),
  //         SizedBox(
  //           height: ScreenSize.screenHeight * 0.02,
  //         ),
  //       ],
  //     ),
  //   ),
  // ];
  // void continueStep(){
  //   if(currentStep == getSteps().length-1){
  //     print('Completed');
  //     emit(AppSuccessfulSignupState());
  //   }
  //   else{
  //     if (formKeys[currentStep].currentState!.validate()){
  //       currentStep+=1;
  //       emit(AppContinueStepState());
  //   }
  //   else emit(AppFailStepState());
  //   }
  //
  // }
  // void cancelStep(){
  //   currentStep-=1;
  //   emit(AppCancelStepState());
  // }
  //
  //
  // void validateSignup(context){
  //
  //   if (formKey.currentState!.validate()) {
  //     // backend
  //     emailController.clear();
  //     companyAddressController.clear();
  //     companyNameController.clear();
  //     passwordController.clear();
  //     companyNameController.clear();
  //     confirmPasswordController.clear();
  //     passwordController.clear();
  //     print('Signup success');
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(
  //             builder: (context) => HomeScreen()));
  //     emit(AppSuccessfulSignupState());
  //   }
  //   else if (passwordController.text == confirmPasswordController){}
  //   else {
  //     print('Signup fail');
  //     emit(AppFailureSignupState());
  //   }
  // }
* */
