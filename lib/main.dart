import 'package:assignment1/screens/abstract.dart';
import 'package:assignment1/screens/cubit/homeCubit.dart';
import 'package:assignment1/screens/cubit/loginCubit.dart';
import 'package:assignment1/screens/cubit/signupCubit.dart';
//import 'package:assignment1/screens/home/CompanyDetailsScreen.dart';
import 'package:assignment1/screens/home/search_by_service.dart';
import 'package:assignment1/screens/home/distance_screen.dart';
import 'package:assignment1/screens/home/edit_screen.dart';
import 'package:assignment1/screens/home/sevices_screen.dart';
import 'package:assignment1/screens/login/login.dart';
import 'package:assignment1/screens/signup/signup_with_stepper.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/bloc_observer.dart';
import 'models/models.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppLoginCubit()..createDataBase()),
        BlocProvider(create: (context) => AppSignupCubit()..createDataBase()),
        BlocProvider(create: (context) => AppHomeCubit()..getServices()..initStateOfGettingServices()..initStateOfGettingCompanines()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}