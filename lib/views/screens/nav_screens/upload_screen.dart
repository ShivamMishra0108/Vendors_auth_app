import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  //Create an instance to pick image
  final ImagePicker picker = ImagePicker();

  // Make a list to store the picked images:
  List<File> images = [];

  // Define a function to choose image form gallery:
  chooseImage() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    // If file picked is empty
    if (PickedFile == null) {
      print("No image Picked");
    }
    // If image is picked add it in the list and update to the state(UI):
    else {
      images.add(File(PickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true, // Allow the grid to fit in the content
              itemCount:
                  images.length +
                  1, // numbers of images in list plus one to ADD NEW ONE:
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 3,
                mainAxisSpacing: 4,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return index == 0
                    ?
                      // If there is no image (THE LIST IS EMPTY):
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize:  const Size(10, 10),
        
                          
                        ),
                        onPressed: chooseImage,
                        child: Icon(Icons.add),
                      )
                    : SizedBox(
                        height: 50,
                        width: 40,
                        child: Image.file(images[index - 1]),
                      );
              },
            ),
            SizedBox(height: 15,),
            SizedBox(
              width: 200,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter Product Name",
                  labelText: "Enter Product Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter Product Price",
                  labelText: "Enter Product Price",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
        
            SizedBox(
              width: 200,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Enter Product Quantity",
                  labelText: "Enter Product Quantity",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
        
            SizedBox(
              width: 400,
              child: TextFormField(
                maxLength: 500,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter Product Descriptioin",
                  labelText: "Enter Product Description",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
