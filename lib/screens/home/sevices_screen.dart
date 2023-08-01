import 'package:assignment1/screens/home/add_service_screen.dart';
import 'package:assignment1/screens/home/search_by_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/screen_size.dart';
import '../../models/models.dart';
import '../cubit/homeCubit.dart';
import '../cubit/states.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return BlocBuilder<AppHomeCubit, AppStates>(
        builder: (context, state) {
          AppHomeCubit cubit = AppHomeCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              centerTitle: true,
              actions: [
                IconButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (context)=>ServiceSearchScreen()));}, icon: Icon(Icons.search))
              ],
              title: Text(
                  'Company services', maxLines: 2),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=> AddServiceScreen()));
              },
              child: Icon(Icons.add,),backgroundColor: Colors.black,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: FutureBuilder<List>(
                  future: cubit.servicesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final service = snapshot.data![index];
                          return ListTile(
                            title: Text(service.name),
                            subtitle: Text('\$${service.price}'),
                            trailing: IconButton(
                                onPressed: () {
                                  cubit.changeFavourite(service);
                                },
                                icon: service.isFavourite ? Icon(Icons.favorite) : Icon(Icons.favorite_border) ,
                                color: Colors.red,
                                iconSize: 20,
                                padding: EdgeInsets.zero),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),
          );
        }

    );
  }
  Widget buildServiceItem(ServiceModel model, AppHomeCubit cubit,context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: ScreenSize.screenHeight * 0.12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(onPressed: (){
                      cubit.selctedService = model;
                      cubit.navigateToTheService(model, context);
                    }, child: Text(
                      model.name,
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400),
                    ),)

                  ],
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    cubit.changeFavourite(model);
                  },
                  icon: model.isFavourite ? Icon(Icons.favorite) : Icon(
                      Icons.favorite_border),
                  color: Colors.red,
                  iconSize: 20,
                  padding: EdgeInsets.zero),
            ],
          ),
        ),
      ),
    );
  }
}
