import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Utilis/colors.dart';

import '../Utilis/Call.dart';

class TouristPolice extends StatefulWidget {
  const TouristPolice({super.key});
  @override
  State<TouristPolice> createState() => _TouristPoliceState();
}

class _TouristPoliceState extends State<TouristPolice> {
  List<String> images = [
    'images/police2.png',
    'images/police3.png',
  ];
  List<String> name = [
    'Tourism Police',
    'Tourism Police Station',
  ];
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
        title: const Text(
          'Tourist Police',
          style: TextStyle(color: back),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                images[index],
                                fit: BoxFit.fill,
                              )),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            width: width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.black12)),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      name[index],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: back,
                                    ),
                                    Text(
                                      'Azad Jammu and Kashmir',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(3.0),
                                  child: Divider(
                                    color: Colors.grey,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time_rounded,
                                            color: back),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        const Text(
                                          'Open 24 Hours',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Calland_message().makePhoneCall('1422');
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Icons.phone,
                                              color:
                                                  CupertinoColors.systemBlue),
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                          const Text(
                                            '1422',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
