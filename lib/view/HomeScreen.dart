import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Utilis/colors.dart';
import 'package:myapp/view/Places%20Detail.dart';
import 'package:myapp/view/Setting%20Screen.dart';
import 'package:myapp/view/UtilitiesScreen.dart';

import '../FirebaseNotification.dart';
import 'NotificationScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.foregroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }

  final ref = FirebaseDatabase.instance.ref('places');
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return WillPopScope(
      onWillPop: () async {
        // Return true to allow back navigation, or false to disable it
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SettingScreen()));
                        },
                        child: const Icon(Icons.menu)),
                    Image(
                        height: height * 0.15,
                        width: width * 0.7,
                        image: const AssetImage('images/logo.png')),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationScreen()));
                      },
                      child: const Icon(
                        Icons.notifications,
                        color: back,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: height * 0.06,
                        width: width * 0.4,
                        decoration: BoxDecoration(
                            color: back,
                            borderRadius: BorderRadius.circular(35)),
                        child: const Center(
                          child: Text(
                            'Map',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UtilitiesScreen()));
                      },
                      child: Container(
                        height: height * 0.06,
                        width: width * 0.4,
                        decoration: BoxDecoration(
                            color: back,
                            borderRadius: BorderRadius.circular(35)),
                        child: const Center(
                          child: Text(
                            'Utilities',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.04,
                ),
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
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.black12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlacesDetailScreen(
                                                      details: list,
                                                      index: index)));
                                    },
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                list[index]['image0']['path']),
                                            width: width * 0.4,
                                            height: height * 0.1,
                                          ),
                                        ),
                                        SizedBox(width: width * 0.02),
                                        Column(
                                          children: [
                                            Text(
                                              list[index]['location'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                    Icons.location_on_outlined,
                                                    color: back),
                                                Text(
                                                  list[index]['district'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
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
      ),
    );
  }
}
