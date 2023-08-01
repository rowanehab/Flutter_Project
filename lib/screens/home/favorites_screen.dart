
import 'package:assignment1/screens/cubit/homeCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/components.dart';
import '../../../components/screen_size.dart';
import '../../models/models.dart';
import '../cubit/homeCubit.dart';
import '../cubit/homeCubit.dart';
import '../cubit/states.dart';

class MyFavouriteServiceScreen extends StatelessWidget {
  const MyFavouriteServiceScreen({Key? key}) : super(key: key);

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
              title: Text('My Favourites', maxLines: 2),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Favorite business services',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: ScreenSize.screenHeight*0.03,),
                Container(
                  height: ScreenSize.screenHeight,
                  child: FutureBuilder<List<ServiceModel>>(
                    future: cubit.servicesFuture,
                    builder: (BuildContext context, AsyncSnapshot<List<ServiceModel>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildItem(snapshot.data![index], cubit),
                          separatorBuilder: (context, index) => SizedBox(
                            height: ScreenSize.screenHeight * 0.03,
                          ),
                          itemCount: snapshot.data!.length,
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner
                      return Center(child: CircularProgressIndicator());
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

  Widget buildItem(ServiceModel model, AppHomeCubit cubit) => Column(
    children: [
      model.isFavourite ? Container(
        height: ScreenSize.screenHeight * 0.1,
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
                    Text(
                      model.name,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: ScreenSize.screenHeight*0.01,),
                    Text(
                      '${model.price.toString()} EGP ',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400,color: Colors.green),
                    ),
                  ],
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    cubit.changeFavourite(model);
                  },
                  icon: model.isFavourite ? Icon(Icons.favorite) : Icon(Icons.favorite_border) ,
                  color: Colors.red,
                  iconSize: 20,
                  padding: EdgeInsets.zero),
            ],
          ),
        ),
      ) : SizedBox(height: ScreenSize.screenHeight*0.000000001,),
    ],
  );
}
