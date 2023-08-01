import 'package:assignment1/screens/cubit/signupCubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/components.dart';
import '../../components/screen_size.dart';
import '../cubit/homeCubit.dart';
import '../cubit/states.dart';

class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);

    return BlocConsumer<AppHomeCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppHomeCubit cubit = AppHomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text('Add service', maxLines: 2),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: cubit.addServiceFormKey,
                child: Column(
                  children: [
                    TextFieldComponent(
                      label: 'Service name',
                      controller: cubit.serviceNameController,
                      keyType: TextInputType.text,
                      picon: const Icon(Icons.design_services),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please enter service name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: ScreenSize.screenHeight * 0.02,
                    ),
                    TextFieldComponent(
                      label: 'Description',
                      controller: cubit.serviceDescriptionController,
                      keyType: TextInputType.text,
                      picon: const Icon(Icons.description),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please enter description';
                        } 
                        return null;
                      },
                    ),
                    SizedBox(
                      height: ScreenSize.screenHeight * 0.02,
                    ),
                    TextFieldComponent(
                      label: 'Price',
                      controller: cubit.priceController,
                      keyType: TextInputType.number,
                      picon: const Icon(Icons.price_change),
                      validator: (value) {

                        if (value.isEmpty) {
                          return 'please enter price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: ScreenSize.screenHeight * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Add to favorites? ',style: TextStyle(fontSize: 16),),

                      ],

                    ),
                    RadioListTile(
                      title: Text('Yes'),
                      value: true,
                      groupValue: cubit.yesSelected,
                      onChanged: (value) {
                        cubit.changeYesRadio(value);
                      },
                    ),
                    RadioListTile(
                      title: Text('No'),
                      value: true,
                      groupValue: cubit.noSelected,
                      onChanged: (value) {
                        cubit.changeNoRadio(value);
                      },
                    ),
                    SizedBox(
                      height: ScreenSize.screenHeight * 0.02,
                    ),
                Container(
              width:  double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.black,
                ),
                child: MaterialButton(
                  child: Text(
                    'Add',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17
                    ),
                  ),
                  onPressed:(){
                    var serviceData = {
                      "name": cubit.serviceNameController.text,
                      "description": cubit.serviceDescriptionController.text,
                      "price": cubit.priceController.text,
                      "company_id": AppSignupCubit.getSignup(context).companyId,
                    };
                    cubit.validateAdd(serviceData,context);}

                ),
              )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
