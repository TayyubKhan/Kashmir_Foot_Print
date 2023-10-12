import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Utilis/colors.dart';
import 'package:myapp/view/HotelDetailScreen.dart';

class HotelScreen extends StatefulWidget {
  const HotelScreen({super.key});
  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  final ref = FirebaseDatabase.instance.ref('hotels');
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
        title: const Text('Hotels'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.04,
              ),
              Image(
                  height: height * 0.15,
                  width: width * 0.7,
                  image: const AssetImage('images/logo.png')),
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
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HotelsDetailScreen(
                                                  details: list,
                                                  index: index)));
                                },
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              list[index]['image0']['path']),
                                          width: width * 0.95,
                                          height: height * 0.3,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(20.0),
                                        height: height * 0.1,
                                        width: width * 0.6,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              list[index]['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.star,
                                                        color: Colors.yellow),
                                                    SizedBox(
                                                      width: width * 0.01,
                                                    ),
                                                    Text('4.5'),
                                                  ],
                                                ),
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  color: back,
                                                  size: 22,
                                                ),
                                                SizedBox(
                                                  width: width * 0.1,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
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
    );
  }
}
