class ServiceModel {
  late final String name;
  late final double price;
  bool isFavourite;
  late final String description;
  late final int companyId;
  String? companyName;
  ServiceModel({
    required this.name,
    required this.price,
    required this.isFavourite,
    required this.description,
    this.companyName,
    required this.companyId,
  });
}
class CompanyModel {
  int id;
  late final String name;
  List? services;
  late int servicesNumber = services!.length;
  late final String description;
  List? industires;
  String? address;
  String? lat;
  String? long;
  String? size;
  UserModel? user;
  CompanyModel({
    required this.name,
    required this.description,
    this.services,
    required this.id,
    this.user,
    this.lat,
    this.long,
  }) : servicesNumber = services?.length ?? 0;
  double get longitude => this.longitude; // Getter for longitude property
  double get latitude => this.latitude; // Getter for longitude property
}
class UserModel{
  late final String email;
  late final String name;
  late final String phone_number;
  UserModel({
    required this.email,
    required this.name,
    required this.phone_number,
  });
}