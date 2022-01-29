import 'package:admin/pages/profile.dart';
import 'package:admin/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisableAccount extends StatelessWidget {
  const DisableAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('complain').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.docs;
            return data.isEmpty
                ? const Center(
                    child: Text('No Complain'),
                  )
                : FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future:
                        FirebaseFirestore.instance.collection('disable').get(),
                    builder: (context, snapShot) {
                      if (snapShot.hasData) {
                        final a = snapShot.data!;
                        final allData = a.docs.map((doc) => doc.id).toList();
                        return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              String id = data[index]['to'];
                              String who = data[index]['who'];
                              if (allData.contains(id)) {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text('No Active Complain'),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                                  uid: id,
                                                  accept: false,
                                                  disable: true,
                                                  user: who == 'User'
                                                      ? true
                                                      : false,
                                                ))),
                                    child: ListTile(
                                      title: Text(id),
                                      subtitle: Text(data[index]['message']),
                                      trailing: Text(who),
                                    ),
                                  ),
                                );
                              }
                            });
                      }
                      return const Loading();
                    });
          }
          if (snapshot.hasError) {
            throw Exception(snapshot.error);
          }
          return const Loading();
        });
  }
}