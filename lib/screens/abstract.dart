
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/homeCubit.dart';
import 'cubit/states.dart';
class Abstract extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppHomeCubit, AppStates>(
        builder: (context,state) {
          AppHomeCubit cubit = AppHomeCubit.get(context);
          cubit.createServicesInDataBase();
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeNavBar(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home),label: cubit.titles[0]),
                BottomNavigationBarItem(icon: Icon(Icons.favorite),label: cubit.titles[1]),
                BottomNavigationBarItem(icon: Icon(Icons.cleaning_services),label: cubit.titles[2]),
                BottomNavigationBarItem(icon: Icon(Icons.social_distance),label: cubit.titles[3]),
                BottomNavigationBarItem(icon: Icon(Icons.home_work),label: cubit.titles[4])
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
          );
        },
    );
  }
}
