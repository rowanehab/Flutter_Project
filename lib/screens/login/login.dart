// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/components.dart';
import '../../../components/screen_size.dart';
import '../cubit/loginCubit.dart';
import '../cubit/states.dart';
import '../home/edit_screen.dart';
import '../signup/signup_with_stepper.dart';
import 'package:http/http.dart';
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return BlocBuilder<AppLoginCubit, AppStates>(
      builder: (context, state) {
        AppLoginCubit cubit = AppLoginCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: cubit.loginFormKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                      child: Text(
                    'Welcome Back!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    height: ScreenSize.screenHeight * 0.05,
                  ),
                  TextFieldComponent(
                    label: 'Email',
                    controller: cubit.loginEmailController,
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
                    controller: cubit.loginPasswordController,
                    isPassword: true,
                    picon: const Icon(Icons.lock_outline_rounded),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: ScreenSize.screenHeight * 0.02,
                  ),

                  defaultButton(
                    text: 'LOGIN',
                    onpressed: () async {
                      cubit.validateLogin(context);
                    },
                  ),

// ...
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account? '),
                      defaultTextButton(
                          color: Colors.blue,
                          text: 'Sign up now!',
                          onpressed: () {
                            cubit.enterSignup(context);
                          }),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
