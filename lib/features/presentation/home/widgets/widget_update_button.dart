// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../core/services/widget_service.dart';
// import '../../../../core/utils/enums/loading_state.dart';
// import '../../home/controller/home_provider.dart';
//
// class WidgetUpdateButton extends StatelessWidget {
//   const WidgetUpdateButton({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<HomeProvider>(
//       builder: (context, homeProvider, child) {
//         if (homeProvider.bestSellingProductsState == LoadingState.loading) {
//           return const SizedBox(
//             height: 48,
//             width: 48,
//             child: Padding(
//               padding: EdgeInsets.all(12.0),
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//               ),
//             ),
//           );
//         }
//
//         return IconButton(
//           onPressed: () async {
//             final scaffold = ScaffoldMessenger.of(context);
//
//             try {
//               // Show loading indicator
//               scaffold.showSnackBar(
//                 const SnackBar(
//                   content: Text('Updating widget data...'),
//                   duration: Duration(milliseconds: 800),
//                 ),
//               );
//
//               // Update widget data
//               await WidgetService().updateWidgetDataFromProvider(homeProvider);
//
//               // Schedule periodic updates
//               await WidgetService().schedulePeriodicUpdates();
//
//               // Show success message
//               scaffold.showSnackBar(
//                 const SnackBar(
//                   content: Text('Widget updated successfully'),
//                   duration: Duration(seconds: 2),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             } catch (e) {
//               // Show error message
//               scaffold.showSnackBar(
//                 SnackBar(
//                   content: Text('Error updating widget: ${e.toString()}'),
//                   duration: const Duration(seconds: 3),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//           icon: const Icon(Icons.widgets_outlined),
//           tooltip: 'Update Home Screen Widget',
//         );
//       },
//     );
//   }
// }