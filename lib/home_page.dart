import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_input/d_input.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ref = FirebaseFirestore.instance.collection('users').doc('me');
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser;
  final nameController = TextEditingController();

  void updateName() {
    final name = nameController.text;
    if (name == '') return;

    ref.update({
      'name': name,
    });
  }

  @override
  void initState() {
    streamUser = ref.snapshots();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realtime Firestore'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Name:',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Gap(4),
          StreamBuilder(
            stream: streamUser,
            builder: (context, snapshot) {
              final user = snapshot.data?.data();
              return Text(
                user?['name'] ?? '-',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black87,
                ),
              );
            },
          ),
          Gap(30),
          DInputMix(
            controller: nameController,
            hint: 'Type new name',
            inputOnChanged: (value) {
              updateName();
            },
            suffixIcon: IconSpec(
              icon: Icons.check,
              onTap: updateName,
            ),
          ),
        ],
      ),
    );
  }
}
