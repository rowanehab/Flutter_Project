import 'dart:convert';

import 'package:assignment1/screens/cubit/signupCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../components/components.dart';
import '../../../../components/screen_size.dart';
import '../cubit/loginCubit.dart';
import 'package:http/http.dart';
import '../cubit/states.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return BlocConsumer<AppSignupCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppSignupCubit cubit = AppSignupCubit.getSignup(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                imageProfile(cubit, context),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Company name ',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.01,
                        ),
                        Row(
                          children: [
                            Text(
                              cubit.companyNameController.text,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            defaultTextButton(
                                color: Colors.blue,
                                text: 'Edit',
                                onpressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25)),
                                      ),
                                      builder: ((context) => editInfo(
                                          cubit.companyNameController,
                                          context,
                                          cubit)));
                                }),
                          ],
                        ),
                        const Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.02,
                        ),
                        const Text(
                          'Email ',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.01,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Row(
                            children: [
                              Text(
                                cubit.emailController.text,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.02,
                        ),
                        const Text(
                          'Company Address',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.01,
                        ),
                        Row(
                          children: [
                            Text(
                              cubit.companyAddressController.text,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            defaultTextButton(
                                color: Colors.blue,
                                text: 'Edit',
                                onpressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25)),
                                      ),
                                      builder: ((context) => editInfo(
                                          cubit.companyAddressController,
                                          context,
                                          cubit)));
                                }),
                          ],
                        ),
                        const Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.02,
                        ),
                        const Text(
                          'Contact person number ',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.01,
                        ),
                        Row(
                          children: [
                            Text(
                              cubit.contactPersonMobileNumberController.text,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            defaultTextButton(
                                color: Colors.blue,
                                text: 'Edit',
                                onpressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25)),
                                      ),
                                      builder: ((context) => editInfo(
                                          cubit
                                              .contactPersonMobileNumberController,
                                          context,
                                          cubit)));
                                }),
                          ],
                        ),
                        const Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.02,
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget imageProfile(AppSignupCubit cubit, context) {
    return Center(
      child: Container(
        width: ScreenSize.screenWidth * 0.3,
        height: ScreenSize.screenHeight * 0.2,
        decoration: const BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: ScreenSize.screenWidth * 0.1,
                      backgroundImage: cubit.imageFile == null
                          ? const AssetImage('assets/images/user.png')
                          : FileImage(cubit.file!) as ImageProvider,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(25)),
                          ),
                          builder: ((context) => bottomSheet(context, cubit)));
                    },
                    icon: const Icon(Icons.linked_camera_outlined),
                    color: Colors.black,
                  )
                ],
              ),
              SizedBox(
                height: ScreenSize.screenHeight * 0.01,
              ),
              const Text(
                'Change photo',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet(context, AppSignupCubit cubit) {
    return Wrap(children: [
      Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Choose profile photo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        cubit.takePhoto(ImageSource.camera);
                      },
                      color: Colors.grey[200],
                      child: Row(
                        children: [
                          const Icon(Icons.camera),
                          SizedBox(
                            height: ScreenSize.screenHeight * 0.01,
                          ),
                          const Text('Camera'),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: ScreenSize.screenWidth * 0.03,
                    ),
                    MaterialButton(
                      onPressed: () {
                        cubit.takePhoto(ImageSource.gallery);
                      },
                      color: Colors.grey[200],
                      child: Row(
                        children: [
                          const Icon(Icons.image),
                          SizedBox(
                            height: ScreenSize.screenHeight * 0.01,
                          ),
                          const Text('Gallery'),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ))
    ]);
  }

  Widget editInfo(
    TextEditingController controller,
    context,
    AppSignupCubit cubit,
  ) {
    return Wrap(
      children: [
        Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: cubit.updateKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFieldComponent(
                    label: 'Enter the updated info',
                    controller: controller,
                    keyType:
                        controller == cubit.contactPersonMobileNumberController
                            ? TextInputType.phone
                            : TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please update info';
                      }
                      if (controller ==
                          cubit.contactPersonMobileNumberController) {
                        if (controller.text.length != 11) {
                          return "please enter valid number";
                        }
                      }
                      if (controller == cubit.emailController) {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]")
                            .hasMatch(value);
                        if (!emailValid) {
                          return "Enter a valid email";
                        }
                      }
                      return null;
                    },
                    autoFocus: true,
                  ),
                  SizedBox(
                    height: ScreenSize.screenHeight * 0.02,
                  ),
                  defaultButton(
                      text: 'Update',
                      onpressed: () async {
                        cubit.validateUpdate(context, cubit.updateKey);
                        // Make API call to update the information
                        try {
                          const host = 'http://rkyapi.000webhostapp.com';
                          final url =
                              '$host/api/companies/${cubit.companyId}/update';
                          final headers = {
                            'Content-Type': 'multipart/form-data',
                            'Authorization':
                            'Bearer 23|tRgtKUNEyYo3uDPmHobTyQyAsoePM8pfIzdZBpfg',
                            'Accept': 'application/json'
                          };
                          final body = {
                            'company_name': cubit.companyNameController.text,
                            'company_address': cubit.companyAddressController.text,
                            'logo': cubit.imageFile,
                          };

                          final response = await post(
                            Uri.parse(url),
                            headers: headers,
                            body: json.encode(body),
                          );
                          print(response.body);
                        } catch (e) {
                          // Error occurred
                        }
                      }
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      // child:
    );
  }
}
