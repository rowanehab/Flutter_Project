import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../cubit/homeCubit.dart';
import '../cubit/states.dart';

class DistanceCalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppHomeCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppHomeCubit cubit = AppHomeCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              centerTitle: true,
              title: Text('Distance', maxLines: 2),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: cubit.latController,
                    decoration: InputDecoration(
                        hintText: "Enter latitude of business address"),
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextField(
                    controller: cubit.lngController,
                    decoration: InputDecoration(
                      hintText: "Enter longitude of business address",
                      labelStyle: TextStyle(color: Colors.grey),
                    ),
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    child: Text("Calculate distance"),
                    onPressed: () {
                      cubit.displayAddress();
                      cubit.display();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    cubit.placemarks != null
                        ? 'Provider address: ${cubit.streetAddress}, ${cubit.city}, ${cubit.cstate}, ${cubit.country}'
                        : '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    cubit.distance != null
                        ? 'Distance: ${cubit.distance.toString()}'
                        : '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
