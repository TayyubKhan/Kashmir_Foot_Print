import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Utilis/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ref = FirebaseDatabase.instance.ref('notification');
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: back,
          ),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_outlined,
              color: back,
            ),
            Text(
              'Notifications',
              style: TextStyle(color: back),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    // Handle Firebase-specific errors
                    return Center(
                      child: Text('Error: ${snapshot.error.toString()}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    // Handle case where no data is available
                    return const Center(
                      child: Text('No data available.'),
                    );
                  } else {
                    try {
                      Map<dynamic, dynamic> map =
                          snapshot.data!.snapshot.value as dynamic;
                      List<dynamic> list = [];
                      list.clear();
                      list = map.values.toList();
                      print(list.length);
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              width: width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey.withOpacity(0.1)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.message_outlined,
                                        color: back,
                                      ),
                                      Text(
                                        list[index]['event'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    list[index]['desc'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        list[index]['image'],
                                        fit: BoxFit.fill,
                                        width: width * 0.7,
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } catch (e) {
                      // Handle any unexpected exceptions that might occur while processing the data
                      return Center(
                        child: Text('An error occurred: $e'),
                      );
                    }
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
