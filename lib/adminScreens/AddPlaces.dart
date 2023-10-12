// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/Components/Button.dart';

import '../Utilis/Utilis.dart';
import '../Utilis/colors.dart';

class AddPlaces extends StatefulWidget {
  const AddPlaces({super.key});
  @override
  State<AddPlaces> createState() => _AddPlacesState();
}

class _AddPlacesState extends State<AddPlaces> {
  bool loading = false;

  List<File?> _image = [];
  final pick = ImagePicker();
  fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
  DatabaseReference dB = FirebaseDatabase.instance.ref('places');
  final location = TextEditingController();
  final district = TextEditingController();
  final description = TextEditingController();
  final todo = TextEditingController();
  final locationNode = FocusNode();
  final districtNode = FocusNode();
  final descriptionNode = FocusNode();
  final todoNode = FocusNode();
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
        title: const Text(
          'Add Places',
          style: TextStyle(color: back),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: location,
                focusNode: locationNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'Location',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35))),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(districtNode);
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextFormField(
                controller: district,
                focusNode: districtNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'District',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: back, width: 2),
                        borderRadius: BorderRadius.circular(35))),
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(descriptionNode);
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextFormField(
                maxLines: 5,
                controller: description,
                focusNode: descriptionNode,
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
                  FocusScope.of(context).requestFocus(todoNode);
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              TextFormField(
                controller: todo,
                focusNode: todoNode,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: 'Activities to do',
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppButton(
                    loading: loading,
                    text: 'Save',
                    onTap: () {
                      setState(() {
                        loading = true;
                      });

                      List<String> url = [];
                      int id = DateTime.now().millisecondsSinceEpoch;
                      dB.child(id.toString()).set({
                        'id': id,
                        'description': description.text.toString(),
                        'location': location.text.toString(),
                        'district': district.text.toString(),
                        'todo': todo.text.toString()
                      }).then((value) async {
                        for (int i = 0; i <= _image.length; i++) {
                          fs.Reference ref =
                              fs.FirebaseStorage.instance.ref('/places/$id/$i');
                          fs.UploadTask upload =
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
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
