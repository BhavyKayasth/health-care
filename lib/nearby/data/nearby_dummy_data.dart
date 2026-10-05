// import '../models/area_model.dart';
// import '../models/city_model.dart';
// import '../models/nearby_hospital_model.dart';
// import '../models/village_model.dart';
//
// class NearbyDummyData {
//   NearbyDummyData._();
//
//   // ---------------------- Cities ----------------------
//
//   static const List<CityModel> cities = [
//     CityModel(
//       id: "vadodara",
//       name: "Vadodara",
//       latitude: 22.3072,
//       longitude: 73.1812,
//     ),
//     CityModel(
//       id: "ahmedabad",
//       name: "Ahmedabad",
//       latitude: 23.0225,
//       longitude: 72.5714,
//     ),
//     CityModel(
//       id: "idar",
//       name: "Idar",
//       latitude: 23.8379,
//       longitude: 73.0110,
//     ),
//   ];
//
//   // ---------------------- Areas ----------------------
//
//   static const List<AreaModel> areas = [
//     // Vadodara
//     AreaModel(
//       id: "alkapuri",
//       cityId: "vadodara",
//       name: "Alkapuri",
//       latitude: 22.3066,
//       longitude: 73.1822,
//     ),
//     AreaModel(
//       id: "race-course",
//       cityId: "vadodara",
//       name: "Race Course",
//       latitude: 22.2958,
//       longitude: 73.1811,
//     ),
//     AreaModel(
//       id: "manjalpur",
//       cityId: "vadodara",
//       name: "Manjalpur",
//       latitude: 22.2726,
//       longitude: 73.1889,
//     ),
//
//     // Ahmedabad
//     AreaModel(
//       id: "sg-highway",
//       cityId: "ahmedabad",
//       name: "SG Highway",
//       latitude: 23.0359,
//       longitude: 72.5148,
//     ),
//     AreaModel(
//       id: "satellite",
//       cityId: "ahmedabad",
//       name: "Satellite",
//       latitude: 23.0258,
//       longitude: 72.5098,
//     ),
//     AreaModel(
//       id: "vastrapur",
//       cityId: "ahmedabad",
//       name: "Vastrapur",
//       latitude: 23.0395,
//       longitude: 72.5242,
//     ),
//
//     // Idar
//     AreaModel(
//       id: "main-market",
//       cityId: "idar",
//       name: "Main Market",
//       latitude: 23.8385,
//       longitude: 73.0115,
//     ),
//     AreaModel(
//       id: "civil-hospital",
//       cityId: "idar",
//       name: "Civil Hospital Area",
//       latitude: 23.8390,
//       longitude: 73.0125,
//     ),
//   ];
//
//   // ---------------------- Villages ----------------------
//
//   static const List<VillageModel> villages = [
//     VillageModel(
//       id: "alkapuri-1",
//       areaId: "alkapuri",
//       name: "Alkapuri Village",
//     ),
//     VillageModel(
//       id: "race-1",
//       areaId: "race-course",
//       name: "Race Course Village",
//     ),
//     VillageModel(
//       id: "manjalpur-1",
//       areaId: "manjalpur",
//       name: "Manjalpur Village",
//     ),
//     VillageModel(
//       id: "sg-1",
//       areaId: "sg-highway",
//       name: "SG Highway Village",
//     ),
//     VillageModel(
//       id: "satellite-1",
//       areaId: "satellite",
//       name: "Satellite Village",
//     ),
//     VillageModel(
//       id: "vastrapur-1",
//       areaId: "vastrapur",
//       name: "Vastrapur Village",
//     ),
//     VillageModel(
//       id: "market-1",
//       areaId: "main-market",
//       name: "Market Village",
//     ),
//     VillageModel(
//       id: "civil-1",
//       areaId: "civil-hospital",
//       name: "Civil Hospital Village",
//     ),
//   ];
//
//   // ---------------------- Categories ----------------------
//
//   static const List<String> specialties = [
//     "All",
//     "Cardiology",
//     "Neurology",
//     "Orthopedics",
//     "Dermatology",
//     "Pediatrics",
//     "Gynecology",
//     "General Medicine",
//     "Surgery",
//     "Oncology",
//     "ENT",
//     "Gastroenterology",
//     "Pulmonology",
//     "Nephrology",
//     "Urology",
//     "Ophthalmology",
//   ];
//
//   // ---------------------- Hospitals ----------------------
//
//   static const List<NearbyHospitalModel> hospitals = [
//     NearbyHospitalModel(
//       id: "1",
//       name: "Sterling Hospital",
//       cityId: "vadodara",
//       areaId: "race-course",
//       villageId: "race-1",
//       address: "Race Course Road, Vadodara",
//       phone: "+91 2652334455",
//       latitude: 22.2958,
//       longitude: 73.1811,
//       rating: 4.5,
//       emergency: true,
//       availableDoctors: 12,
//       specialties: [
//         "Cardiology",
//         "Neurology",
//         "Orthopedics",
//       ],
//       image: "",
//     ),
//
//     NearbyHospitalModel(
//       id: "2",
//       name: "Apollo Hospital",
//       cityId: "ahmedabad",
//       areaId: "sg-highway",
//       villageId: "sg-1",
//       address: "SG Highway, Ahmedabad",
//       phone: "+91 7926307300",
//       latitude: 23.0359,
//       longitude: 72.5148,
//       rating: 4.8,
//       emergency: true,
//       availableDoctors: 35,
//       specialties: [
//         "Cardiology",
//         "Neurology",
//         "Oncology",
//       ],
//       image: "",
//     ),
//
//     NearbyHospitalModel(
//       id: "3",
//       name: "Zydus Hospital",
//       cityId: "ahmedabad",
//       areaId: "sg-highway",
//       villageId: "sg-1",
//       address: "SG Highway, Ahmedabad",
//       phone: "+91 7933669000",
//       latitude: 23.0340,
//       longitude: 72.5120,
//       rating: 4.6,
//       emergency: true,
//       availableDoctors: 28,
//       specialties: [
//         "Cardiology",
//         "Orthopedics",
//         "Gastroenterology",
//       ],
//       image: "",
//     ),
//
//     NearbyHospitalModel(
//       id: "4",
//       name: "Idar Civil Hospital",
//       cityId: "idar",
//       areaId: "civil-hospital",
//       villageId: "civil-1",
//       address: "Civil Hospital Road, Idar",
//       phone: "+91 2778220123",
//       latitude: 23.8390,
//       longitude: 73.0125,
//       rating: 4.0,
//       emergency: true,
//       availableDoctors: 8,
//       specialties: [
//         "General Medicine",
//         "Surgery",
//         "Pediatrics",
//       ],
//       image: "",
//     ),
//
//     NearbyHospitalModel(
//       id: "5",
//       name: "Bhailal Amin Hospital",
//       cityId: "vadodara",
//       areaId: "manjalpur",
//       villageId: "manjalpur-1",
//       address: "Manjalpur, Vadodara",
//       phone: "+91 2652332088",
//       latitude: 22.2726,
//       longitude: 73.1889,
//       rating: 4.7,
//       emergency: true,
//       availableDoctors: 18,
//       specialties: [
//         "Cardiology",
//         "Oncology",
//         "Nephrology",
//       ],
//       image: "",
//     ),
//   ];
// }