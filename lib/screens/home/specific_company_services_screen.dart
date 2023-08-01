import 'package:assignment1/screens/home/search_by_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/screen_size.dart';
import '../../models/models.dart';
import '../cubit/homeCubit.dart';
import '../cubit/states.dart';
import 'service_profile.dart';


class SpecificCompanyServicesScreen extends StatefulWidget {
  const SpecificCompanyServicesScreen({Key? key}) : super(key: key);

  @override
  _SpecificCompanyServicesScreenState createState() =>
      _SpecificCompanyServicesScreenState();
}

class _SpecificCompanyServicesScreenState
    extends State<SpecificCompanyServicesScreen> {
  String selectedCompanyName = 'Select a Company';
  String selectedDescription = '';

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return BlocConsumer<AppHomeCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppHomeCubit cubit = AppHomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: const Text('Business services for a specific company',
                maxLines: 2),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Select the Company',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Container(
                    child: FutureBuilder<List<CompanyModel>>(
                      future: cubit.companiesFuture,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<CompanyModel>> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            cubit.saveName(snapshot.data![0].name);
                          }
                          return Column(
                            children: [
                              DropdownButton<String>(
                                iconSize: 20,
                                isExpanded: true,
                                value: cubit.selectedCompanyName,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: snapshot.data!.map<
                                    DropdownMenuItem<String>>(
                                        (CompanyModel item) {
                                      return DropdownMenuItem<String>(
                                        value: item.name,
                                        child: Text(item.name),
                                      );
                                    }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedCompanyName = newValue!;
                                    CompanyModel selectedCompany = snapshot
                                        .data!.firstWhere(
                                            (company) =>
                                        company.name == newValue);
                                    selectedDescription =
                                        selectedCompany.description;
                                  });
                                },
                              ),
                              Text(
                                'Selected Company: $selectedCompanyName',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Services: $selectedDescription',
                                style: const TextStyle(fontSize: 16),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ServiceSearchScreen(),
                                    ),
                                  );
                                },
                                child: Text('Search'),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text('error ${snapshot.error}');
                        }

                        return const Center(
                            child: CircularProgressIndicator());
                      },
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
