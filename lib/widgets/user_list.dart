// import 'package:flutter/material.dart';


// class CustomerLists extends StatelessWidget {
//   final Future<List<UserModel>> customerLists;
//   CustomerLists({required this.customerLists});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: FutureBuilder<List<UserModel>>(
//         future: customerLists,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             if (snapshot.data?.length == 0) {
//               return Center(child: Text('ยังไม่มีรายชื่อลูกค้า'));
//             } else {
//               return ListView.builder(
//                 itemCount: snapshot.data?.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     leading: Text(snapshot.data![index].name),
//                     trailing: Text(snapshot.data![index].age.toString()),
//                   );
//                 },
//               );
//             }
//           }
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
// }
