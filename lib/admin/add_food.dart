import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_app/service/database.dart';
import 'package:food_app/widgets/widget_support.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final List<String> items = ['Ice-cream', 'Burger', 'Salad', 'Pizza'];
  String? value;
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController pricecontoller = new TextEditingController();
  TextEditingController detailcontoller = new TextEditingController();
  final ImagePicker _picker= ImagePicker();
  File? selectedImage;


Future getImage()async{
  var image = await _picker.pickImage(source: ImageSource.gallery);

  selectedImage= File(image!.path);
  setState(() {
    
  });
}

uploadItem()async{
  if(selectedImage!=null&& namecontroller.text!=""&&pricecontoller.text!=""&& detailcontoller.text!=""){
    String addId= randomAlphaNumeric(10);

    Reference firebaseStorageRef= FirebaseStorage.instance.ref().child("blogImages").child(addId);
    final UploadTask task= firebaseStorageRef.putFile(selectedImage!);

    var downloadUrl= await(await task).ref.getDownloadURL();

    Map<String, dynamic> addItem={
      "Image": downloadUrl,
      "Name":namecontroller.text,
      "Price":pricecontoller.text,
      "Detail":detailcontoller.text,
    };
    await DatabaseMethods().addFoodItem(addItem, value!).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Food Item has added Successfully",
              style: TextStyle(fontSize: 18),
            )));
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Color(0xFF373866),
            )),
        centerTitle: true,
        title: Text(
          "Add Item",
          style: AppWidget.HeaderTextFieldStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload the Item Picture",
                style: AppWidget.SemiboldTextFieldStyle(),
              ),
              const SizedBox(
                height: 50,
              ),
              selectedImage==null? GestureDetector(
                onTap: (){
                  getImage();
                },
                child: Center(
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ):Center(
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        selectedImage!
                        ,fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                "Item Name",
                style: AppWidget.SemiboldTextFieldStyle(),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xFFeceef8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter the Item Name",
                    hintStyle: AppWidget.LightTextFieldStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Item Price",
                style: AppWidget.SemiboldTextFieldStyle(),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xFFeceef8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: pricecontoller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter the Item Price",
                    hintStyle: AppWidget.LightTextFieldStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Item Detail",
                style: AppWidget.SemiboldTextFieldStyle(),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xFFeceef8),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: detailcontoller,
                  maxLines: 6,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter the Item Details",
                    hintStyle: AppWidget.LightTextFieldStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Select Category",
                style: AppWidget.SemiboldTextFieldStyle(),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                          )))
                      .toList(),
                  onChanged: ((value) => setState(() {
                        this.value = value;
                      })),
                  dropdownColor: Colors.white,
                  hint: const Text("Select Category"),
                  iconSize: 36,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  value: value,
                )),
              ),
              const SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  uploadItem();
                },
                child: Center(
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
