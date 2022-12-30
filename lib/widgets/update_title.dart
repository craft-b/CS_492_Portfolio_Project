import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateTitle extends StatelessWidget {
  const UpdateTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          num itemCount = 0;

          if (snapshot.hasData &&
              // ignore: unnecessary_null_comparison
              snapshot.data!.docs != null &&
              snapshot.data!.docs.isNotEmpty)
            // ignore: curly_braces_in_flow_control_structures
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              itemCount += snapshot.data!.docs[i]['quantity'];
            }

          return Text('Wasteagram - $itemCount');
        });
  }
}
