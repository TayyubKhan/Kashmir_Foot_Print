import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/Components/Button.dart';

import '../Utilis/Utilis.dart';
import '../Utilis/colors.dart';

class AddCarRental extends StatefulWidget {
  const AddCarRental({super.key});

  @override
  State<AddCarRental> createState() => _AddCarRentalState();
}

class _AddCarRentalState extends State<AddCarRental> {
  bool loading = false;
  List<File?> _image = [];
  final pick = ImagePicker();
  fstorage.FirebaseStorage storage = fstorage.FirebaseStorage.instance;
  DatabaseReference dB = FirebaseDatabase.instance.ref('carRental');
  final name = TextEditingController();
  final location = TextEditingController();
  final phoneNumber = TextEditingController();
  final nameNode = FocusNode();
  final locationNode = FocusNode();
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
        title: const Text('Add Car Rental Details'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: name,
                focusNode: nameNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'Shop Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35))),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(locationNode);
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextFormField(
                controller: location,
                focusNode: locationNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'location',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35))),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(phoneNumberNode);
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextFormField(
                controller: phoneNumber,
                focusNode: phoneNumberNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'Phone Number i.e +92',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35))),
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                height: height * 0.4,
                child: GridView.builder(
                    itemCount: 5,
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
                  text: 'Save',
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    int id = DateTime.now().millisecondsSinceEpoch;
                    dB.child(id.toString()).set({
                      'id': id,
                      'name': name.text.toString(),
                      'location': location.text.toString(),
                      'phone Number': phoneNumber.text.toString()
                    }).then((value) async {
                      for (int i = 0; i <= _image.length; i++) {
                        fstorage.Reference ref = fstorage
                            .FirebaseStorage.instance
                            .ref('/carRental/$id/$i');
                        fstorage.UploadTask upload =
                            ref.putFile(_image[i]!.absolute);
                        await Future.value(upload).then((value) async {
                          var newUrl = await ref.getDownloadURL();
                          // url.add(newUrl);
                          dB
                              .child(id.toString())
                              .child('image$i')
                              .set({'path': newUrl});
                        });
                        Navigator.pop(context);
                        setState(() {});
                        loading = true;
                        Utilis().toastMessage('Uploaded');
                      }
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
