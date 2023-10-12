import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:myapp/Components/Button.dart';

import '../FirebaseNotification.dart';
import '../Utilis/Utilis.dart';
import '../Utilis/colors.dart';

class AdminNotifications extends StatefulWidget {
  const AdminNotifications({super.key});

  @override
  State<AdminNotifications> createState() => _AdminNotificationsState();
}

class _AdminNotificationsState extends State<AdminNotifications> {
  bool loading = false;
  NotificationServices notificationServices = NotificationServices();
  List<File?> _image = [];
  final pick = ImagePicker();
  fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  DatabaseReference dB = FirebaseDatabase.instance.ref('notification');
  final eventName = TextEditingController();
  final desc = TextEditingController();
  final phoneNumber = TextEditingController();
  final eventnameNode = FocusNode();
  final descnode = FocusNode();
  final phoneNumberNode = FocusNode();
  Future getGalleryImage(int index) async {
    final pickedFile = await pick.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image.add(File(pickedFile.path));
      } else {
        debugPrint('Image not Picked');
      }
    });
  }

  final fireStore = FirebaseFirestore.instance.collection('users');

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
          'BroadCast Notification',
          style: TextStyle(color: back),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: eventName,
                focusNode: eventnameNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'Event Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35))),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(descnode);
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextFormField(
                controller: desc,
                focusNode: descnode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'Description',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35))),
                onEditingComplete: () {
                  descnode.unfocus();
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                height: height * 0.4,
                child: GridView.builder(
                    itemCount: 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          getGalleryImage(index);
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: index < _image.length
                              ? Image.file(_image[index]!.absolute)
                              : const Center(child: Icon(Icons.camera_alt)),
                        ),
                      );
                    }),
              ),
              AppButton(
                loading: loading,
                text: 'Send Notification',
                onTap: () async {
                  setState(() {});
                  loading = true;
                  final QuerySnapshot querySnapshot = await fireStore.get();
                  final List<Map<String, dynamic>> dataa = querySnapshot.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();
                  for (int i = 0; i < dataa.length; i++) {
                    var data = {
                      'to': dataa[i]['fcm_token'].toString(),
                      'notification': {
                        'title': eventName.text.toString(),
                        'body': desc.text.toString()
                      },
                      'android': {
                        'notification': {
                          'notification_count': 1,
                        },
                      },
                    };
                    await http.post(
                        Uri.parse('https://fcm.googleapis.com/fcm/send'),
                        body: jsonEncode(data),
                        headers: {
                          'Content-Type': 'application/json; charset=UTF-8',
                          'Authorization':
                              'key=AAAAtPD3hMQ:APA91bFCoM5hebAi-xhEXMFRVsnfoy4i_3khPPRNBFrknpcoOP1H8bDCUWiLXvLWQ-drhn1Lc6guSVkqX5aGuqlb7Q9mUb9KRrAnYPDnPSZvsz7-0FhV-L_ZsAS8_XakNcZC3Us0GDsj'
                        }).then((value) {
                      setState(() {});
                      loading = false;

                      if (kDebugMode) {
                        print(value.body.toString());
                      }
                    }).onError((error, stackTrace) {
                      setState(() {});
                      loading = false;

                      if (kDebugMode) {
                        print(error);
                      }
                    });
                  }
                  {
                    List<String> url = [];
                    int id = DateTime.now().millisecondsSinceEpoch;
                    fs.Reference ref =
                        fs.FirebaseStorage.instance.ref('/notification/');
                    fs.UploadTask upload = ref.putFile(_image[0]!.absolute);
                    await Future.value(upload).then((value) async {
                      var newUrl = await ref.getDownloadURL();
                      dB.child(id.toString()).set({
                        'id': id,
                        'event': eventName.text.toString(),
                        'desc': desc.text.toString(),
                        'image': newUrl
                      }).then((value) async {
                        Navigator.pop(context);
                        setState(() {});
                        loading = false;

                        Utilis().toastMessage('Uploaded');
                      });
                    });
                  }
                  // notificationServices.getDeviceToken().then((value) async {
                  //
                  // });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
