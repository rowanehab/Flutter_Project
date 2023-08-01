import 'package:assignment1/screens/cubit/signupCubit.dart';
import 'package:assignment1/screens/cubit/signupCubit.dart';
import 'package:assignment1/screens/cubit/signupCubit.dart';
import 'package:assignment1/screens/cubit/signupCubit.dart';
import 'package:assignment1/screens/cubit/states.dart';
import 'package:assignment1/screens/home/edit_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/components.dart';
import '../../../components/screen_size.dart';
import '../cubit/loginCubit.dart';
import '../login/login.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Signup1Screen extends StatelessWidget {
  const Signup1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return BlocBuilder<AppSignupCubit, AppStates>(
      builder: (context, state) {
        AppSignupCubit cubit = AppSignupCubit.getSignup(context);
        return SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: Stepper(
                type: StepperType.horizontal,
                steps: cubit.getSteps(),
                currentStep: cubit.currentStep,
                onStepContinue: () {
                  cubit.continueStep(context);
                },
                onStepCancel: () {
                  cubit.cancelStep();
                },
              )),
        );
      },
    );
  }
}
