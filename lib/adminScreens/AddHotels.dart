import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/Components/Button.dart';

import '../Utilis/Utilis.dart';
import '../Utilis/colors.dart';

class AddHotels extends StatefulWidget {
  const AddHotels({super.key});

  @override
  State<AddHotels> createState() => _AddHotelsState();
}

class _AddHotelsState extends State<AddHotels> {
  bool loading = false;
  List<File?> _image = [];
  final pick = ImagePicker();
  fstorage.FirebaseStorage storage = fstorage.FirebaseStorage.instance;
  DatabaseReference dB = FirebaseDatabase.instance.ref('hotels');
  final name = TextEditingController();
  final duration = TextEditingController();
  final price = TextEditingController();
  final phoneNumber = TextEditingController();
  final nameNode = FocusNode();
  final durationNode = FocusNode();
  final priceNode = FocusNode();
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
        title: const Text('Add Hotel Details'),
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
                    hintText: 'Hotel Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35))),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(durationNode);
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextFormField(
                controller: duration,
                focusNode: durationNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'Duration',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35))),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(priceNode);
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextFormField(
                controller: price,
                focusNode: priceNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'Price',
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
                      'duration': duration.text.toString(),
                      'price': price.text.toString(),
                      'phone Number': phoneNumber.text.toString()
                    }).then((value) async {
                      for (int i = 0; i <= _image.length; i++) {
                        fstorage.Reference ref = fstorage
                            .FirebaseStorage.instance
                            .ref('/hotels/$id/$i');
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
                        setState(() {});
                        loading = false;
                        Navigator.pop(context);

                        Utilis().toastMessage('Uploaded');
                      }
                    });
                    setState(() {});
                    loading = false;
                  })
            ],
          ),
        ),
      ),
    );
  }
}
