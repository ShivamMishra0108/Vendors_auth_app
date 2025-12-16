import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_app/controller/category_controller.dart';
import 'package:vendor_app/controller/subCategory_controller.dart';
import 'package:vendor_app/models/category.dart';
import 'package:vendor_app/models/subCategory.dart';

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

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late Future<List<Category>> futureCategories;
  late String name;
  Category? selectedCategory;
  Future<List<Subcategory>>? futureSubCategories;
  Subcategory? selectedSubCategory;

  Future<void> fetchAllCategory() async {
    futureCategories = CategoryController().loadCategories();
  }

  @override
  void initState() {
    super.initState();
    fetchAllCategory();
  }

  getSubCategoryByCategory(value){
    futureSubCategories = SubcategoryController().getSubCategoryByCategory(value.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formkey,
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
                          Center(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: chooseImage,
                                child: Center(child: Icon(Icons.add, size: 20)),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 50,
                            width: 40,
                            child: Image.file(images[index - 1]),
                          );
                  },
                ),
                SizedBox(height: 15),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    validator: (value) {
                      if(value!.isEmpty){
                        return "Enter Product Name";
                      }else{
                        return null;
                      }
                    },
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
                      validator: (value) {
                      if(value!.isEmpty){
                        return "Enter Product Price";
                      }else{
                        return null;
                      }
                    },
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
                      validator: (value) {
                      if(value!.isEmpty){
                        return "Enter Product Quantity";
                      }else{
                        return null;
                      }
                    },
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
                      validator: (value) {
                      if(value!.isEmpty){
                        return "Enter Product Description";
                      }else{
                        return null;
                      }
                    },
                    maxLength: 500,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Enter Product Descriptioin",
                      labelText: "Enter Product Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                    
                 Divider(color: Colors.grey.shade900),
                    
                FutureBuilder<List<Category>>(
                  future: futureCategories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No categories"));
                    }
                    
                    return DropdownButton<Category>(
                      value: selectedCategory,
                      hint: const Text('Select Category'),
                      items: snapshot.data!.map((Category category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                        getSubCategoryByCategory(selectedCategory);
                        print(selectedCategory!.name);
                      },
                    );
                  },
                ),
            
                SizedBox(height: 10,),
            
                FutureBuilder<List<Subcategory>>(
                  future: futureSubCategories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No Sub categories"));
                    }
                    
                    return DropdownButton<Subcategory>(
                      value: selectedSubCategory,
                      hint: const Text('Select Category'),
                      items: snapshot.data!.map((Subcategory subcategory) {
                        return DropdownMenuItem(
                          value: subcategory,
                          child: Text(subcategory.subCategoryName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSubCategory = value;
                        });
                   
                        print(selectedCategory!.name);
                      },
                    );
                  },
                ),
            
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: (){
                        if(_formkey.currentState!.validate()){
                           print("Uploaded");
                        }else{
                          print( "Enter all Fields");
                        };
                      },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      
                      child: Center(child: Text("Upload Product",
                       style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                        ),
                        ),),
                               
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
