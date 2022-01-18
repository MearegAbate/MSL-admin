import 'package:admin/service/database.dart';
import 'package:admin/widget/listFile.dart';
import 'package:admin/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.uid, Key? key,
  required this.user,required this.accept
  }) : super(key: key);
  final bool user, accept;
  final String uid;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(),
          body: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('account')
                  .doc(uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) return Text('Error = ${snapshot.error}');

                if (snapshot.hasData) {
                  var data = snapshot.data!;
                  Timestamp ts = data['dateOfBirth'] as Timestamp;
                  bool empty = ts == Timestamp.fromDate(DateTime(1000, 10, 10))
                      ? true
                      : false;
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Colors.black87,
                                  Colors.black12,
                                ])),
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 250.0,
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(data['photoUrl']),
                                            radius: 80.0,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            data['fullName'],
                                            style: const TextStyle(
                                              fontSize: 22.0,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                newMethod(
                                    'Phone Number:', data['phoneNumber'] ?? ''),
                                newMethod('Email:', data['email']),
                                newMethod('Address:', data['address']),
                                newMethod('Gender:', data['sex']),
                                newMethod('Birthday:',
                                    empty ? '' : ts.toDate().toString())
                              ],
                            )),
                        const SizedBox(
                          height: 20.0,
                        ),
                     user?Container():   Column(
                          children: [

                        addList('Certificate', 'certificate'),
                        addList('Education Background', 'educationBackground'),
                        addList('Reference Material', 'referenceMaterial'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        !accept?Container():
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                            ),
                            onPressed: () async {
                              await changeState(uid);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Activate',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w700),
                            ))
                      ],
                    ),
                  );
                }
                return const Loading();
              })),
    );
  }

  Column addList(String lable, String value) {
    return Column(
      children: [
        Text(lable),
        ListFile(
          dir: value,
          uid: uid,
        ),
      ],
    );
  }

  Row newMethod(String a, String b) {
    return Row(
      children: [
        _titleBuild(a),
        _titleBuild(b),
      ],
    );
  }

  Padding _titleBuild(String title) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          title,
          maxLines: 5,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontStyle: FontStyle.normal, fontSize: 18.0),
        ));
  }
}