import 'dart:convert';

import 'package:assignment1/screens/cubit/homeCubit.dart';
import 'package:assignment1/screens/cubit/signupCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../components/components.dart';
import '../../../../components/screen_size.dart';
import '../cubit/loginCubit.dart';
import 'package:http/http.dart';
import '../cubit/states.dart';

class ServiceInfoScreen extends StatelessWidget {
  const ServiceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return BlocConsumer<AppHomeCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppHomeCubit cubit = AppHomeCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text('Service info', maxLines: 2),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            // child: Center(
            //   child: FutureBuilder<List>(
            //     future: cubit.getServicesByCompany(cubit.specificCompanyId!),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return ListView.builder(
            //           itemCount: snapshot.data!.length,
            //           itemBuilder: (context, index) {
            //             final service = snapshot.data![index];
            //             return ListTile(
            //               title: Text(service.name),
            //               subtitle: Text(service.description),
            //               trailing: Text(service.price.toString()),
            //             );
            //           },
            //         );
            //       } else if (snapshot.hasError) {
            //         return Text('${snapshot.error}');
            //       }
            //
            //       // By default, show a loading spinner.
            //       return CircularProgressIndicator();
            //     },
            //   ),
            // ),

            // Column(
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: const [
            //         Text(
            //           'Select the Company',
            //           style: TextStyle(
            //               fontSize: 20, fontWeight: FontWeight.w400),
            //         ),
            //       ],
            //     ),
            //     DropdownButton<String>(
            //       iconSize: 20,
            //       isExpanded: true,
            //       // Initial Value
            //       value: cubit.selectedCompany.isNotEmpty
            //           ? cubit.selectedCompany
            //           : null,
            //
            //       // Down Arrow Icon
            //       icon: const Icon(Icons.keyboard_arrow_down),
            //
            //       // Array list of items
            //       items: cubit.companies.map((String items) {
            //         return DropdownMenuItem(
            //           value: items,
            //           child: Text(items),
            //         );
            //       }).toList(),
            //       // After selecting the desired option,it will
            //       // change button value to selected value
            //       onChanged: (newValue) {
            //         cubit.selectSpecificCompany(newValue);
            //       },
            //     ),
            //     Container(
            //       height: ScreenSize.screenHeight,
            //       child: ListView.separated(
            //           scrollDirection: Axis.vertical,
            //           shrinkWrap: true,
            //           physics: const AlwaysScrollableScrollPhysics(),
            //           itemBuilder: (context, index) =>
            //               buildItem(
            //                 cubit.companyModel[index], cubit, context,),
            //           separatorBuilder: (context, index) =>
            //               SizedBox(
            //                 height: ScreenSize.screenHeight * 0.03,
            //               ),
            //           itemCount: cubit.companyModel.length),
            //     ),
            //   ],
            // ),






          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Service name ',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.01,
                        ),
                        Text(
                          cubit.selctedService!.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.02,
                        ),
                        const Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.02,
                        ),
                        Text(
                          cubit.selctedService!.description,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.02,
                        ),
                        const Divider(
                          height: 1,
                          color: Colors.grey,
                        ),

                        SizedBox(
                          height: ScreenSize.screenHeight * 0.02,
                        ),
                        const Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Company: ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              cubit.selctedService!.companyName!,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.02,
                        ),
                        const Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Service price: ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              cubit.selctedService!.price.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenSize.screenHeight * 0.02,
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
          ),
        );
      },
    );
  }

}
