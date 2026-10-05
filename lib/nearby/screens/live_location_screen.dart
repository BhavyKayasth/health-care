// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:lucide_icons_flutter/lucide_icons.dart';
//
// import '../../../core/theme/app_colors.dart';
//
// class LiveLocationScreen extends StatefulWidget {
//   const LiveLocationScreen({super.key});
//
//   @override
//   State<LiveLocationScreen> createState() =>
//       _LiveLocationScreenState();
// }
//
// class _LiveLocationScreenState
//     extends State<LiveLocationScreen> {
//
//   GoogleMapController? _mapController;
//
//   static const CameraPosition _initialPosition =
//   CameraPosition(
//     target: LatLng(
//       22.3072,
//       73.1812,
//     ),
//     zoom: 14,
//   );
//
//   final Set<Marker> _markers = {
//     const Marker(
//       markerId: MarkerId("current_location"),
//       position: LatLng(
//         22.3072,
//         73.1812,
//       ),
//       infoWindow: InfoWindow(
//         title: "Your Location",
//       ),
//     ),
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         title: const Text(
//           "Live Location",
//         ),
//       ),
//
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: _initialPosition,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             zoomControlsEnabled: false,
//             markers: _markers,
//             onMapCreated: (controller) {
//               _mapController = controller;
//             },
//           ),
//
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: FloatingActionButton(
//               backgroundColor: AppColors.primary,
//               child: const Icon(
//                 LucideIcons.locateFixed,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 _mapController?.animateCamera(
//                   CameraUpdate.newCameraPosition(
//                     _initialPosition,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }